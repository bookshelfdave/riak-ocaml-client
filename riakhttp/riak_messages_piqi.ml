module rec Riak_messages_piqi :
             sig
               type httpsetbucketprops = Httpsetbucketprops.t
               
               type bucketprops = Bucketprops.t
               
               type httplistresources_response = Httplistresources_response.t
               
             end = Riak_messages_piqi
and
  Httpsetbucketprops :
    sig type t = { mutable props : Riak_messages_piqi.bucketprops list }
         end =
    Httpsetbucketprops
and
  Bucketprops :
    sig
      type t =
        { mutable nval : int option; mutable allowmult : bool option;
          mutable lastwritewins : bool option;
          mutable precommit : string option;
          mutable postcommit : string option; mutable r : int option;
          mutable w : int option; mutable dr : int option;
          mutable rw : int option; mutable backend : string option
        }
      
    end = Bucketprops
and
  Httplistresources_response :
    sig
      type t =
        { mutable riak_kv_wm_buckets : string list;
          mutable riak_kv_wm_index : string list;
          mutable riak_kv_wm_keylist : string list;
          mutable riak_kv_wm_link_walker : string list;
          mutable riak_kv_wm_mapred : string list;
          mutable riak_kv_wm_object : string list;
          mutable riak_kv_wm_ping : string list;
          mutable riak_kv_wm_props : string list;
          mutable riak_kv_wm_stats : string list;
          mutable riak_solr_searcher_wm : string list;
          mutable riak_solr_indexer_wm : string list
        }
      
    end = Httplistresources_response
  
include Riak_messages_piqi
  
let rec parse_int x = Piqirun.int_of_zigzag_varint x
and packed_parse_int x = Piqirun.int_of_packed_zigzag_varint x
and parse_bool x = Piqirun.bool_of_varint x
and packed_parse_bool x = Piqirun.bool_of_packed_varint x
and parse_string x = Piqirun.string_of_block x
and parse_httpsetbucketprops x =
  let x = Piqirun.parse_record x in
  let (_props, x) = Piqirun.parse_repeated_field 1 parse_bucketprops x
  in
    (Piqirun.check_unparsed_fields x; { Httpsetbucketprops.props = _props; })
and parse_bucketprops x =
  let x = Piqirun.parse_record x in
  let (_nval, x) = Piqirun.parse_optional_field 1 parse_int x in
  let (_allowmult, x) = Piqirun.parse_optional_field 2 parse_bool x in
  let (_lastwritewins, x) = Piqirun.parse_optional_field 3 parse_bool x in
  let (_precommit, x) = Piqirun.parse_optional_field 4 parse_string x in
  let (_postcommit, x) = Piqirun.parse_optional_field 5 parse_string x in
  let (_r, x) = Piqirun.parse_optional_field 6 parse_int x in
  let (_w, x) = Piqirun.parse_optional_field 7 parse_int x in
  let (_dr, x) = Piqirun.parse_optional_field 8 parse_int x in
  let (_rw, x) = Piqirun.parse_optional_field 9 parse_int x in
  let (_backend, x) = Piqirun.parse_optional_field 10 parse_string x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Bucketprops.nval = _nval;
       Bucketprops.allowmult = _allowmult;
       Bucketprops.lastwritewins = _lastwritewins;
       Bucketprops.precommit = _precommit;
       Bucketprops.postcommit = _postcommit;
       Bucketprops.r = _r;
       Bucketprops.w = _w;
       Bucketprops.dr = _dr;
       Bucketprops.rw = _rw;
       Bucketprops.backend = _backend;
     })
and parse_httplistresources_response x =
  let x = Piqirun.parse_record x in
  let (_riak_kv_wm_buckets, x) =
    Piqirun.parse_repeated_field 1 parse_string x in
  let (_riak_kv_wm_index, x) =
    Piqirun.parse_repeated_field 2 parse_string x in
  let (_riak_kv_wm_keylist, x) =
    Piqirun.parse_repeated_field 3 parse_string x in
  let (_riak_kv_wm_link_walker, x) =
    Piqirun.parse_repeated_field 4 parse_string x in
  let (_riak_kv_wm_mapred, x) =
    Piqirun.parse_repeated_field 5 parse_string x in
  let (_riak_kv_wm_object, x) =
    Piqirun.parse_repeated_field 6 parse_string x in
  let (_riak_kv_wm_ping, x) =
    Piqirun.parse_repeated_field 7 parse_string x in
  let (_riak_kv_wm_props, x) =
    Piqirun.parse_repeated_field 8 parse_string x in
  let (_riak_kv_wm_stats, x) =
    Piqirun.parse_repeated_field 9 parse_string x in
  let (_riak_solr_searcher_wm, x) =
    Piqirun.parse_repeated_field 10 parse_string x in
  let (_riak_solr_indexer_wm, x) =
    Piqirun.parse_repeated_field 11 parse_string x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Httplistresources_response.riak_kv_wm_buckets = _riak_kv_wm_buckets;
       Httplistresources_response.riak_kv_wm_index = _riak_kv_wm_index;
       Httplistresources_response.riak_kv_wm_keylist = _riak_kv_wm_keylist;
       Httplistresources_response.riak_kv_wm_link_walker =
         _riak_kv_wm_link_walker;
       Httplistresources_response.riak_kv_wm_mapred = _riak_kv_wm_mapred;
       Httplistresources_response.riak_kv_wm_object = _riak_kv_wm_object;
       Httplistresources_response.riak_kv_wm_ping = _riak_kv_wm_ping;
       Httplistresources_response.riak_kv_wm_props = _riak_kv_wm_props;
       Httplistresources_response.riak_kv_wm_stats = _riak_kv_wm_stats;
       Httplistresources_response.riak_solr_searcher_wm =
         _riak_solr_searcher_wm;
       Httplistresources_response.riak_solr_indexer_wm =
         _riak_solr_indexer_wm;
     })
  
let rec gen__int code x = Piqirun.int_to_zigzag_varint code x
and packed_gen__int x = Piqirun.int_to_packed_zigzag_varint x
and gen__bool code x = Piqirun.bool_to_varint code x
and packed_gen__bool x = Piqirun.bool_to_packed_varint x
and gen__string code x = Piqirun.string_to_block code x
and gen__httpsetbucketprops code x =
  let _props =
    Piqirun.gen_repeated_field 1 gen__bucketprops x.Httpsetbucketprops.props
  in Piqirun.gen_record code [ _props ]
and gen__bucketprops code x =
  let _nval = Piqirun.gen_optional_field 1 gen__int x.Bucketprops.nval in
  let _allowmult =
    Piqirun.gen_optional_field 2 gen__bool x.Bucketprops.allowmult in
  let _lastwritewins =
    Piqirun.gen_optional_field 3 gen__bool x.Bucketprops.lastwritewins in
  let _precommit =
    Piqirun.gen_optional_field 4 gen__string x.Bucketprops.precommit in
  let _postcommit =
    Piqirun.gen_optional_field 5 gen__string x.Bucketprops.postcommit in
  let _r = Piqirun.gen_optional_field 6 gen__int x.Bucketprops.r in
  let _w = Piqirun.gen_optional_field 7 gen__int x.Bucketprops.w in
  let _dr = Piqirun.gen_optional_field 8 gen__int x.Bucketprops.dr in
  let _rw = Piqirun.gen_optional_field 9 gen__int x.Bucketprops.rw in
  let _backend =
    Piqirun.gen_optional_field 10 gen__string x.Bucketprops.backend
  in
    Piqirun.gen_record code
      [ _nval; _allowmult; _lastwritewins; _precommit; _postcommit; _r; _w;
        _dr; _rw; _backend ]
and gen__httplistresources_response code x =
  let _riak_kv_wm_buckets =
    Piqirun.gen_repeated_field 1 gen__string
      x.Httplistresources_response.riak_kv_wm_buckets in
  let _riak_kv_wm_index =
    Piqirun.gen_repeated_field 2 gen__string
      x.Httplistresources_response.riak_kv_wm_index in
  let _riak_kv_wm_keylist =
    Piqirun.gen_repeated_field 3 gen__string
      x.Httplistresources_response.riak_kv_wm_keylist in
  let _riak_kv_wm_link_walker =
    Piqirun.gen_repeated_field 4 gen__string
      x.Httplistresources_response.riak_kv_wm_link_walker in
  let _riak_kv_wm_mapred =
    Piqirun.gen_repeated_field 5 gen__string
      x.Httplistresources_response.riak_kv_wm_mapred in
  let _riak_kv_wm_object =
    Piqirun.gen_repeated_field 6 gen__string
      x.Httplistresources_response.riak_kv_wm_object in
  let _riak_kv_wm_ping =
    Piqirun.gen_repeated_field 7 gen__string
      x.Httplistresources_response.riak_kv_wm_ping in
  let _riak_kv_wm_props =
    Piqirun.gen_repeated_field 8 gen__string
      x.Httplistresources_response.riak_kv_wm_props in
  let _riak_kv_wm_stats =
    Piqirun.gen_repeated_field 9 gen__string
      x.Httplistresources_response.riak_kv_wm_stats in
  let _riak_solr_searcher_wm =
    Piqirun.gen_repeated_field 10 gen__string
      x.Httplistresources_response.riak_solr_searcher_wm in
  let _riak_solr_indexer_wm =
    Piqirun.gen_repeated_field 11 gen__string
      x.Httplistresources_response.riak_solr_indexer_wm
  in
    Piqirun.gen_record code
      [ _riak_kv_wm_buckets; _riak_kv_wm_index; _riak_kv_wm_keylist;
        _riak_kv_wm_link_walker; _riak_kv_wm_mapred; _riak_kv_wm_object;
        _riak_kv_wm_ping; _riak_kv_wm_props; _riak_kv_wm_stats;
        _riak_solr_searcher_wm; _riak_solr_indexer_wm ]
  
let gen_int x = gen__int (-1) x
  
let gen_bool x = gen__bool (-1) x
  
let gen_string x = gen__string (-1) x
  
let gen_httpsetbucketprops x = gen__httpsetbucketprops (-1) x
  
let gen_bucketprops x = gen__bucketprops (-1) x
  
let gen_httplistresources_response x = gen__httplistresources_response (-1) x
  
let piqi =
  [ "���4\rriak-messages�\148�H\129��h��\134�\012T\138�\142�\014N���$1\152�\154\152\004���\130\001ڤ�\004\005propsҫ\158�\006\011bucketprops\130\157ϭ\015\005propsڤ�\004\018httpsetbucketprops��\134�\012\130\004\138�\142�\014�\003���$(\152�\154\152\004�ߺ�\001ڤ�\004\004nvalҫ\158�\006\003int\130\157ϭ\015\005n_val���$3\152�\154\152\004�ߺ�\001ڤ�\004\tallowmultҫ\158�\006\004bool\130\157ϭ\015\nallow_mult���$<\152�\154\152\004�ߺ�\001ڤ�\004\rlastwritewinsҫ\158�\006\004bool\130\157ϭ\015\015last_write_wins���$4\152�\154\152\004�ߺ�\001ڤ�\004\tprecommitҫ\158�\006\006string\130\157ϭ\015\tprecommit���$5\152�\154\152\004�ߺ�\001ڤ�\004\npostcommitҫ\158�\006\006string\130\157ϭ\015\tprecommit���$!\152�\154\152\004�ߺ�\001ڤ�\004\001rҫ\158�\006\003int\130\157ϭ\015\001r���$!\152�\154\152\004�ߺ�\001ڤ�\004\001wҫ\158�\006\003int\130\157ϭ\015\001w���$#\152�\154\152\004�ߺ�\001ڤ�\004\002drҫ\158�\006\003int\130\157ϭ\015\002dr���$#\152�\154\152\004�ߺ�\001ڤ�\004\002rwҫ\158�\006\003int\130\157ϭ\015\002rw���$0\152�\154\152\004�ߺ�\001ڤ�\004\007backendҫ\158�\006\006string\130\157ϭ\015\007backendڤ�\004\011bucketprops��\134�\012�\006\138�\142�\014�\006���$F\152�\154\152\004���\130\001ڤ�\004\018riak-kv-wm-bucketsҫ\158�\006\006string\130\157ϭ\015\018riak_kv_wm_buckets���$B\152�\154\152\004���\130\001ڤ�\004\016riak-kv-wm-indexҫ\158�\006\006string\130\157ϭ\015\016riak_kv_wm_index���$F\152�\154\152\004���\130\001ڤ�\004\018riak-kv-wm-keylistҫ\158�\006\006string\130\157ϭ\015\018riak_kv_wm_keylist���$N\152�\154\152\004���\130\001ڤ�\004\022riak-kv-wm-link-walkerҫ\158�\006\006string\130\157ϭ\015\022riak_kv_wm_link_walker���$D\152�\154\152\004���\130\001ڤ�\004\017riak-kv-wm-mapredҫ\158�\006\006string\130\157ϭ\015\017riak_kv_wm_mapred���$D\152�\154\152\004���\130\001ڤ�\004\017riak-kv-wm-objectҫ\158�\006\006string\130\157ϭ\015\017riak_kv_wm_object���$@\152�\154\152\004���\130\001ڤ�\004\015riak-kv-wm-pingҫ\158�\006\006string\130\157ϭ\015\015riak_kv_wm_ping���$B\152�\154\152\004���\130\001ڤ�\004\016riak-kv-wm-propsҫ\158�\006\006string\130\157ϭ\015\016riak_kv_wm_props���$B\152�\154\152\004���\130\001ڤ�\004\016riak-kv-wm-statsҫ\158�\006\006string\130\157ϭ\015\016riak_kv_wm_stats���$L\152�\154\152\004���\130\001ڤ�\004\021riak-solr-searcher-wmҫ\158�\006\006string\130\157ϭ\015\021riak_solr_searcher_wm���$J\152�\154\152\004���\130\001ڤ�\004\020riak-solr-indexer-wmҫ\158�\006\006string\130\157ϭ\015\020riak_solr_indexer_wmڤ�\004\026httplistresources-response" ]
  

