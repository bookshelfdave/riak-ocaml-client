riak-ocaml-client
=====

**© 2012 Dave Parfitt**

riak-ocaml-client is a Riak 1.2 Protobuffs-only client for OCaml 3.12.1.

*This is a work in progress. I hope to have it finished up by RICON. Pull requests accepted!*

###Dependencies

* [ocamlfind](http://projects.camlcity.org/projects/findlib.html)
* [Piqi](http://piqi.org/)
* [http://code.google.com/p/protobuf/](Protobuffs)
   * On OSX, `brew install protobuf` if you are using Homebrew
* [http://ounit.forge.ocamlcore.org/](OUnit)

###TODO
    * test search, index
    * retries
    * conflict resolver
    * better error handling	
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
### Development Guide

**These docs are incomplete at the moment**
 
#### A note on types
 
#### Connect/Disconnect
To connect:

    let conn = riak_connect "127.0.0.1" 8081
    
To disconnect:    

    riak_disconnect conn

#### Ping

#### Client ID

#### Server Info

#### Get

**type riak_get_option =**

- **Get_r** of *riak_tunable_cap*
  
  Read quorum. How many replicas need to agree when retrieving the object. Default is defined per bucket. See the Tunable CAP Options section below.
      
- **Get_pr** of *riak_tunable_cap*
   
	Primary read quorum. How many primary replicas need to be available when retrieving the object. Default is defined per bucket. See the Tunable CAP Options section below.

- **Get_basic_quorum** of *bool*

	Whether to return early in some failure cases (eg. when r=1 and you get 2 errors and a success basic_quorum=true would return an error). Default is defined per bucket.

- **Get_notfound_ok** of *bool*
  
	Whether to treat notfounds as successful reads for the purposes of R (default is defined per the bucket). Default is defined per bucket.
 
- **Get_if_modified** of *string*

	When a vclock is supplied as this option only return the object if the vclocks don't match
 
- **Get_head** of *bool*

	Return the object with the value(s) set as empty - allows you to get the metadata without a potentially large value

- **Get_deleted_vclock** of *bool*
  
	Return the tombstone's vclock, if applicable
 
#### Put

type riak_put_option =

- **Put_w** of *riak_tunable_cap*

    Write quorum. How many replicas to write to before returning a successful response. Default is defined per bucket. See the Tunable CAP Options section below.
    
- **Put_dw** of *riak_tunable_cap*

	How many replicas to commit to durable storage before returning a successful response. Default is defined per bucket. See the Tunable CAP Options section below.

- **Put_return_body** of *bool*

	 Whether to return the contents of the stored object. Defaults to false.

- **Put_pw** of *riak_tunable_cap*

	How many primary nodes must be up when the write is attempted. Default is defined per bucket. See the Tunable CAP Options section below.
	
- **Put_if_not_modified** of *bool*
	Update the value only if the vclock in the supplied object matches the one in the database.

- **Put_if_none_match** of *bool*
	Store the value only if this bucket/key combination are not already defined.

- **Put_return_head** of *bool*

	Like *return_body" except that the value(s) in the object are blank to avoid returning potentially large value(s).

#### Delete


type riak_del_option =

- **Del_rw** of *riak_tunable_cap*
	How many replicas to delete before returning a successful response. Default is defined per bucket. See the Tunable CAP Options section below.

- **Del_vclock** of *string*
	Opaque vector clock provided by an earlier Get request. Use to prevent deleting of objects that have been modified since the last get request.
 
- **Del_r** of *riak_tunable_cap*
	Read quorum. How many replicas need to agree when retrieving the object. Default is defined per bucket. See the Tunable CAP Options section below.
 
- **Del_w** of *riak_tunable_cap*
	Write quorum. How many replicas to write to before returning a successful response. Default is defined per bucket. See the Tunable CAP Options section below.
 
- **Del_pr** of *riak_tunable_cap*
	Primary read quorum. How many primary replicas need to be available when retrieving the object. Default is defined per bucket. See the Tunable CAP Options section below.
 
- **Del_pw** of *riak_tunable_cap*
	How many primary nodes must be up when the write is attempted. Default is defined per bucket. See the Tunable CAP Options section below.
 
- **Del_dw** of *riak_tunable_cap*
	How many replicas to commit to durable storage before returning a successful response. Default is defined per bucket. See the Tunable CAP Options section below.



#### Tunable CAP Options

 type riak_tunable_cap =

- **Riak_value_one**
- **Riak_value_quorum**
- **Riak_value_all**
- **Riak_value_default**
- **Riak_value of Riak_kv_piqi.uint32**


#### List Buckets

#### List Keys

#### Get Bucket Props (limited)

#### Set Bucket Props (limited)

#### Map/Reduce

#### Index Query

#### Riak Search


type riak_search_option =

- **Search_rows** of *Riak_kv_piqi.uint32*

	 Specify the maximum number of results to return. Default is 10.
	 
- **Search_start** of *Riak_kv_piqi.uint32*

	 Specify the starting result of the query. Useful for paging. Default is 0.
	 
- **Search_sort** of *string*

	Sort on the specified field name. Default is “none”, which causes the results to be sorted in descending order by score.
	
- **Search_filter** of *string*

	Filters the search by an additional query scoped to inline fields.
	
- **Search_df** of *string*

	Use the provided field as the default. Overrides the “default_field” setting in the schema file.
	
- **Search_op** of *string*

	Allowed settings are either “and” or “or”. Overrides the “default_op” setting in the schema file. Default is “or”.
	
- **Search_fl** of *string list*

	Return fields limit (for ids only, generally).

- **Search_presort** of *string*

	Presort (key / score)

---
**© 2012 Dave Parfitt**

