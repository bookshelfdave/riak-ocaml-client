riak-ocaml-client
=====

**© 2012 Dave Parfitt**

riak-ocaml-client is a Riak 1.2 Protobuffs-only client for OCaml 3.12.1.

*This is a work in progress. I hope to have it finished up by early September 2012. Pull requests accepted!*

###Dependencies

* [ocamlfind](http://projects.camlcity.org/projects/findlib.html)
* [Piqi](http://piqi.org/)
* [http://code.google.com/p/protobuf/](Protobuffs)
   * In OSX, `brew install protobuf` if you are using Homebrew
* [http://ounit.forge.ocamlcore.org/](OUnit)

###TODO
    * cleanup get, put, M/R, search, index
	* testing
	* expand riak_connection to support a pool of IP's

### Tutorial

####Hello world

The following program makes a connection to Riak and sends a ping message. 

```
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

```

		
Compile this example with the following:

```
   todo
```
