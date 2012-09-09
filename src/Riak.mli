(*
-------------------------------------------------------------------

 riak.mli: Riak OCaml Client

 Copyright (c) 2012 Dave Parfitt
 All Rights Reserved.

 This file is provided to you under the Apache License,
 Version 2.0 (the "License"); you may not use this file
 except in compliance with the License.  You may obtain
 a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
-------------------------------------------------------------------
*)

type riak_tunable_cap =
  | Riak_value_one
  | Riak_value_quorum
  | Riak_value_all
  | Riak_value_default
  | Riak_value of Riak_kv_piqi.uint32

val get_riak_tunable_cap : riak_tunable_cap -> Riak_kv_piqi.uint32

type riak_get_option =
    Get_r of riak_tunable_cap
  | Get_pr of riak_tunable_cap
  | Get_basic_quorum of bool
  | Get_notfound_ok of bool
  | Get_if_modified of string
  | Get_head of bool
  | Get_deleted_vclock of bool

type riak_put_option =
    Put_w of riak_tunable_cap
  | Put_dw of riak_tunable_cap
  | Put_return_body of bool
  | Put_pw of riak_tunable_cap
  | Put_if_not_modified of bool
  | Put_if_none_match of bool
  | Put_return_head of bool

type riak_del_option =
    Del_rw of riak_tunable_cap
  | Del_vclock of string
  | Del_r of riak_tunable_cap
  | Del_w of riak_tunable_cap
  | Del_pr of riak_tunable_cap
  | Del_pw of riak_tunable_cap
  | Del_dw of riak_tunable_cap

type riak_search_option =
    Search_rows of Riak_kv_piqi.uint32
  | Search_start of Riak_kv_piqi.uint32
  | Search_sort of string
  | Search_filter of string
  | Search_df of string
  | Search_op of string
  | Search_fl of string list
  | Search_presort of string

exception RiakException of string * Riak_piqi.uint32

type riak_connection = {
  host : string;
  port : int;
  sock : Unix.file_descr;
  inc : in_channel;
  outc : out_channel;
  debug : bool;
  clientid : string option;
}

type riak_object = {
  obj_value : string option;
  obj_vclock : string option;
  obj_bucket : string;
  obj_key : string option;
  obj_exists : bool;
}


val riak_connect : string -> int -> riak_connection

val riak_disconnect : riak_connection -> unit

val riak_ping : riak_connection -> bool

val riak_get_client_id : riak_connection -> Riak_kv_piqi.Riak_kv_piqi.binary

val riak_set_client_id : riak_connection -> Riak_kv_piqi.Riak_kv_piqi.binary -> unit

val riak_get_server_info :
  riak_connection -> Riak_piqi.Riak_piqi.binary * Riak_piqi.Riak_piqi.binary

val riak_process_content :
  string -> string option -> string option -> Riak_kv_piqi.Rpb_content.t -> riak_object

val print_riak_obj : riak_object -> unit

val riak_get :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary -> riak_get_option list -> riak_object list

val riak_put :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary option ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  riak_put_option list -> string option -> riak_object list

val riak_del :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary -> riak_del_option list -> unit

val riak_list_buckets : riak_connection -> Riak_kv_piqi.Riak_kv_piqi.binary list

val riak_list_keys :
  riak_connection -> Riak_kv_piqi.Riak_kv_piqi.binary -> Riak_kv_piqi.Riak_kv_piqi.binary list

val riak_get_bucket :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary -> Riak_kv_piqi.Riak_kv_piqi.uint32 option * bool option

val riak_set_bucket :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.uint32 option -> bool option -> unit

val riak_mapred :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  (Riak_kv_piqi.Riak_kv_piqi.binary option * Riak_kv_piqi.Riak_kv_piqi.uint32 option) list

val riak_index :
  riak_connection -> Riak_kv_piqi.Rpb_index_req.t -> Riak_kv_piqi.Riak_kv_piqi.binary list

val riak_index_eq :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary option -> Riak_kv_piqi.Riak_kv_piqi.binary list

val riak_index_range :
  riak_connection ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary ->
  Riak_kv_piqi.Riak_kv_piqi.binary option ->
  Riak_kv_piqi.Riak_kv_piqi.binary option -> Riak_kv_piqi.Riak_kv_piqi.binary list

val riak_search_query :
  riak_connection ->
  Riak_search_piqi.Riak_search_piqi.binary ->
  Riak_search_piqi.Riak_search_piqi.binary ->
  riak_search_option list ->
  'a list * Riak_search_piqi.Riak_search_piqi.float32 option *
  Riak_search_piqi.Riak_search_piqi.uint32 option

(* val riak_op : 'a -> ('a -> (riak_connection * 'a)) -> (riak_connection -> 'b)
 * *)
(*val riak_op : 'a -> ('a -> 'b * 'c) -> ('b -> 'd) -> 'c * 'd*)
