module rec Riak_messages_piqi :
             sig
               type httplistresources_response = Httplistresources_response.t
               
             end = Riak_messages_piqi
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
  
let rec parse_string x = Piqirun.string_of_block x
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
  
let rec gen__string code x = Piqirun.string_to_block code x
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
  
let gen_string x = gen__string (-1) x
  
let gen_httplistresources_response x = gen__httplistresources_response (-1) x
  
let piqi =
  [ "âÊæ4\rriak-messages \148ÑH\129ø®hÚô\134¶\012Ü\006\138é\142û\014Õ\006ÒËò$F\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\018riak-kv-wm-bucketsÒ«\158Â\006\006string\130\157Ï­\015\018riak_kv_wm_bucketsÒËò$B\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\016riak-kv-wm-indexÒ«\158Â\006\006string\130\157Ï­\015\016riak_kv_wm_indexÒËò$F\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\018riak-kv-wm-keylistÒ«\158Â\006\006string\130\157Ï­\015\018riak_kv_wm_keylistÒËò$N\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\022riak-kv-wm-link-walkerÒ«\158Â\006\006string\130\157Ï­\015\022riak_kv_wm_link_walkerÒËò$D\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\017riak-kv-wm-mapredÒ«\158Â\006\006string\130\157Ï­\015\017riak_kv_wm_mapredÒËò$D\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\017riak-kv-wm-objectÒ«\158Â\006\006string\130\157Ï­\015\017riak_kv_wm_objectÒËò$@\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\015riak-kv-wm-pingÒ«\158Â\006\006string\130\157Ï­\015\015riak_kv_wm_pingÒËò$B\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\016riak-kv-wm-propsÒ«\158Â\006\006string\130\157Ï­\015\016riak_kv_wm_propsÒËò$B\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\016riak-kv-wm-statsÒ«\158Â\006\006string\130\157Ï­\015\016riak_kv_wm_statsÒËò$L\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\021riak-solr-searcher-wmÒ«\158Â\006\006string\130\157Ï­\015\021riak_solr_searcher_wmÒËò$J\152¶\154\152\004úøÖ\130\001Ú¤î¿\004\020riak-solr-indexer-wmÒ«\158Â\006\006string\130\157Ï­\015\020riak_solr_indexer_wmÚ¤î¿\004\026httplistresources-response" ]
  

