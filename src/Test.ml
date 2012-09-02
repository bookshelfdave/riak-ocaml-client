open Riak
open Sys
open Unix
open OUnit

(* test fn for development *)
(*let client () =
  let conn = riak_connect "127.0.0.1" 8081 in
  let _ = match riak_ping conn with
    | true -> print_endline("Pong")
    | false -> print_endline("Bad response from server") in
  let (node,version) = riak_get_server_info conn in
  print_endline ("Node: " ^ node ^ ", Version: " ^ version);

  riak_disconnect conn;
  exit 0;;
  (* handle_unix_error client ();; *)
*)

let setup _ = 
  ()

let teardown _ = 
  ()

let test_case_ping _ =
  let conn = riak_connect "127.0.0.1" 8081 in
  let _ = match riak_ping conn with
    | true -> () 
    | false -> assert_failure("Can't connect to Riak") 
  in
  riak_disconnect conn

let test_case_ping_fail _ =
  ()

let test_case_invalid_network _ =
  ()


let test_case_server_info _ =
  (* ie, don't connect to anything less than 1.2? *)
  ()


let suite = "Riak" >:::
[ 
  "test_ping" >:: (bracket setup test_case_ping teardown); 
  "test_ping_fail" >:: (bracket setup test_case_ping_fail teardown); 
  "test_case_invalid_network" >:: (bracket setup test_case_invalid_network teardown);
  "test_server_info" >:: (bracket setup test_case_server_info teardown);
]	

let _ = run_test_tt_main suite
