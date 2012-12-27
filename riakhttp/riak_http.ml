(*module RP = Riak_messages_piqi_ext*)
open Riak_messages_piqi
open Riak_messages_piqi_ext

 type riak_http_get_option =
  | Http_Get_r of int
  | Http_Get_pr of int
  | Http_Get_basic_quorum of bool
  | Http_Get_notfound_ok of bool
  | Http_Get_all_siblings
  | Http_Get_vtag of string
  (*| Get_if_modified of string
  | Get_head of bool
  | Get_deleted_vclock of bool*)

let http_get_options opts =
  let rec process_http_get_options opts params headers =
    match opts with
        [] -> (params, headers)
      | (o::os) ->
          match o with
            | Http_Get_r v ->
                let param = "r=" ^ string_of_int(v) in
                let nextreq = param :: params in
                  process_http_get_options os nextreq headers
            | Http_Get_pr v ->
                let param = "pr=" ^ string_of_int(v) in
                let nextreq = param :: params in
                  process_http_get_options os nextreq headers
            | Http_Get_basic_quorum v ->
                let param = "basic_quorum=" ^ string_of_bool(v) in
                let nextreq = param :: params in
                  process_http_get_options os nextreq headers
            | Http_Get_notfound_ok v ->
                let param = "notfound_ok=" ^ string_of_bool(v) in
                let nextreq = param :: params in
                  process_http_get_options os nextreq headers
            | Http_Get_vtag v ->
                let param = "vtag=" ^ v in
                let nextreq = param :: params in
                  process_http_get_options os nextreq headers
            | Http_Get_all_siblings ->
                let nextheaders = "Accept: multipart/mixed" :: headers in
                  process_http_get_options os params nextheaders in
  let (params, headers) = process_http_get_options opts [] [] in
  match (List.length params) with
    | 0 -> ("", headers)
    | _ -> 
        let joined = String.concat "&" params in
        let paramstring = "?" ^ joined in
        (paramstring, headers)


let writer accum data =
  Buffer.add_string accum data;
  String.length data

(*let showContent content =
  Printf.printf "%s" (Buffer.contents content);
  flush stdout *)

let getContent connection url =
  Curl.set_url connection url;
  Curl.perform connection

let http_init () =
  Curl.global_init Curl.CURLINIT_GLOBALALL

let http_term () =
  Curl.global_cleanup()

let http_op url connfun =
    let result = Buffer.create 16384
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
        (*Curl.set_httpheader connection ["Accept: application/json"];*)
        Curl.perform connection;
        (*showContent result;*)
        Curl.cleanup connection;
        Buffer.contents result
    with
      | Curl.CurlException (reason, code, str) ->
        Printf.fprintf stderr "Error: %s\n" !errorBuffer;
        ""
      | Failure s ->
        Printf.fprintf stderr "Caught exception: %s\n" s;
        ""

let riak_http_get bucket key options =
  let (paramstring, headers) = http_get_options options in
  let connfun conn = Curl.set_httpheader conn headers in
  let url = ("http://localhost:8091/buckets/" ^ bucket ^ "/keys/" ^ key ^ paramstring) in
    print_endline url;
    http_op url (Some connfun)

let riak_http_get_old key =
  true

let _ =
  http_init();
  let result = riak_http_get "test" "doc" [Http_Get_r 1] in
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

