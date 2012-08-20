riak-ocaml-client
=====

**© 2012 Dave Parfitt**

riak-ocaml-client is a Riak 1.2 Protobuffs-only client for OCaml 3.12.1.

*This is a work in progress. I hope to have it finished up by the end of August 2012.*

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


<pre style="background:#fff;color:#000"><span style="color:#ff7800">open</span> <span style="color:#3b5bb5">Riak</span>
<span style="color:#ff7800">open</span> <span style="color:#3b5bb5">Sys</span>
<span style="color:#ff7800">open</span> <span style="color:#3b5bb5">Unix</span>

<span style="color:#ff7800">let</span> client<span style="color:#3b5bb5">()</span> <span style="color:#ff7800">=</span>
    <span style="color:#ff7800">let</span> conn <span style="color:#ff7800">=</span> riak_connect <span style="color:#409b1c">"127.0.0.1"</span> <span style="color:#3b5bb5">8081</span> <span style="color:#ff7800">in</span>
    <span style="color:#ff7800">let</span> _ <span style="color:#ff7800">=</span> <span style="color:#ff7800">match</span> riak_ping conn <span style="color:#ff7800">with</span>
        <span style="color:#ff7800">|</span> <span style="color:#3b5bb5">true</span>  -> print_endline(<span style="color:#409b1c">"Pong"</span>)
        <span style="color:#ff7800">|</span> <span style="color:#3b5bb5">false</span> -> print_endline(<span style="color:#409b1c">"Error"</span>)
    <span style="color:#ff7800">in</span>
    riak_disconnect conn;
    exit <span style="color:#3b5bb5">0</span>;;    

handle_unix_error client <span style="color:#3b5bb5">()</span>;;

</pre>

		
Compile this example with the following:

```
   todo
```
