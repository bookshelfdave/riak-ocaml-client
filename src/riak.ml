open Sys
open Unix
open Riak_piqi
module KV = Riak_kv_piqi

(* ocamlfind ocamlc -o foo -package Unix -package piqi.runtime -linkpkg Riak_piqi.cmo Riak_kv_piqi.cmo riak.ml *)

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
(*let rpbMapRedResp{1,} = 24 *)
let rpbIndexReq           = 25
let rpbIndexResp          = 26
let rpbSearchQueryReq     = 27
let rbpSearchQueryResp    = 28

(* F# pipelining operator *)
let  (|>) x f = f x

(* Haskell Either type *)
(* Left represents error, Right represents a value *)
type ('a,'b) either = Left of 'a | Right of 'b

(* type ('req, 'res) pbmsg = PBMsg of 'req * 'res *)

type riak_get_option =
    Get_r of KV.uint32
  | Get_pr of KV.uint32
  | Get_basic_quorum of bool
  | Get_notfound_ok of bool
  | Get_if_modified of string
  | Get_head of bool
  | Get_deleted_vclock of bool

type riak_put_option =
    Put_w of KV.uint32
  | Put_dw of KV.uint32
  | Put_return_body of bool
  | Put_pw of KV.uint32
  | Put_if_not_modified of bool
  | Put_if_none_match of bool
  | Put_return_head of bool

type riak_del_option =
    Del_rw of KV.uint32
  | Del_vclock of string
  | Del_r of KV.uint32
  | Del_w of KV.uint32
  | Del_pr of KV.uint32
  | Del_pw of KV.uint32
  | Del_dw of KV.uint32

let new_content value =
  { KV.Rpb_content.value = value;
    KV.Rpb_content.content_type = Some "text/plain";
    KV.Rpb_content.charset = None;
    KV.Rpb_content.content_encoding = None;
    KV.Rpb_content.vtag = None;
    KV.Rpb_content.links = [];
    KV.Rpb_content.last_mod = None;
    KV.Rpb_content.last_mod_usecs = None;
    KV.Rpb_content.usermeta = [];
    KV.Rpb_content.indexes = [];
    KV.Rpb_content.deleted = None;}


let new_get_req bucket key =
  {
    KV.Rpb_get_req.bucket = bucket;
    KV.Rpb_get_req.key = key;
    KV.Rpb_get_req.r = None;
    KV.Rpb_get_req.pr = None;
    KV.Rpb_get_req.basic_quorum = None;
    KV.Rpb_get_req.notfound_ok = None;
    KV.Rpb_get_req.if_modified = None;
    KV.Rpb_get_req.head = None;
    KV.Rpb_get_req.deletedvclock = None;
  }

(* TODO clean up this record! *)
let new_put_req bucket key value =
  {
    KV.Rpb_put_req.bucket = bucket;
    KV.Rpb_put_req.key = key;
    KV.Rpb_put_req.vclock = None;
    KV.Rpb_put_req.content = (new_content value);
    KV.Rpb_put_req.w = Some 1l;
    KV.Rpb_put_req.dw = None;
    KV.Rpb_put_req.pw = None;
    KV.Rpb_put_req.return_body = Some true;
    KV.Rpb_put_req.if_not_modified = Some false;
    KV.Rpb_put_req.if_none_match = Some false;
    KV.Rpb_put_req.return_head = Some false;
  }

let new_del_req bucket key =
  {
    KV.Rpb_del_req.bucket = bucket;
    KV.Rpb_del_req.key = key;
    KV.Rpb_del_req.rw = None;
    KV.Rpb_del_req.vclock = None;
    KV.Rpb_del_req.r = None;
    KV.Rpb_del_req.w = None;
    KV.Rpb_del_req.pr = None;
    KV.Rpb_del_req.pw = None;
    KV.Rpb_del_req.dw = None;
  }

let new_list_keys_req bucket =
  {
    KV.Rpb_list_keys_req.bucket = bucket
  }

let rec process_get_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Get_r v ->
          process_get_options os { req with KV.Rpb_get_req.r = Some v }
        | Get_pr v ->
          process_get_options os { req with KV.Rpb_get_req.pr = Some v }
        | Get_basic_quorum v ->
          process_get_options os { req with KV.Rpb_get_req.basic_quorum = Some v }
        | Get_notfound_ok v ->
          process_get_options os { req with KV.Rpb_get_req.notfound_ok = Some v }
        | Get_if_modified v ->
          process_get_options os { req with KV.Rpb_get_req.if_modified = Some v }
        | Get_head v ->
          process_get_options os { req with KV.Rpb_get_req.head = Some v }
        | Get_deleted_vclock v ->
          process_get_options os { req with KV.Rpb_get_req.deletedvclock = Some v }


let rec process_put_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Put_w v ->
          process_put_options os { req with KV.Rpb_put_req.w = Some v }
        | Put_dw v ->
          process_put_options os { req with KV.Rpb_put_req.dw = Some v }
        | Put_return_body v ->
          process_put_options os { req with KV.Rpb_put_req.return_body = Some v }
        | Put_pw v ->
          process_put_options os { req with KV.Rpb_put_req.pw = Some v }
        | Put_if_not_modified v ->
          process_put_options os { req with KV.Rpb_put_req.if_not_modified = Some v }
        | Put_if_none_match v ->
          process_put_options os { req with KV.Rpb_put_req.if_none_match = Some v }
        | Put_return_head v ->
          process_put_options os { req with KV.Rpb_put_req.return_head = Some v }


let rec process_del_options opts req =
  match opts with
      [] -> req
    | (o::os) ->
      match o with
        | Del_rw v ->
          process_del_options os { req with KV.Rpb_del_req.rw = Some v }
        | Del_vclock v ->
          process_del_options os { req with KV.Rpb_del_req.vclock = Some v }
        | Del_r v ->
          process_del_options os { req with KV.Rpb_del_req.r = Some v }
        | Del_w v ->
          process_del_options os { req with KV.Rpb_del_req.w = Some v }
        | Del_pr v ->
          process_del_options os { req with KV.Rpb_del_req.pr = Some v }
        | Del_pw v ->
          process_del_options os { req with KV.Rpb_del_req.pw = Some v }
        | Del_dw v ->
          process_del_options os { req with KV.Rpb_del_req.dw = Some v }

type riak_connection = { host:string;
                         port:int;
                         sock:file_descr;
                         inc:in_channel;
                         outc:out_channel;
                         debug:bool;
                       }

exception RiakException of string * Riak_piqi.uint32

type riak_object = {
  obj_value:string option;
  obj_vclock:string option;
  obj_bucket:string;
  obj_key:string option;
  obj_exists:bool;
}

let new_riak_object bucket =
  {
    obj_value = None;
    obj_vclock = None;
    obj_bucket = bucket;
    obj_key = None;
    obj_exists = false;
  }

let riak_connect hostname portnum =
  let server_addr =
    try (gethostbyname hostname).h_addr_list.(0)
    with Not_found ->
      prerr_endline (hostname ^ ": Host not found");
      exit 2 in
  let riaksocket = socket PF_INET SOCK_STREAM 0 in
    connect riaksocket (ADDR_INET(server_addr, portnum));
    let cout = out_channel_of_descr riaksocket in
    let cin  = in_channel_of_descr riaksocket in
      { host=hostname; port=portnum; sock=riaksocket; inc=cin; outc=cout; debug=false;}


let riak_disconnect (conn:riak_connection) =
  close conn.sock

let debug conn msg =
  match conn.debug with
    | true -> print_endline(msg)
    | false -> ()

let send_msg (conn:riak_connection) (req:Piqirun.OBuf.t option) (reqid:int) =
  let reqlen = match req with
    | Some req -> (String.length (Piqirun.OBuf.to_string(req))) + 1
    | None -> 1
  in
  output_binary_int conn.outc reqlen;
  output_byte conn.outc reqid;
  let _ = match req with
    | Some req -> Piqirun.to_channel conn.outc req
    | None -> ()
  in
  flush conn.outc

(* returns Piqirun.t *)
(* TODO: THIS NEEDS CLEANUP! *)
let recv_msg (conn:riak_connection) (respid:int)=
  let resplength = input_binary_int conn.inc in
  let mcode = input_byte conn.inc in
  debug conn ("Length = " ^ (string_of_int resplength));
  debug conn ("MC = " ^ (string_of_int mcode));
  let buf = String.create (resplength-1) in
  really_input conn.inc buf 0 (resplength-1);
  debug conn buf;
  let resp = Piqirun.init_from_string(buf) in
  match mcode with
    | 0 ->
      (let err = parse_rpb_error_resp resp in
       raise (RiakException (err.Rpb_error_resp.errmsg,
                             err.Rpb_error_resp.errcode)))
    | x when x = respid -> resp
    | _ ->
      raise (RiakException ("Unknown response code",-1l))

let send_pb_message (conn:riak_connection) (req:Piqirun.OBuf.t option) (reqid:int) (respid:int) =
  send_msg conn req reqid;
  recv_msg conn respid

let rec recv_more conn respid predicate acc =
  let pbresp = recv_msg conn respid in
  match (predicate pbresp) with
    | (false, None) -> recv_more conn respid predicate acc
    | (false, Some keys) -> recv_more conn respid predicate (keys::acc)
    | (true, None) -> acc
    | (true, Some keys) -> keys::acc

let send_pb_message_multi (conn:riak_connection) (req:Piqirun.OBuf.t option)
    (reqid:int) (respid:int) predicate =
  send_msg conn req reqid;
  recv_more conn respid predicate []

let riak_ping conn =
  let _ = send_pb_message conn None rpbPingReq rpbPingResp in
  true

let riak_get_client_id conn =
  let _ = send_pb_message conn None rpbGetClientIdReq rpbGetClientIdResp in
  true

let string_of_option v =
  match v with
    | None -> ""
    | Some value -> value

let riak_get_server_info conn =
  let pbresp = send_pb_message conn None rpbGetServerInfoReq rpbGetServerInfoResp in
  let resp = parse_rpb_get_server_info_resp pbresp in
  (string_of_option resp.Rpb_get_server_info_resp.node,
        string_of_option resp.Rpb_get_server_info_resp.server_version)

let riak_process_content bucket key vclock item =
  let value = item.KV.Rpb_content.value in
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
  let getreq = process_get_options options (new_get_req bucket key) in
  let genreq = KV.gen_rpb_get_req getreq in
  let pbresp = send_pb_message conn (Some genreq) rpbGetReq rpbGetResp in
  let resp = KV.parse_rpb_get_resp pbresp in
  let v = resp.KV.Rpb_get_resp.content in
  let vclock = resp.KV.Rpb_get_resp.vclock in
  List.map (riak_process_content bucket (Some key) vclock) v

let riak_put (conn:riak_connection) bucket (key:string option) (value:string) options (vclock:string option)=
  let putreq = process_put_options options (new_put_req bucket key value) in
  let genreq = KV.gen_rpb_put_req putreq in
  let pbresp = send_pb_message conn (Some genreq) rpbPutReq rpbPutResp in
  let resp = KV.parse_rpb_put_resp pbresp in
  let v = resp.KV.Rpb_put_resp.content in
  List.map (riak_process_content bucket key vclock) v


let riak_del (conn:riak_connection) bucket key options =
  let delreq = process_del_options options (new_del_req bucket key) in
  let genreq = KV.gen_rpb_del_req delreq in
  let _ = send_pb_message conn (Some genreq) rpbDelReq rpbDelResp in
  true

let riak_list_buckets (conn:riak_connection) =
  let pbresp = send_pb_message conn None rpbListBucketsReq rpbListBucketsResp in
  let resp = KV.parse_rpb_list_buckets_resp pbresp in
  let buckets = resp.KV.Rpb_list_buckets_resp.buckets in
  buckets

let riak_list_keys (conn:riak_connection) bucket =
  let lkreq = (new_list_keys_req bucket) in
  let genreq = KV.gen_rpb_list_keys_req lkreq in
  let pred = function pbresp ->
    let resp = KV.parse_rpb_list_keys_resp pbresp in
    let keys = resp.KV.Rpb_list_keys_resp.keys in
    match resp.KV.Rpb_list_keys_resp.isdone with
      | None -> (false, Some keys)
      | Some true -> (true, Some keys)
      | Some false -> (false, Some keys)
  in
  let acc = send_pb_message_multi conn (Some genreq) rpbListKeysReq rpbListKeysResp pred in
  List.flatten acc

let riak_get_bucket (conn:riak_connection) bucket =
  let gbreq = { KV.Rpb_get_bucket_req.bucket = bucket} in
  let genreq = KV.gen_rpb_get_bucket_req gbreq in
  let pbresp = send_pb_message conn (Some genreq) rpbGetBucketReq rpbGetBucketResp in
  let _resp = KV.parse_rpb_get_bucket_resp pbresp in
  print_endline "Got bucket properties"
  (* UNFINISHED *)


(* test fn for development *)
let client () =
  let conn = riak_connect "127.0.0.1" 8081 in
  let _ = match riak_ping conn with
    | true -> print_endline("Pong")
    | false -> print_endline("Bad response from server") in
  (* let _ = riak_get_bucket conn "test" in *)
  let keys = riak_list_keys conn "test" in
  List.iter (function k -> print_endline k) keys;
  riak_disconnect conn;
  exit 0;;

handle_unix_error client ();;
