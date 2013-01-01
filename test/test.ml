(*
-------------------------------------------------------------------

 test.ml: Riak OCaml Client tests

 Copyright (c) 2012 - 2013 Dave Parfitt
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

open Riak
open Sys
open Lwt
open Lwt_unix
open OUnit

let  (|>) x f = f x

let testbucket() =
  let i = int_of_float(Unix.time()) in
    Random.init i;
    let bucketnum = Random.int 999999999 in
    let tb = ("testbucket_" ^ string_of_int(bucketnum)) in
      tb

let test_ip() =
  try
    Sys.getenv("RIAK_OCAML_TEST_IP")
  with Not_found ->
    "127.0.0.1"

let test_port() =
  try
    int_of_string(Sys.getenv("RIAK_OCAML_TEST_PORT"))
  with Not_found ->
    8087

let open_riak_connection clientid =
  try
    let ip = test_ip() in
    let port = test_port() in
    lwt conn = riak_connect_with_defaults ip port in
    lwt _ = riak_set_client_id conn clientid in
      return conn
  with Not_found ->
    riak_connect_with_defaults "127.0.0.1" 8087

let setup _ =
  open_riak_connection "oUnit"


let teardown conn =
  riak_disconnect conn

let test_case_ping conn =
  match_lwt riak_ping conn with
    | true -> return ()
    | false -> assert_failure("Can't connect to Riak")

let test_case_ping_fail _ =
  return ()

let test_case_invalid_network _ =
  return ()

let test_case_server_info conn =
  lwt (node, version) = riak_get_server_info conn in
    assert_bool "Non empty node id" (node <> "");
    assert_bool "Non empty version #" (version <> "");
    return ()

let test_case_client_id conn =
  let test_client_id = testbucket() in
  lwt _ = riak_set_client_id conn test_client_id in
  lwt client_id = riak_get_client_id conn in
    assert_equal test_client_id client_id;
    return ()

let show_option v =
  match v with
    | None -> print_endline "NONE"
    | Some x -> print_endline x

let test_case_put_raw conn =
  let bucket = testbucket() in
  let rec putmany n =
    match n with
      | 0 -> return ()
      | n ->
          let newkey = "foo" ^ string_of_int(n) in
          let newval = "bar" ^ string_of_int(n) in
          lwt objs =
            riak_put_raw conn bucket (Some newkey)
              newval [Put_return_body true] None in
          let testval os =
            match os with
              | None -> assert_failure "No objects returned from put"
              | Some o ->
                  (match o.obj_vclock with
                    | Some v -> assert_bool "Invalid vclock" (v <> "")
                    | None -> assert_failure
                          "Put with return_body didn't return any data")
          in
            testval objs;
            putmany (n-1)
  in
  let rec getmany n =
    match n with
      | 0 -> return ()
      | n ->
          let getkey = "foo" ^ string_of_int(n) in
          let getval = "bar" ^ string_of_int(n) in
          lwt obj = riak_get conn bucket getkey [] in
            match obj with
              | Some o ->
                  (match o.obj_value with
                     | Some v ->
                         assert_equal v getval;
                         getmany (n-1)
                     | None -> assert_failure "Invalid value at key")
              | None -> assert_failure "Object not found"
  in
    lwt _ = putmany 1000 in
    lwt _ = sleep(5.) in
    getmany 1000

let test_case_put conn =
  let bucket = testbucket() in
  let rec putmany n =
    match n with
      | 0 -> return ()
      | n ->
          let newkey = "foo" ^ string_of_int(n) in
          let newval = "bar" ^ string_of_int(n) in
          lwt objs =
            riak_put conn bucket (Some newkey) newval [Put_return_body true] in
          let testval os =
            match os with
              | None -> assert_failure "No objects returned from put"
              | Some o ->
                  (match o.obj_vclock with
                    | Some v -> assert_bool "Invalid vclock" (v <> "")
                    | None -> assert_failure
                          "Put with return_body didn't return any data")
          in
            testval objs;
            putmany (n-1)
  in
  let rec getmany n =
    match n with
      | 0 -> return ()
      | n ->
          let getkey = "foo" ^ string_of_int(n) in
          let getval = "bar" ^ string_of_int(n) in
          lwt obj = riak_get conn bucket getkey [] in
            match obj with
              | Some o ->
                  (match o.obj_value with
                     | Some v ->
                         assert_equal v getval;
                         getmany (n-1)
                     | None -> assert_failure "Invalid value at key")
              | None -> assert_failure "Object not found"
  in
    lwt _ = putmany 1000 in
    lwt _ = sleep(5.) in
    getmany 1000


let test_case_get conn =
  let bucket = testbucket() in
  let gt = "get_test" in
  let tv = "test_value" in
    lwt _ = riak_put_raw conn bucket (Some gt) tv [] None in
    lwt result = riak_get conn bucket gt [] in
      (match result with
        | None -> assert_failure "Get value not found"
        | Some value ->
            match value.obj_value with
               | Some v ->
                   assert_equal v tv
               | None -> assert_failure "Get value empty");
      return ()

let test_case_get_with_siblings _ =
  lwt conn0 = open_riak_connection "Foo" in
  lwt conn1 = open_riak_connection "Bar" in
  let bucket = testbucket() in
  let gst = "get_sibling_test" in
    lwt _ = riak_set_bucket conn0 bucket None (Some true) in
    lwt _ = sleep(1.) in
    lwt _ = riak_put_raw conn0 bucket (Some gst) "test_sibling_value_1" [] None in
    lwt _ = riak_put_raw conn1 bucket (Some gst) "test_sibling_value_2" [] None in
    (* make sure the default resolver throws exception when 
     * siblings are found *)
    try_lwt
      lwt _ = riak_get conn1 bucket gst [] in
      assert_failure "Default sibling resolution should throw an exception"
    with RiakSiblingException s ->
      (* this is good *)
      return ()

let test_case_del conn =
  let bucket = testbucket() in
  let gt = "del_test" in
  let tv = "test_value" in
    lwt _ = riak_put_raw conn bucket (Some gt) tv [] None in
    lwt _ = sleep(3.) in
    lwt _ = riak_del conn bucket "del_test" [] in
    match_lwt riak_get conn bucket gt [] with
      | None -> return ()
      | Some _ -> assert_failure "Deleted value found. Sad panda"

let test_case_list_buckets conn =
  let bucket = testbucket() in
  let gt = "bucket_test" in
  let tv = "test_value" in
    lwt _ = riak_put_raw conn bucket (Some gt) tv [] None in
    lwt _ = sleep(1.) in
    lwt buckets = riak_list_buckets conn in
      assert_bool "Buckets length > 0" (List.length buckets > 0);
      assert_bool "Find a specific bucket"
        (List.exists (fun x -> x = bucket) buckets);
      return ()

let test_case_list_keys conn =
  let bucket = testbucket() in
  let rec put_many num =
    match num with
      | 0 -> return ()
      | n -> (let tk = "bucket_test" ^ string_of_int(n) in
              let tv = "test_value" in
                lwt _ = riak_put_raw conn bucket (Some tk) tv [] None in
                put_many (n-1))
  in
    lwt _ = put_many 66 in
    lwt keys = riak_list_keys conn bucket in
      assert_equal 66 (List.length keys);
      assert_bool "Find a key"
        (List.exists (fun x -> x = "bucket_test54") keys);
      return ()

let test_case_get_bucket conn =
  let bucket = testbucket() in
  let gt = "bucket_test" in
  let tv = "test_value" in
    lwt _ = riak_put_raw conn bucket (Some gt) tv [] None in
    lwt _ = sleep(1.) in
    lwt (n, multi) = riak_get_bucket conn bucket in
      (match n with
        | Some nval -> assert_bool "Valid bucket n value" (nval > 0l)
        | None -> assert_failure "Unexpected default N value");
      (match multi with
        | Some multival -> assert_equal false multival
        | None -> assert_failure "Unexpected default multi value");
      return ()

let test_case_set_bucket conn =
  let bucket = testbucket() in
  let gt = "bucket_test" in
  let tv = "test_value" in
    lwt _ = riak_put_raw conn bucket (Some gt) tv [] None in
    lwt _ = sleep(1.) in
    lwt _ = riak_set_bucket conn bucket (Some 2l) (Some true) in
    lwt _ = sleep(1.) in
    lwt (n, multi) = riak_get_bucket conn bucket in
      (match n with
         | Some nval -> assert_equal 2l nval
         | None -> assert_failure "Unexpected N value");
      (match multi with
         | Some multival -> assert_equal true multival
         | None -> ());
      lwt _ = riak_set_bucket conn bucket (Some 1l) (None) in
      lwt _ = sleep(1.) in
      lwt (n, multi) = riak_get_bucket conn bucket in
        (match n with
           | Some nval -> assert_equal 1l nval
           | None -> assert_failure "Unexpected N value");
        (match multi with
           | Some multival -> assert_equal true multival
           (* passing None doesn't overwrite the previous
           * value *)
           | None -> ());
        return ()

let show_int_option v =
  match v with
    | None -> print_endline "NONE"
    | Some x -> print_endline (Int32.to_string x)


let test_case_mapreduce conn =
  let bucket = testbucket() in
    lwt _ = riak_put_raw conn bucket (Some "foo")
      "pizza data goes here" [] None in
    lwt _ = riak_put_raw conn bucket (Some "bar")
      "pizza pizza pizza pizza" [] None in
    lwt _ = riak_put_raw conn bucket (Some "baz")
      "nothing to see here" [] None in
    lwt _ = riak_put_raw conn bucket (Some "bam")
      "pizza pizza pizza" [] None in
    lwt _ = sleep(1.) in
    let query = "{\"inputs\":\"" ^ bucket ^ "\", \"query\":[{\"map\":{\"language\":\"javascript\", " ^
                "\"source\":\"function(riakObject) { var m =  riakObject.values[0].data.match(/pizza/g);" ^
                "return  [[riakObject.values[0].data, (m ? m.length : 0 )]]; }\"}}]}" in
    lwt results = riak_mapred conn query Riak_MR_Json in
        assert_equal 4 (List.length results);
        assert_bool "Check for match 3"
          (List.exists (fun (v,p) ->
                          v = (Some "[[\"pizza pizza pizza\",3]]")) results);
        assert_bool "Check for match 0"
          (List.exists (fun (v,p) ->
                          v = (Some "[[\"nothing to see here\",0]]")) results);
        assert_bool "Check for match 4"
          (List.exists (fun (v,p) ->
                          v = (Some "[[\"pizza pizza pizza pizza\",4]]")) results);
        assert_bool "Check for match 1"
          (List.exists (fun (v,p) ->
                          v = (Some "[[\"pizza data goes here\",1]]")) results);
        return ()

let test_case_with_connection _ =
  let ip = test_ip() in
  let port = test_port() in
  let with_connection = riak_exec ip port in
  with_connection (fun conn -> riak_ping conn)

(* TODO: Index, Search *)
(*
let test_case_search conn =
  let _ = riak_search_query conn "fox" "phrases_custom" [] in
    ()
 *)

(* TODO: clean up test buckets when complete? *)
(* these don't all need to be bracketed *)
let bracket test_case () =
  run (
    lwt conn = setup () in
    lwt _ = test_case conn in
    teardown conn
  )

let suite = "Riak" >:::
[
  "test_case_ping" >:: (bracket test_case_ping);
  "test_case_ping_fail" >:: (bracket test_case_ping_fail);
  "test_case_invalid_network" >:: (bracket test_case_invalid_network);
  "test_case_client_id" >:: (bracket test_case_client_id);
  "test_case_server_info" >:: (bracket test_case_server_info);
  "test_case_put" >:: (bracket test_case_put);
  "test_case_put_raw" >:: (bracket test_case_put_raw);
  "test_case_get" >:: (bracket test_case_get);
  "test_case_get_with_siblings" >:: (bracket test_case_get_with_siblings);
  "test_case_del" >:: (bracket test_case_del);
  "test_case_list_buckets" >:: (bracket test_case_list_buckets);
  "test_case_list_keys" >:: (bracket test_case_list_keys);
  "test_case_get_bucket" >:: (bracket test_case_get_bucket);
  "test_case_set_bucket" >:: (bracket test_case_set_bucket);
  "test_case_mapreduce" >:: (bracket test_case_mapreduce);
  "test_case_with_connection" >:: (bracket test_case_with_connection);
]

let _ = run_test_tt_main suite
