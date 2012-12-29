(*
-------------------------------------------------------------------

 riak_http.ml: Riak OCaml Client

 Copyright (c) 2012 Dave Parfitt
 All Rights Reserved.

 This file is provided to you under the Apache License,
 Version 2.0 (the "License"); you may not use this file
 except in compliance with the License.  You may obtain
 a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the Licese is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
-------------------------------------------------------------------
*)


open Riak_messages_piqi
open Riak_messages_piqi_ext

type http_error_code = int
type http_error_desc = string

exception RiakHTTPError of http_error_code * http_error_desc;;

let http_ok = 200
let http_multiple_choices = 300
let http_not_modified = 304

type riak_http_paths =
  | Riak_Http_New (* the default *)
  | Riak_Http_Old

type riak_http_connection_params = {
  http_protocol : string; (* http/https *)
  http_hostname : string;
  http_port : int;
  http_url_paths : riak_http_paths;
}

let new_riak_http_connection_params hostname port = {
  http_protocol = "http";
  http_hostname = hostname;
  http_port = port;
  http_url_paths = Riak_Http_New;
}

let base_url cparams =
  cparams.http_protocol ^ "://" ^ cparams.http_hostname ^ ":" ^ (string_of_int(cparams.http_port))

let fetch_url cparams bucket key paramstring =
  (base_url cparams) ^  "/buckets/" ^ bucket ^ "/keys/" ^ key ^ paramstring

let store_url cparams bucket key paramstring =
  let prefix = (base_url cparams)  ^ "/buckets/" ^ bucket ^ "/keys" in
  match key with
    | None -> prefix
    | Some key -> prefix ^ "/" ^ key

type riak_http_fetch_option =
  | Http_Fetch_r of int
  | Http_Fetch_pr of int
  | Http_Fetch_basic_quorum of bool
  | Http_Fetch_notfound_ok of bool
  | Http_Fetch_all_siblings
  | Http_Fetch_vtag of string
  (*| Get_if_modified of string
  | Get_head of bool
  | Get_deleted_vclock of bool*)

type riak_http_content_type =
  | Content_Type_text_plain
  | Content_Type_application_json
  | Content_Type_user_defined of string

type riak_http_store_option =
  | Http_Store_w of int
  | Http_Store_dw of int
  | Http_Store_pw of int
  | Http_Store_return_body of bool
  | Http_Store_if_none_match
  | Http_Store_if_match
  | Http_Store_if_modified_since
  | Http_Store_if_unmodified_since
  | Http_Store_content_type of riak_http_content_type


(* TODO: will need valid escape, etc *)
let make_param name value =
  name ^ "=" ^ value

(* TODO: escape, etc*)
let join_params params =
  String.concat "&" params

let http_fetch_options opts =
  let rec process_http_fetch_options opts params headers =
    match opts with
        [] -> (params, headers)
      | (o::os) ->
          match o with
            | Http_Fetch_r v ->
                let param = make_param "r" (string_of_int(v)) in
                let nextreq = param :: params in
                  process_http_fetch_options os nextreq headers
            | Http_Fetch_pr v ->
                let param = make_param "pr"  (string_of_int(v)) in
                let nextreq = param :: params in
                  process_http_fetch_options os nextreq headers
            | Http_Fetch_basic_quorum v ->
                let param = make_param "basic_quorum" (string_of_bool(v)) in
                let nextreq = param :: params in
                  process_http_fetch_options os nextreq headers
            | Http_Fetch_notfound_ok v ->
                let param = make_param "notfound_ok" (string_of_bool(v)) in
                let nextreq = param :: params in
                  process_http_fetch_options os nextreq headers
            | Http_Fetch_vtag v ->
                let param = make_param "vtag" v  in
                let nextreq = param :: params in
                  process_http_fetch_options os nextreq headers
            | Http_Fetch_all_siblings ->
                let nextheaders = "Accept: multipart/mixed" :: headers in
                  process_http_fetch_options os params nextheaders in
  let (params, headers) = process_http_fetch_options opts [] [] in
  match (List.length params) with
    | 0 -> ("", headers)
    | _ ->
        let joined = join_params params in
        let paramstring = "?" ^ joined in
        (paramstring, headers)

let writer accum data =
  Buffer.add_string accum data;
  String.length data

let getContent connection url =
  Curl.set_url connection url;
  Curl.perform connection

let http_init () =
  Curl.global_init Curl.CURLINIT_GLOBALALL

let http_term () =
  Curl.global_cleanup()

let http_op url connfun expected_response_codes =
  let result = Buffer.create 1024
  and errorBuffer = ref "" in
    try
      let connection = Curl.init () in
        Curl.set_errorbuffer connection errorBuffer;
        Curl.set_writefunction connection (writer result);
        Curl.set_followlocation connection true;
        Curl.set_url connection url;
        (match connfun with
           | None -> ()
           | Some cf -> cf connection);
        Curl.perform connection;
        let response_code = Curl.get_responsecode connection in
          print_endline ("Response code = " ^ string_of_int(response_code));
          Curl.cleanup connection;
          match List.mem response_code expected_response_codes with
            | true -> (response_code, Buffer.contents result)
            | false -> raise (RiakHTTPError(response_code, Buffer.contents result));
    with
      | Curl.CurlException (reason, code, str) ->
          Printf.fprintf stderr "Error: %s\n" !errorBuffer;
          (* TODO: check this *)
          (code, str)
      | Failure s ->
          Printf.fprintf stderr "Caught exception: %s\n" s;
          (500, s)

(* 406 means allow_mult on a bucket probably isn't set *)
let riak_http_fetch cparams bucket key options =
  let expected_codes = [200; 300; 304] in
  let (paramstring, headers) = http_fetch_options options in
  let connfun conn = Curl.set_httpheader conn headers in
  let url = fetch_url cparams bucket key paramstring in
    http_op url (Some connfun) expected_codes

(* lots of parameters! should I restructure this? *)
let riak_http_store cparams bucket key vclock options =
  (* also: Meta headers, Indexes, Links *)
  true

let riak_http_store_json cparams bucket key vclock options =
  let ct = (Http_Store_content_type Content_Type_application_json :: options) in
  riak_http_store cparams bucket key vclock ct

let riak_http_store_text cparams bucket key vclock options =
  let ct = (Http_Store_content_type Content_Type_text_plain :: options) in
  riak_http_store cparams bucket key vclock ct

let _ =
  http_init();
  let cparams = new_riak_http_connection_params "localhost" 8091 in
  let (code, result) = riak_http_fetch cparams "test" "doc" [] in
    print_endline result;
  (*let result = http_op "http://localhost:8091/" in
    print_endline result;*)
    (*let opts = Piqirun_ext.make_options ~use_strict_parsing:false () in*)
    (*let _foo = (Riak_messages_piqi_ext.parse_httplistresources_response result `json ) in
      print_endline "----------------";
      (*List.iter (fun v -> print_endline v)
        (foo.Httplistresources_response.riak_kv_wm_buckets);*)
     *)

   http_term()

