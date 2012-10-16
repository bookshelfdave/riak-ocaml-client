(*
-------------------------------------------------------------------

 riak.ml: Riak OCaml Client

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

open Riak_piqi
open Riak_search_piqi
module KV = Riak_kv_piqi
open Sys
open Lwt
open Lwt_unix

let riak_ocaml_client_version = "0.9"

let rpbErrorResp          = 0
let rpbPingReq            = 1  (* 0 length *)
let rpbPingResp           = 2  (* pong - 0 length *)
let rpbGetClientIdReq     = 3
let rpbGetClientIdResp    = 4
let rpbSetClientIdReq     = 5
let rpbSetClientIdResp    = 6
let rpbGetServerInfoReq   = 7
let rpbGetServerInfoResp  = 8
let rpbGetReq             = 9
let rpbGetResp            = 10
let rpbPutReq             = 11
let rpbPutResp            = 12  (* 0 length *)
let rpbDelReq             = 13
let rpbDelResp            = 14
let rpbListBucketsReq     = 15
let rpbListBucketsResp    = 16
let rpbListKeysReq        = 17
let rpbListKeysResp       = 18
let rpbGetBucketReq       = 19
let rpbGetBucketResp      = 20
let rpbSetBucketReq       = 21
let rpbSetBucketResp      = 22
let rpbMapRedReq          = 23
let rpbMapRedResp         = 24
let rpbIndexReq           = 25
let rpbIndexResp          = 26
let rpbSearchQueryReq     = 27
let rbpSearchQueryResp    = 28

exception RiakException of string * Riak_piqi.uint32
exception RiakSiblingException of string

type riak_object = {
  obj_value : string option;
  obj_vclock : string option;
  obj_bucket : string;
  obj_key : string option;
  obj_exists : bool;
}

type riak_connection_options = {
  riak_conn_use_nagal : bool;
  riak_conn_retries : int;
  riak_conn_resolve_conflicts : (riak_object list -> riak_object option)
}

type riak_connection = {
  host : string;
  port : int;
  sock : file_descr;
  inc : Lwt_io.input_channel;
  outc : Lwt_io.output_channel;
  debug : bool;
  clientid : string option;
  conn_options : riak_connection_options;
}

type riak_bucket = string
type riak_key = string
type riak_client_id = string
type riak_mr_query = string
type riak_mr_content_type = Riak_MR_Json | Riak_MR_Erlang
type riak_2i_name = string
type riak_2i_range_min = string
type riak_2i_range_max = string
type riak_search_query = string
type riak_search_index = string
type riak_node_id = string
type riak_version = string
type riak_vclock = string

let get_mr_content_type ct =
  match ct with
    | Riak_MR_Json -> "application/json"
    | Riak_MR_Erlang -> "application/x-erlang-binary"

type riak_tunable_cap =
  | Riak_value_one
  | Riak_value_quorum
  | Riak_value_all
  | Riak_value_default
  | Riak_value of Riak_kv_piqi.uint32

(* TODO - VERIFY these numbers! *)
let get_riak_tunable_cap v =
  match v with
    | Riak_value_one     -> -2l
    | Riak_value_quorum  -> -3l
    | Riak_value_all     -> -4l
    | Riak_value_default -> -5l
    | Riak_value n       -> n


type riak_get_option =
  | Get_r of riak_tunable_cap
  | Get_pr of riak_tunable_cap
  | Get_basic_quorum of bool
  | Get_notfound_ok of bool
  | Get_if_modified of string
  | Get_head of bool
  | Get_deleted_vclock of bool

type riak_put_option =
  | Put_w of riak_tunable_cap
  | Put_dw of riak_tunable_cap
  | Put_return_body of bool
  | Put_pw of riak_tunable_cap
  | Put_if_not_modified of bool
  | Put_if_none_match of bool
  | Put_return_head of bool

type riak_del_option =
  | Del_rw of riak_tunable_cap
  | Del_vclock of string
  | Del_r of riak_tunable_cap
  | Del_w of riak_tunable_cap
  | Del_pr of riak_tunable_cap
  | Del_pw of riak_tunable_cap
  | Del_dw of riak_tunable_cap

type riak_search_option =
  | Search_rows of Riak_kv_piqi.uint32
  | Search_start of Riak_kv_piqi.uint32
  | Search_sort of string
  | Search_filter of string
  | Search_df of string
  | Search_op of string
  | Search_fl of string list
  | Search_presort of string

let  (|>) x f = f x

let new_content value =
  { Riak_kv_piqi.Rpb_content.value = value;
    Riak_kv_piqi.Rpb_content.content_type = None;
    Riak_kv_piqi.Rpb_content.charset = None;
    Riak_kv_piqi.Rpb_content.content_encoding = None;
    Riak_kv_piqi.Rpb_content.vtag = None;
    Riak_kv_piqi.Rpb_content.links = [];
    Riak_kv_piqi.Rpb_content.last_mod = None;
    Riak_kv_piqi.Rpb_content.last_mod_usecs = None;
    Riak_kv_piqi.Rpb_content.usermeta = [];
    Riak_kv_piqi.Rpb_content.indexes = [];
    Riak_kv_piqi.Rpb_content.deleted = None;}

let new_get_req bucket key =
  {
    Riak_kv_piqi.Rpb_get_req.bucket = bucket;
    Riak_kv_piqi.Rpb_get_req.key = key;
    Riak_kv_piqi.Rpb_get_req.r =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_get_req.pr =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_get_req.basic_quorum = None;
    Riak_kv_piqi.Rpb_get_req.notfound_ok = None;
    Riak_kv_piqi.Rpb_get_req.if_modified = None;
    Riak_kv_piqi.Rpb_get_req.head = None;
    Riak_kv_piqi.Rpb_get_req.deletedvclock = None;
  }

let new_put_req bucket key value vclock =
  {
    Riak_kv_piqi.Rpb_put_req.bucket = bucket;
    Riak_kv_piqi.Rpb_put_req.key = key;
    Riak_kv_piqi.Rpb_put_req.vclock = vclock;
    Riak_kv_piqi.Rpb_put_req.content = (new_content value);
    Riak_kv_piqi.Rpb_put_req.w =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_put_req.dw =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_put_req.pw =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_put_req.return_body = None;
    Riak_kv_piqi.Rpb_put_req.if_not_modified = None;
    Riak_kv_piqi.Rpb_put_req.if_none_match = None;
    Riak_kv_piqi.Rpb_put_req.return_head = None;
  }

let new_del_req bucket key =
  {
    Riak_kv_piqi.Rpb_del_req.bucket = bucket;
    Riak_kv_piqi.Rpb_del_req.key = key;
    Riak_kv_piqi.Rpb_del_req.rw = None;
    Riak_kv_piqi.Rpb_del_req.vclock = None;
    Riak_kv_piqi.Rpb_del_req.r =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_del_req.w =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_del_req.pr =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_del_req.pw =
      Some (get_riak_tunable_cap Riak_value_default);
    Riak_kv_piqi.Rpb_del_req.dw =
      Some (get_riak_tunable_cap Riak_value_default);
  }

let new_list_keys_req bucket =
  {
    Riak_kv_piqi.Rpb_list_keys_req.bucket = bucket
  }

let new_index_req bucket index qtype =
{
  Riak_kv_piqi.Rpb_index_req.bucket = bucket;
  Riak_kv_piqi.Rpb_index_req.index  = index;
  Riak_kv_piqi.Rpb_index_req.qtype  = qtype;
  Riak_kv_piqi.Rpb_index_req.key = None;
  Riak_kv_piqi.Rpb_index_req.range_min = None;
  Riak_kv_piqi.Rpb_index_req.range_max = None;
}

let new_riak_object bucket =
  {
    obj_value = None;
    obj_vclock = None;
    obj_bucket = bucket;
    obj_key = None;
    obj_exists = false;
  }

let new_search_query_req q index =
  {
    Rpb_search_query_req.q = q;
    Rpb_search_query_req.index = index;
    Rpb_search_query_req.rows = None;
    Rpb_search_query_req.start = None;
    Rpb_search_query_req.sort = None;
    Rpb_search_query_req.filter = None;
    Rpb_search_query_req.df = None;
    Rpb_search_query_req.op = None;
    Rpb_search_query_req.fl = [];
    Rpb_search_query_req.presort = None;
  }

let rec process_get_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Get_r v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.r =
                  Some (get_riak_tunable_cap v) }
        | Get_pr v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.pr =
                  Some (get_riak_tunable_cap v) }
        | Get_basic_quorum v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.basic_quorum =
                  Some v }
        | Get_notfound_ok v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.notfound_ok =
                  Some v }
        | Get_if_modified v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.if_modified =
                  Some v }
        | Get_head v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.head =
                  Some v }
        | Get_deleted_vclock v ->
            process_get_options os
              { req with Riak_kv_piqi.Rpb_get_req.deletedvclock =
                  Some v }


let rec process_put_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Put_w v ->
          process_put_options os
            { req with Riak_kv_piqi.Rpb_put_req.w =
                Some (get_riak_tunable_cap v) }
        | Put_dw v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.dw =
                  Some (get_riak_tunable_cap v) }
        | Put_return_body v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.return_body =
                  Some v }
        | Put_pw v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.pw =
                  Some (get_riak_tunable_cap v) }
        | Put_if_not_modified v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.if_not_modified =
                  Some v }
        | Put_if_none_match v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.if_none_match =
                  Some v }
        | Put_return_head v ->
            process_put_options os
              { req with Riak_kv_piqi.Rpb_put_req.return_head =
                  Some v }

let rec process_del_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Del_rw v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.rw =
                  Some (get_riak_tunable_cap v) }
        | Del_vclock v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.vclock =
                  Some v }
        | Del_r v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.r =
                  Some (get_riak_tunable_cap v) }
        | Del_w v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.w =
                  Some (get_riak_tunable_cap v) }
        | Del_pr v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.pr =
                  Some (get_riak_tunable_cap v) }
        | Del_pw v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.pw =
                  Some (get_riak_tunable_cap v) }
        | Del_dw v ->
            process_del_options os
              { req with Riak_kv_piqi.Rpb_del_req.dw =
                  Some (get_riak_tunable_cap v) }


let rec process_search_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Search_rows v ->
          process_search_options os { req with Rpb_search_query_req.rows = Some v }
        | Search_start v ->
          process_search_options os { req with Rpb_search_query_req.start = Some v }
        | Search_sort v ->
          process_search_options os { req with Rpb_search_query_req.sort = Some v }
        | Search_filter v ->
          process_search_options os { req with Rpb_search_query_req.filter = Some v }
        | Search_df v ->
          process_search_options os { req with Rpb_search_query_req.df = Some v }
        | Search_op v ->
          process_search_options os { req with Rpb_search_query_req.op = Some v }
        | Search_fl v ->
          process_search_options os { req with Rpb_search_query_req.fl = v }
        | Search_presort v ->
          process_search_options os { req with Rpb_search_query_req.presort = Some v }

let string_of_option v =
  match v with
    | None -> ""
    | Some value -> value

let debug conn msg =
  match conn.debug with
    | true -> print_endline(msg)
    | false -> ()

let set_nagle fd newval =
  try setsockopt fd TCP_NODELAY newval
  with Unix.Unix_error (e, _, _) ->
    print_endline ("Error setting TCP_NODELAY" ^ (Unix.error_message e))

(* The default conflict resolver.
 * You probably don't want to use this as it will
 * throw an exception if it finds siblings with bucket property
 * allow_mult = true
 *)
let default_resolver items =
  match items with
    | [] -> None
    | hd :: [] -> Some hd
    | _ -> raise (RiakSiblingException "Siblings found - cannot resolve")

let riak_connection_defaults =
  {
    riak_conn_use_nagal = false;
    riak_conn_retries = 3;
    riak_conn_resolve_conflicts = default_resolver;
  }

let send_msg (conn:riak_connection) (req:Piqirun.OBuf.t option) (reqid:int) =
  let reqlen = match req with
    | Some req -> Piqirun.OBuf.size req + 1
    | None -> 1
  in
  lwt _ = Lwt_chan.output_binary_int conn.outc reqlen in
  lwt _ = Lwt_io.write_char conn.outc (Char.unsafe_chr reqid) in
  lwt _ = match req with
    | Some req -> Lwt_io.write conn.outc (Piqirun.to_string req)
    | None -> return ()
  in
  Lwt_io.flush conn.outc


(* returns Piqirun.t *)
(* TODO: THIS NEEDS CLEANUP! *)
let recv_msg (conn:riak_connection) (respid:int) =
  lwt resplength = Lwt_chan.input_binary_int conn.inc in
  lwt mcode = map Char.code (Lwt_io.read_char conn.inc) in
  debug conn ("Length = " ^ (string_of_int resplength));
  debug conn ("MC = " ^ (string_of_int mcode));
  let buf = String.create (resplength-1) in
  lwt _ = Lwt_chan.really_input conn.inc buf 0 (resplength-1) in
  debug conn buf;
  let resp = Piqirun.init_from_string(buf) in
  match mcode with
    | 0 ->
      (let err = parse_rpb_error_resp resp in
       raise (RiakException (err.Rpb_error_resp.errmsg,
                             err.Rpb_error_resp.errcode)))
    | x when x = respid -> return resp
    | _ ->
      raise (RiakException ("Unknown response code",-1l))

let send_pb_message (conn:riak_connection) (req:Piqirun.OBuf.t option) (reqid:int) (respid:int) =
  lwt _ = send_msg conn req reqid in
  recv_msg conn respid

let rec recv_more conn respid predicate acc =
  lwt pbresp = recv_msg conn respid in
  match (predicate pbresp) with
    | (false, None) -> recv_more conn respid predicate acc
    | (false, Some keys) -> recv_more conn respid predicate (keys::acc)
    | (true, None) -> return acc
    | (true, Some keys) -> return (keys::acc)

let send_pb_message_multi (conn:riak_connection) (req:Piqirun.OBuf.t option)
    (reqid:int) (respid:int) predicate =
  lwt _ = send_msg conn req reqid in
  recv_more conn respid predicate []

let rec try_many fn n last_exception =
  match n with
    | 0 ->
        (match last_exception with
           | None -> raise
                       (RiakException("Unknown exception",-2l))
           | Some exc -> raise exc)
    | count ->
        try_lwt
          fn()
        with RiakException (msg,id) ->
          try_many fn (count-1) (Some (RiakException (msg,id)))

let riak_multi conn fn =
  try_many fn conn.conn_options.riak_conn_retries None

let riak_get_client_id conn =
  let impl() =
    lwt pbresp = send_pb_message conn None rpbGetClientIdReq rpbGetClientIdResp in
    let resp = Riak_kv_piqi.parse_rpb_get_client_id_resp pbresp in
      return resp.Riak_kv_piqi.Rpb_get_client_id_resp.client_id
  in
    riak_multi conn impl

let riak_set_client_id conn newid =
  let impl() =
    let req = { Riak_kv_piqi.Rpb_set_client_id_req.client_id = newid } in
    let genreq = Riak_kv_piqi.gen_rpb_set_client_id_req req in
    lwt _ = send_pb_message conn (Some genreq) rpbSetClientIdReq rpbSetClientIdResp in
      return ()
  in
    riak_multi conn impl

let riak_connect hostname portnum options =
  lwt server_addr =
    try_lwt
      let addr = Unix.gethostbyname hostname in
      return addr.h_addr_list.(0)
    with Not_found ->
      failwith (hostname ^ ": Host not found") in
  let riaksocket = socket PF_INET SOCK_STREAM 0 in
    set_nagle riaksocket options.riak_conn_use_nagal;
    lwt _ = connect riaksocket (ADDR_INET(server_addr, portnum)) in
    let cout = Lwt_chan.out_channel_of_descr riaksocket in
    let cin  = Lwt_chan.in_channel_of_descr riaksocket in
    let conn =  {
      host=hostname;
      port=portnum;
      sock=riaksocket;
      inc=cin;
      outc=cout;
      debug=false;
      clientid=None;
      conn_options=options;
    } in
      return conn

let riak_connect_with_defaults hostname portnum =
  riak_connect hostname portnum riak_connection_defaults

let riak_disconnect (conn:riak_connection) =
  close conn.sock


let riak_ping conn =
  let impl() =
    lwt _ = send_pb_message conn None rpbPingReq rpbPingResp in
      return true
  in
    riak_multi conn impl


let riak_get_server_info conn =
  let impl() =
    lwt pbresp = send_pb_message conn None rpbGetServerInfoReq rpbGetServerInfoResp in
    let resp = parse_rpb_get_server_info_resp pbresp in
      return (string_of_option resp.Rpb_get_server_info_resp.node,
              string_of_option resp.Rpb_get_server_info_resp.server_version)
  in
    riak_multi conn impl

(* TODO: rename *)
let riak_process_content bucket key vclock item =
  let value = item.Riak_kv_piqi.Rpb_content.value in
  { obj_value = Some value;
    obj_vclock = vclock;
    obj_bucket = bucket;
    obj_key = key;
    obj_exists = true;
  }

let print_riak_obj obj =
  print_endline ("{ value=" ^ string_of_option(obj.obj_value));
  print_endline (" vclock=" ^ string_of_option(obj.obj_vclock));
  print_endline (" bucket=" ^ obj.obj_bucket);
  print_endline (" key=" ^ string_of_option(obj.obj_key) ^ "}")

let riak_get (conn:riak_connection) bucket key options =
  let impl() =
    let getreq = process_get_options options (new_get_req bucket key) in
    let genreq = Riak_kv_piqi.gen_rpb_get_req getreq in
    lwt pbresp = send_pb_message conn (Some genreq) rpbGetReq rpbGetResp in
    let resp = Riak_kv_piqi.parse_rpb_get_resp pbresp in
    let v = resp.Riak_kv_piqi.Rpb_get_resp.content in
    let vclock = resp.Riak_kv_piqi.Rpb_get_resp.vclock in
    let results = List.map (riak_process_content bucket (Some key) vclock) v in
      return (conn.conn_options.riak_conn_resolve_conflicts results)
  in
    riak_multi conn impl


let get_vclock_for_put conn bucket key =
  let impl() =
    match_lwt riak_get conn bucket key [] with
      | None -> return None
      | Some value -> return value.obj_vclock
  in
    riak_multi conn impl

let riak_put (conn:riak_connection) bucket key value options =
  lwt vclock = match key with
                | None -> return None
                | Some keyval -> get_vclock_for_put conn bucket keyval in
  let impl() =
    let pr = new_put_req bucket key value vclock in
    let putreq = process_put_options options pr in
    let genreq = Riak_kv_piqi.gen_rpb_put_req putreq in
    lwt pbresp = send_pb_message conn (Some genreq) rpbPutReq rpbPutResp in
    let resp = Riak_kv_piqi.parse_rpb_put_resp pbresp in
    let v = resp.Riak_kv_piqi.Rpb_put_resp.content in
    let newkey = resp.Riak_kv_piqi.Rpb_put_resp.key in
    let newvclock = resp.Riak_kv_piqi.Rpb_put_resp.vclock in
      return (List.map (riak_process_content bucket newkey newvclock) v)
  in
  riak_multi conn impl

let riak_put_raw (conn:riak_connection) bucket key value options vclock =
  let impl() =
    let pr = new_put_req bucket key value None in
    let putreq = process_put_options options pr in
    let genreq = Riak_kv_piqi.gen_rpb_put_req putreq in
    lwt pbresp = send_pb_message conn (Some genreq) rpbPutReq rpbPutResp in
    let resp = Riak_kv_piqi.parse_rpb_put_resp pbresp in
    let v = resp.Riak_kv_piqi.Rpb_put_resp.content in
    let newkey = resp.Riak_kv_piqi.Rpb_put_resp.key in
    let newvclock = resp.Riak_kv_piqi.Rpb_put_resp.vclock in
      return (List.map (riak_process_content bucket newkey newvclock) v)
  in
    riak_multi conn impl

let riak_del (conn:riak_connection) bucket key options =
  let impl() =
    let delreq = process_del_options options (new_del_req bucket key) in
    let genreq = Riak_kv_piqi.gen_rpb_del_req delreq in
    lwt _ = send_pb_message conn (Some genreq) rpbDelReq rpbDelResp in
      return ()
  in
    riak_multi conn impl

let riak_list_buckets (conn:riak_connection) =
  let impl() =
    lwt pbresp = send_pb_message conn None rpbListBucketsReq rpbListBucketsResp in
    let resp = Riak_kv_piqi.parse_rpb_list_buckets_resp pbresp in
    let buckets = resp.Riak_kv_piqi.Rpb_list_buckets_resp.buckets in
      return buckets
  in
    riak_multi conn impl

let riak_list_keys (conn:riak_connection) bucket =
  let impl() =
    let lkreq = (new_list_keys_req bucket) in
    let genreq = Riak_kv_piqi.gen_rpb_list_keys_req lkreq in
    let pred = fun pbresp ->
      let resp = Riak_kv_piqi.parse_rpb_list_keys_resp pbresp in
      let keys = resp.Riak_kv_piqi.Rpb_list_keys_resp.keys in
        match resp.Riak_kv_piqi.Rpb_list_keys_resp.isdone with
          | None -> (false, Some keys)
          | Some true -> (true, Some keys)
          | Some false -> (false, Some keys)
    in
    lwt acc = send_pb_message_multi conn (Some genreq) rpbListKeysReq rpbListKeysResp pred in
      return (List.flatten acc)
  in
    riak_multi conn impl

let riak_get_bucket (conn:riak_connection) bucket =
  let impl() =
    let gbreq = { Riak_kv_piqi.Rpb_get_bucket_req.bucket = bucket} in
    let genreq = Riak_kv_piqi.gen_rpb_get_bucket_req gbreq in
    lwt pbresp = send_pb_message conn (Some genreq) rpbGetBucketReq rpbGetBucketResp in
    let resp = Riak_kv_piqi.parse_rpb_get_bucket_resp pbresp in
    let bprops = resp.Riak_kv_piqi.Rpb_get_bucket_resp.props in
      return ( bprops.Riak_kv_piqi.Rpb_bucket_props.n_val, bprops.Riak_kv_piqi.Rpb_bucket_props.allow_mult)
  in
    riak_multi conn impl

let riak_set_bucket (conn:riak_connection) bucket n mult =
  let impl() =
    let bprops = { Riak_kv_piqi.Rpb_bucket_props.n_val = n;
                   Riak_kv_piqi.Rpb_bucket_props.allow_mult = mult; }
    in
    let sbreq = { Riak_kv_piqi.Rpb_set_bucket_req.bucket = bucket;
                  Riak_kv_piqi.Rpb_set_bucket_req.props = bprops; }
    in
    let genreq = Riak_kv_piqi.gen_rpb_set_bucket_req sbreq in
    lwt _ = send_pb_message conn (Some genreq) rpbSetBucketReq rpbSetBucketResp in
      return ()
  in
    riak_multi conn impl

let riak_mapred (conn:riak_connection) req content_type =
  let mrpred = fun pbresp ->
    let resp = Riak_kv_piqi.parse_rpb_map_red_resp pbresp in
    let phase = resp.Riak_kv_piqi.Rpb_map_red_resp.phase in
    let response = resp.Riak_kv_piqi.Rpb_map_red_resp.response in
    match resp.Riak_kv_piqi.Rpb_map_red_resp.isdone with
      | None -> (false, Some (response, phase))
      | Some true -> (true, None)
      | Some false -> (false, Some (response, phase))
  in
  let ctval = get_mr_content_type content_type in
  let mrreq = { Riak_kv_piqi.Rpb_map_red_req.request = req;
                Riak_kv_piqi.Rpb_map_red_req.content_type = ctval; }
  in
  let genreq = Riak_kv_piqi.gen_rpb_map_red_req mrreq in
  lwt acc = send_pb_message_multi conn (Some genreq) rpbMapRedReq rpbMapRedResp mrpred in
    return acc


let riak_index conn req =
  let impl() =
    let genreq = Riak_kv_piqi.gen_rpb_index_req req in
    lwt pbresp = send_pb_message conn (Some genreq) rpbIndexReq rpbIndexResp in
    let resp = Riak_kv_piqi.parse_rpb_index_resp pbresp in
      return resp.Riak_kv_piqi.Rpb_index_resp.keys
  in
    riak_multi conn impl

let riak_index_eq conn bucket index key =
  let req0 = new_index_req bucket index `eq in
  let req =
    { req0 with Riak_kv_piqi.Rpb_index_req.key = key
    } in
  riak_index conn req

let riak_index_range conn bucket index min max =
  let req0 = new_index_req bucket index `range in
  let req =
    { req0 with
      Riak_kv_piqi.Rpb_index_req.range_min = min;
      Riak_kv_piqi.Rpb_index_req.range_max = max;
    } in
  riak_index conn req

let riak_search_query (conn:riak_connection) query index options =
  let parse_docs docs =
    List.map (fun f ->
                let pairs = f.Rpb_search_doc.fields in
                  List.map (fun pair ->
                    let key = pair.Rpb_pair.key in
                    let value = pair.Rpb_pair.value in
                    (key,value)) pairs) docs
  in
  let impl() =
    let searchreq = process_search_options options (new_search_query_req query index) in
    let genreq = gen_rpb_search_query_req searchreq in
    lwt pbresp = send_pb_message conn (Some genreq) rpbSearchQueryReq rbpSearchQueryResp in
    let resp = parse_rpb_search_query_resp pbresp in
    let docs = resp.Rpb_search_query_resp.docs in
    let parsed_docs = parse_docs docs in
    let max_score = resp.Rpb_search_query_resp.max_score in
    let num_found = resp.Rpb_search_query_resp.num_found in
      return (parsed_docs, max_score, num_found)
  in
    riak_multi conn impl

let riak_exec hostname port fn =
  (* TODO: handle exceptions *)
  lwt conn = riak_connect hostname port riak_connection_defaults in
  lwt result = fn conn in
  lwt _ = riak_disconnect conn in
  return result
