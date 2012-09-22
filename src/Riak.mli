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
  sock : Unix.file_descr;
  inc : in_channel;
  outc : out_channel;
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

val get_mr_content_type : riak_mr_content_type -> string

val riak_ocaml_client_version : string

val riak_connection_defaults : riak_connection_options

val riak_connect_with_defaults : string -> int -> riak_connection

val riak_connect : string -> int -> riak_connection_options -> riak_connection

val riak_disconnect : riak_connection -> unit

val riak_ping : riak_connection -> bool

val riak_get_client_id : riak_connection -> riak_client_id

val riak_set_client_id : riak_connection -> riak_client_id -> unit

val riak_get_server_info :
  riak_connection -> riak_node_id * riak_version

val print_riak_obj : riak_object -> unit

val riak_get :
  riak_connection ->
  riak_bucket ->
  riak_key -> riak_get_option list -> riak_object option

val riak_put :
  riak_connection ->
  riak_bucket ->
  riak_key option ->
  string ->
  riak_put_option list -> string option -> riak_object list

val riak_del :
  riak_connection ->
  riak_bucket ->
  riak_key -> riak_del_option list -> unit

val riak_list_buckets : riak_connection -> riak_bucket list

val riak_list_keys :
  riak_connection -> riak_bucket -> riak_key list

val riak_get_bucket :
  riak_connection ->
  riak_bucket -> int32 option * bool option


val riak_set_bucket :
  riak_connection -> riak_bucket -> int32 option -> bool option -> unit

val riak_mapred :
  riak_connection ->
  riak_mr_query ->
  riak_mr_content_type ->
  (string option * int32 option) list

val riak_index_eq :
  riak_connection ->
  riak_bucket ->
  riak_2i_name ->
  riak_key option -> string list

val riak_index_range :
  riak_connection ->
  riak_bucket ->
  riak_2i_name ->
  riak_2i_range_min option ->
  riak_2i_range_max option -> string list

val riak_search_query :
  riak_connection ->
  riak_search_query ->
  riak_search_index ->
  riak_search_option list ->
  'a list * float option *
  int32 option

val riak_exec : string -> int -> (riak_connection -> 'a) -> 'a

