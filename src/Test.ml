open Riak
open Sys
open Unix

let client() =
	let conn = riak_connect "127.0.0.1" 8081 in
	let _ = match riak_ping conn with
		| true  -> print_endline("Pong")
		| false -> print_endline("Error")
	in
	riak_disconnect conn;
	exit 0;;    

handle_unix_error client ();;

