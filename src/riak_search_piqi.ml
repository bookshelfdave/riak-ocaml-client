module Riak = Riak_piqi
  
module rec Riak_search_piqi :
             sig
               type uint32 = int32
               
               type float32 = float
               
               type binary = string
               
               type rpb_search_doc = Rpb_search_doc.t
               
               type rpb_search_query_req = Rpb_search_query_req.t
               
               type rpb_search_query_resp = Rpb_search_query_resp.t
               
             end = Riak_search_piqi
and
  Rpb_search_doc : sig type t = { mutable fields : Riak.rpb_pair list }
                        end =
    Rpb_search_doc
and
  Rpb_search_query_req :
    sig
      type t =
        { mutable q : Riak_search_piqi.binary;
          mutable index : Riak_search_piqi.binary;
          mutable rows : Riak_search_piqi.uint32 option;
          mutable start : Riak_search_piqi.uint32 option;
          mutable sort : Riak_search_piqi.binary option;
          mutable filter : Riak_search_piqi.binary option;
          mutable df : Riak_search_piqi.binary option;
          mutable op : Riak_search_piqi.binary option;
          mutable fl : Riak_search_piqi.binary list;
          mutable presort : Riak_search_piqi.binary option
        }
      
    end = Rpb_search_query_req
and
  Rpb_search_query_resp :
    sig
      type t =
        { mutable docs : Riak_search_piqi.rpb_search_doc list;
          mutable max_score : Riak_search_piqi.float32 option;
          mutable num_found : Riak_search_piqi.uint32 option
        }
      
    end = Rpb_search_query_resp
  
include Riak_search_piqi
  
let rec parse_binary x = Piqirun.string_of_block x
and parse_uint32 x = Piqirun.int32_of_varint x
and packed_parse_uint32 x = Piqirun.int32_of_packed_varint x
and parse_float32 x = Piqirun.float_of_fixed32 x
and packed_parse_float32 x = Piqirun.float_of_packed_fixed32 x
and parse_rpb_search_doc x =
  let x = Piqirun.parse_record x in
  let (_fields, x) = Piqirun.parse_repeated_field 1 Riak.parse_rpb_pair x
  in (Piqirun.check_unparsed_fields x; { Rpb_search_doc.fields = _fields; })
and parse_rpb_search_query_req x =
  let x = Piqirun.parse_record x in
  let (_q, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_index, x) = Piqirun.parse_required_field 2 parse_binary x in
  let (_rows, x) = Piqirun.parse_optional_field 3 parse_uint32 x in
  let (_start, x) = Piqirun.parse_optional_field 4 parse_uint32 x in
  let (_sort, x) = Piqirun.parse_optional_field 5 parse_binary x in
  let (_filter, x) = Piqirun.parse_optional_field 6 parse_binary x in
  let (_df, x) = Piqirun.parse_optional_field 7 parse_binary x in
  let (_op, x) = Piqirun.parse_optional_field 8 parse_binary x in
  let (_fl, x) = Piqirun.parse_repeated_field 9 parse_binary x in
  let (_presort, x) = Piqirun.parse_optional_field 10 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_search_query_req.q = _q;
       Rpb_search_query_req.index = _index;
       Rpb_search_query_req.rows = _rows;
       Rpb_search_query_req.start = _start;
       Rpb_search_query_req.sort = _sort;
       Rpb_search_query_req.filter = _filter;
       Rpb_search_query_req.df = _df;
       Rpb_search_query_req.op = _op;
       Rpb_search_query_req.fl = _fl;
       Rpb_search_query_req.presort = _presort;
     })
and parse_rpb_search_query_resp x =
  let x = Piqirun.parse_record x in
  let (_docs, x) = Piqirun.parse_repeated_field 1 parse_rpb_search_doc x in
  let (_max_score, x) = Piqirun.parse_optional_field 2 parse_float32 x in
  let (_num_found, x) = Piqirun.parse_optional_field 3 parse_uint32 x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_search_query_resp.docs = _docs;
       Rpb_search_query_resp.max_score = _max_score;
       Rpb_search_query_resp.num_found = _num_found;
     })
  
let rec gen__binary code x = Piqirun.string_to_block code x
and gen__uint32 code x = Piqirun.int32_to_varint code x
and packed_gen__uint32 x = Piqirun.int32_to_packed_varint x
and gen__float32 code x = Piqirun.float_to_fixed32 code x
and packed_gen__float32 x = Piqirun.float_to_packed_fixed32 x
and gen__rpb_search_doc code x =
  let _fields =
    Piqirun.gen_repeated_field 1 Riak.gen__rpb_pair x.Rpb_search_doc.fields
  in Piqirun.gen_record code [ _fields ]
and gen__rpb_search_query_req code x =
  let _q =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_search_query_req.q in
  let _index =
    Piqirun.gen_required_field 2 gen__binary x.Rpb_search_query_req.index in
  let _rows =
    Piqirun.gen_optional_field 3 gen__uint32 x.Rpb_search_query_req.rows in
  let _start =
    Piqirun.gen_optional_field 4 gen__uint32 x.Rpb_search_query_req.start in
  let _sort =
    Piqirun.gen_optional_field 5 gen__binary x.Rpb_search_query_req.sort in
  let _filter =
    Piqirun.gen_optional_field 6 gen__binary x.Rpb_search_query_req.filter in
  let _df =
    Piqirun.gen_optional_field 7 gen__binary x.Rpb_search_query_req.df in
  let _op =
    Piqirun.gen_optional_field 8 gen__binary x.Rpb_search_query_req.op in
  let _fl =
    Piqirun.gen_repeated_field 9 gen__binary x.Rpb_search_query_req.fl in
  let _presort =
    Piqirun.gen_optional_field 10 gen__binary x.Rpb_search_query_req.presort
  in
    Piqirun.gen_record code
      [ _q; _index; _rows; _start; _sort; _filter; _df; _op; _fl; _presort ]
and gen__rpb_search_query_resp code x =
  let _docs =
    Piqirun.gen_repeated_field 1 gen__rpb_search_doc
      x.Rpb_search_query_resp.docs in
  let _max_score =
    Piqirun.gen_optional_field 2 gen__float32
      x.Rpb_search_query_resp.max_score in
  let _num_found =
    Piqirun.gen_optional_field 3 gen__uint32
      x.Rpb_search_query_resp.num_found
  in Piqirun.gen_record code [ _docs; _max_score; _num_found ]
  
let gen_binary x = gen__binary (-1) x
  
let gen_uint32 x = gen__uint32 (-1) x
  
let gen_float32 x = gen__float32 (-1) x
  
let gen_rpb_search_doc x = gen__rpb_search_doc (-1) x
  
let gen_rpb_search_query_req x = gen__rpb_search_query_req (-1) x
  
let gen_rpb_search_query_resp x = gen__rpb_search_query_resp (-1) x
  

