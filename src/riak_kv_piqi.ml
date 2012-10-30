module Riak = Riak_piqi
  
module rec Riak_kv_piqi :
             sig
               type uint32 = int32
               
               type binary = string
               
               type rpb_index_req_index_query_type = [ | `eq | `range ]
               
               type rpb_get_client_id_resp = Rpb_get_client_id_resp.t
               
               type rpb_set_client_id_req = Rpb_set_client_id_req.t
               
               type rpb_get_req = Rpb_get_req.t
               
               type rpb_get_resp = Rpb_get_resp.t
               
               type rpb_put_req = Rpb_put_req.t
               
               type rpb_put_resp = Rpb_put_resp.t
               
               type rpb_del_req = Rpb_del_req.t
               
               type rpb_list_buckets_resp = Rpb_list_buckets_resp.t
               
               type rpb_list_keys_req = Rpb_list_keys_req.t
               
               type rpb_list_keys_resp = Rpb_list_keys_resp.t
               
               type rpb_get_bucket_req = Rpb_get_bucket_req.t
               
               type rpb_get_bucket_resp = Rpb_get_bucket_resp.t
               
               type rpb_set_bucket_req = Rpb_set_bucket_req.t
               
               type rpb_map_red_req = Rpb_map_red_req.t
               
               type rpb_map_red_resp = Rpb_map_red_resp.t
               
               type rpb_index_req = Rpb_index_req.t
               
               type rpb_index_resp = Rpb_index_resp.t
               
               type rpb_content = Rpb_content.t
               
               type rpb_link = Rpb_link.t
               
               type rpb_bucket_props = Rpb_bucket_props.t
               
             end = Riak_kv_piqi
and
  Rpb_get_client_id_resp :
    sig type t = { mutable client_id : Riak_kv_piqi.binary }
         end =
    Rpb_get_client_id_resp
and
  Rpb_set_client_id_req :
    sig type t = { mutable client_id : Riak_kv_piqi.binary }
         end =
    Rpb_set_client_id_req
and
  Rpb_get_req :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary;
          mutable key : Riak_kv_piqi.binary;
          mutable r : Riak_kv_piqi.uint32 option;
          mutable pr : Riak_kv_piqi.uint32 option;
          mutable basic_quorum : bool option;
          mutable notfound_ok : bool option;
          mutable if_modified : Riak_kv_piqi.binary option;
          mutable head : bool option; mutable deletedvclock : bool option
        }
      
    end = Rpb_get_req
and
  Rpb_get_resp :
    sig
      type t =
        { mutable content : Riak_kv_piqi.rpb_content list;
          mutable vclock : Riak_kv_piqi.binary option;
          mutable unchanged : bool option
        }
      
    end = Rpb_get_resp
and
  Rpb_put_req :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary;
          mutable key : Riak_kv_piqi.binary option;
          mutable vclock : Riak_kv_piqi.binary option;
          mutable content : Riak_kv_piqi.rpb_content;
          mutable w : Riak_kv_piqi.uint32 option;
          mutable dw : Riak_kv_piqi.uint32 option;
          mutable return_body : bool option;
          mutable pw : Riak_kv_piqi.uint32 option;
          mutable if_not_modified : bool option;
          mutable if_none_match : bool option;
          mutable return_head : bool option
        }
      
    end = Rpb_put_req
and
  Rpb_put_resp :
    sig
      type t =
        { mutable content : Riak_kv_piqi.rpb_content list;
          mutable vclock : Riak_kv_piqi.binary option;
          mutable key : Riak_kv_piqi.binary option
        }
      
    end = Rpb_put_resp
and
  Rpb_del_req :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary;
          mutable key : Riak_kv_piqi.binary;
          mutable rw : Riak_kv_piqi.uint32 option;
          mutable vclock : Riak_kv_piqi.binary option;
          mutable r : Riak_kv_piqi.uint32 option;
          mutable w : Riak_kv_piqi.uint32 option;
          mutable pr : Riak_kv_piqi.uint32 option;
          mutable pw : Riak_kv_piqi.uint32 option;
          mutable dw : Riak_kv_piqi.uint32 option
        }
      
    end = Rpb_del_req
and
  Rpb_list_buckets_resp :
    sig type t = { mutable buckets : Riak_kv_piqi.binary list }
         end =
    Rpb_list_buckets_resp
and
  Rpb_list_keys_req :
    sig type t = { mutable bucket : Riak_kv_piqi.binary }
         end =
    Rpb_list_keys_req
and
  Rpb_list_keys_resp :
    sig
      type t =
        { mutable keys : Riak_kv_piqi.binary list;
          mutable isdone : bool option
        }
      
    end = Rpb_list_keys_resp
and
  Rpb_get_bucket_req :
    sig type t = { mutable bucket : Riak_kv_piqi.binary }
         end =
    Rpb_get_bucket_req
and
  Rpb_get_bucket_resp :
    sig type t = { mutable props : Riak_kv_piqi.rpb_bucket_props }
         end =
    Rpb_get_bucket_resp
and
  Rpb_set_bucket_req :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary;
          mutable props : Riak_kv_piqi.rpb_bucket_props
        }
      
    end = Rpb_set_bucket_req
and
  Rpb_map_red_req :
    sig
      type t =
        { mutable request : Riak_kv_piqi.binary;
          mutable content_type : Riak_kv_piqi.binary
        }
      
    end = Rpb_map_red_req
and
  Rpb_map_red_resp :
    sig
      type t =
        { mutable phase : Riak_kv_piqi.uint32 option;
          mutable response : Riak_kv_piqi.binary option;
          mutable isdone : bool option
        }
      
    end = Rpb_map_red_resp
and
  Rpb_index_req :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary;
          mutable index : Riak_kv_piqi.binary;
          mutable qtype : Riak_kv_piqi.rpb_index_req_index_query_type;
          mutable key : Riak_kv_piqi.binary option;
          mutable range_min : Riak_kv_piqi.binary option;
          mutable range_max : Riak_kv_piqi.binary option
        }
      
    end = Rpb_index_req
and
  Rpb_index_resp :
    sig type t = { mutable keys : Riak_kv_piqi.binary list }
         end =
    Rpb_index_resp
and
  Rpb_content :
    sig
      type t =
        { mutable value : Riak_kv_piqi.binary;
          mutable content_type : Riak_kv_piqi.binary option;
          mutable charset : Riak_kv_piqi.binary option;
          mutable content_encoding : Riak_kv_piqi.binary option;
          mutable vtag : Riak_kv_piqi.binary option;
          mutable links : Riak_kv_piqi.rpb_link list;
          mutable last_mod : Riak_kv_piqi.uint32 option;
          mutable last_mod_usecs : Riak_kv_piqi.uint32 option;
          mutable usermeta : Riak.rpb_pair list;
          mutable indexes : Riak.rpb_pair list; mutable deleted : bool option
        }
      
    end = Rpb_content
and
  Rpb_link :
    sig
      type t =
        { mutable bucket : Riak_kv_piqi.binary option;
          mutable key : Riak_kv_piqi.binary option;
          mutable tag : Riak_kv_piqi.binary option
        }
      
    end = Rpb_link
and
  Rpb_bucket_props :
    sig
      type t =
        { mutable n_val : Riak_kv_piqi.uint32 option;
          mutable allow_mult : bool option
        }
      
    end = Rpb_bucket_props
  
include Riak_kv_piqi
  
let rec parse_binary x = Piqirun.string_of_block x
and parse_uint32 x = Piqirun.int32_of_varint x
and packed_parse_uint32 x = Piqirun.int32_of_packed_varint x
and parse_bool x = Piqirun.bool_of_varint x
and packed_parse_bool x = Piqirun.bool_of_packed_varint x
and parse_rpb_get_client_id_resp x =
  let x = Piqirun.parse_record x in
  let (_client_id, x) = Piqirun.parse_required_field 1 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_get_client_id_resp.client_id = _client_id; })
and parse_rpb_set_client_id_req x =
  let x = Piqirun.parse_record x in
  let (_client_id, x) = Piqirun.parse_required_field 1 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_set_client_id_req.client_id = _client_id; })
and parse_rpb_get_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_key, x) = Piqirun.parse_required_field 2 parse_binary x in
  let (_r, x) = Piqirun.parse_optional_field 3 parse_uint32 x in
  let (_pr, x) = Piqirun.parse_optional_field 4 parse_uint32 x in
  let (_basic_quorum, x) = Piqirun.parse_optional_field 5 parse_bool x in
  let (_notfound_ok, x) = Piqirun.parse_optional_field 6 parse_bool x in
  let (_if_modified, x) = Piqirun.parse_optional_field 7 parse_binary x in
  let (_head, x) = Piqirun.parse_optional_field 8 parse_bool x in
  let (_deletedvclock, x) = Piqirun.parse_optional_field 9 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_get_req.bucket = _bucket;
       Rpb_get_req.key = _key;
       Rpb_get_req.r = _r;
       Rpb_get_req.pr = _pr;
       Rpb_get_req.basic_quorum = _basic_quorum;
       Rpb_get_req.notfound_ok = _notfound_ok;
       Rpb_get_req.if_modified = _if_modified;
       Rpb_get_req.head = _head;
       Rpb_get_req.deletedvclock = _deletedvclock;
     })
and parse_rpb_get_resp x =
  let x = Piqirun.parse_record x in
  let (_content, x) = Piqirun.parse_repeated_field 1 parse_rpb_content x in
  let (_vclock, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_unchanged, x) = Piqirun.parse_optional_field 3 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_get_resp.content = _content;
       Rpb_get_resp.vclock = _vclock;
       Rpb_get_resp.unchanged = _unchanged;
     })
and parse_rpb_put_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_key, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_vclock, x) = Piqirun.parse_optional_field 3 parse_binary x in
  let (_content, x) = Piqirun.parse_required_field 4 parse_rpb_content x in
  let (_w, x) = Piqirun.parse_optional_field 5 parse_uint32 x in
  let (_dw, x) = Piqirun.parse_optional_field 6 parse_uint32 x in
  let (_return_body, x) = Piqirun.parse_optional_field 7 parse_bool x in
  let (_pw, x) = Piqirun.parse_optional_field 8 parse_uint32 x in
  let (_if_not_modified, x) = Piqirun.parse_optional_field 9 parse_bool x in
  let (_if_none_match, x) = Piqirun.parse_optional_field 10 parse_bool x in
  let (_return_head, x) = Piqirun.parse_optional_field 11 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_put_req.bucket = _bucket;
       Rpb_put_req.key = _key;
       Rpb_put_req.vclock = _vclock;
       Rpb_put_req.content = _content;
       Rpb_put_req.w = _w;
       Rpb_put_req.dw = _dw;
       Rpb_put_req.return_body = _return_body;
       Rpb_put_req.pw = _pw;
       Rpb_put_req.if_not_modified = _if_not_modified;
       Rpb_put_req.if_none_match = _if_none_match;
       Rpb_put_req.return_head = _return_head;
     })
and parse_rpb_put_resp x =
  let x = Piqirun.parse_record x in
  let (_content, x) = Piqirun.parse_repeated_field 1 parse_rpb_content x in
  let (_vclock, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_key, x) = Piqirun.parse_optional_field 3 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_put_resp.content = _content;
       Rpb_put_resp.vclock = _vclock;
       Rpb_put_resp.key = _key;
     })
and parse_rpb_del_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_key, x) = Piqirun.parse_required_field 2 parse_binary x in
  let (_rw, x) = Piqirun.parse_optional_field 3 parse_uint32 x in
  let (_vclock, x) = Piqirun.parse_optional_field 4 parse_binary x in
  let (_r, x) = Piqirun.parse_optional_field 5 parse_uint32 x in
  let (_w, x) = Piqirun.parse_optional_field 6 parse_uint32 x in
  let (_pr, x) = Piqirun.parse_optional_field 7 parse_uint32 x in
  let (_pw, x) = Piqirun.parse_optional_field 8 parse_uint32 x in
  let (_dw, x) = Piqirun.parse_optional_field 9 parse_uint32 x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_del_req.bucket = _bucket;
       Rpb_del_req.key = _key;
       Rpb_del_req.rw = _rw;
       Rpb_del_req.vclock = _vclock;
       Rpb_del_req.r = _r;
       Rpb_del_req.w = _w;
       Rpb_del_req.pr = _pr;
       Rpb_del_req.pw = _pw;
       Rpb_del_req.dw = _dw;
     })
and parse_rpb_list_buckets_resp x =
  let x = Piqirun.parse_record x in
  let (_buckets, x) = Piqirun.parse_repeated_field 1 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_list_buckets_resp.buckets = _buckets; })
and parse_rpb_list_keys_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_list_keys_req.bucket = _bucket; })
and parse_rpb_list_keys_resp x =
  let x = Piqirun.parse_record x in
  let (_keys, x) = Piqirun.parse_repeated_field 1 parse_binary x in
  let (_isdone, x) = Piqirun.parse_optional_field 2 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_list_keys_resp.keys = _keys; Rpb_list_keys_resp.isdone = _isdone;
     })
and parse_rpb_get_bucket_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_get_bucket_req.bucket = _bucket; })
and parse_rpb_get_bucket_resp x =
  let x = Piqirun.parse_record x in
  let (_props, x) = Piqirun.parse_required_field 1 parse_rpb_bucket_props x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_get_bucket_resp.props = _props; })
and parse_rpb_set_bucket_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_props, x) = Piqirun.parse_required_field 2 parse_rpb_bucket_props x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_set_bucket_req.bucket = _bucket;
       Rpb_set_bucket_req.props = _props;
     })
and parse_rpb_map_red_req x =
  let x = Piqirun.parse_record x in
  let (_request, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_content_type, x) = Piqirun.parse_required_field 2 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_map_red_req.request = _request;
       Rpb_map_red_req.content_type = _content_type;
     })
and parse_rpb_map_red_resp x =
  let x = Piqirun.parse_record x in
  let (_phase, x) = Piqirun.parse_optional_field 1 parse_uint32 x in
  let (_response, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_isdone, x) = Piqirun.parse_optional_field 3 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_map_red_resp.phase = _phase;
       Rpb_map_red_resp.response = _response;
       Rpb_map_red_resp.isdone = _isdone;
     })
and parse_rpb_index_req x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_index, x) = Piqirun.parse_required_field 2 parse_binary x in
  let (_qtype, x) =
    Piqirun.parse_required_field 3 parse_rpb_index_req_index_query_type x in
  let (_key, x) = Piqirun.parse_optional_field 4 parse_binary x in
  let (_range_min, x) = Piqirun.parse_optional_field 5 parse_binary x in
  let (_range_max, x) = Piqirun.parse_optional_field 6 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_index_req.bucket = _bucket;
       Rpb_index_req.index = _index;
       Rpb_index_req.qtype = _qtype;
       Rpb_index_req.key = _key;
       Rpb_index_req.range_min = _range_min;
       Rpb_index_req.range_max = _range_max;
     })
and parse_rpb_index_req_index_query_type x =
  match Piqirun.int32_of_signed_varint x with
  | 0l -> `eq
  | 1l -> `range
  | x -> Piqirun.error_enum_const x
and packed_parse_rpb_index_req_index_query_type x =
  match Piqirun.int32_of_packed_signed_varint x with
  | 0l -> `eq
  | 1l -> `range
  | x -> Piqirun.error_enum_const x
and parse_rpb_index_resp x =
  let x = Piqirun.parse_record x in
  let (_keys, x) = Piqirun.parse_repeated_field 1 parse_binary x
  in (Piqirun.check_unparsed_fields x; { Rpb_index_resp.keys = _keys; })
and parse_rpb_content x =
  let x = Piqirun.parse_record x in
  let (_value, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_content_type, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_charset, x) = Piqirun.parse_optional_field 3 parse_binary x in
  let (_content_encoding, x) =
    Piqirun.parse_optional_field 4 parse_binary x in
  let (_vtag, x) = Piqirun.parse_optional_field 5 parse_binary x in
  let (_links, x) = Piqirun.parse_repeated_field 6 parse_rpb_link x in
  let (_last_mod, x) = Piqirun.parse_optional_field 7 parse_uint32 x in
  let (_last_mod_usecs, x) = Piqirun.parse_optional_field 8 parse_uint32 x in
  let (_usermeta, x) =
    Piqirun.parse_repeated_field 9 Riak.parse_rpb_pair x in
  let (_indexes, x) =
    Piqirun.parse_repeated_field 10 Riak.parse_rpb_pair x in
  let (_deleted, x) = Piqirun.parse_optional_field 11 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_content.value = _value;
       Rpb_content.content_type = _content_type;
       Rpb_content.charset = _charset;
       Rpb_content.content_encoding = _content_encoding;
       Rpb_content.vtag = _vtag;
       Rpb_content.links = _links;
       Rpb_content.last_mod = _last_mod;
       Rpb_content.last_mod_usecs = _last_mod_usecs;
       Rpb_content.usermeta = _usermeta;
       Rpb_content.indexes = _indexes;
       Rpb_content.deleted = _deleted;
     })
and parse_rpb_link x =
  let x = Piqirun.parse_record x in
  let (_bucket, x) = Piqirun.parse_optional_field 1 parse_binary x in
  let (_key, x) = Piqirun.parse_optional_field 2 parse_binary x in
  let (_tag, x) = Piqirun.parse_optional_field 3 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_link.bucket = _bucket; Rpb_link.key = _key; Rpb_link.tag = _tag; })
and parse_rpb_bucket_props x =
  let x = Piqirun.parse_record x in
  let (_n_val, x) = Piqirun.parse_optional_field 1 parse_uint32 x in
  let (_allow_mult, x) = Piqirun.parse_optional_field 2 parse_bool x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_bucket_props.n_val = _n_val;
       Rpb_bucket_props.allow_mult = _allow_mult;
     })
  
let rec gen__binary code x = Piqirun.string_to_block code x
and gen__uint32 code x = Piqirun.int32_to_varint code x
and packed_gen__uint32 x = Piqirun.int32_to_packed_varint x
and gen__bool code x = Piqirun.bool_to_varint code x
and packed_gen__bool x = Piqirun.bool_to_packed_varint x
and gen__rpb_get_client_id_resp code x =
  let _client_id =
    Piqirun.gen_required_field 1 gen__binary
      x.Rpb_get_client_id_resp.client_id
  in Piqirun.gen_record code [ _client_id ]
and gen__rpb_set_client_id_req code x =
  let _client_id =
    Piqirun.gen_required_field 1 gen__binary
      x.Rpb_set_client_id_req.client_id
  in Piqirun.gen_record code [ _client_id ]
and gen__rpb_get_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_get_req.bucket in
  let _key = Piqirun.gen_required_field 2 gen__binary x.Rpb_get_req.key in
  let _r = Piqirun.gen_optional_field 3 gen__uint32 x.Rpb_get_req.r in
  let _pr = Piqirun.gen_optional_field 4 gen__uint32 x.Rpb_get_req.pr in
  let _basic_quorum =
    Piqirun.gen_optional_field 5 gen__bool x.Rpb_get_req.basic_quorum in
  let _notfound_ok =
    Piqirun.gen_optional_field 6 gen__bool x.Rpb_get_req.notfound_ok in
  let _if_modified =
    Piqirun.gen_optional_field 7 gen__binary x.Rpb_get_req.if_modified in
  let _head = Piqirun.gen_optional_field 8 gen__bool x.Rpb_get_req.head in
  let _deletedvclock =
    Piqirun.gen_optional_field 9 gen__bool x.Rpb_get_req.deletedvclock
  in
    Piqirun.gen_record code
      [ _bucket; _key; _r; _pr; _basic_quorum; _notfound_ok; _if_modified;
        _head; _deletedvclock ]
and gen__rpb_get_resp code x =
  let _content =
    Piqirun.gen_repeated_field 1 gen__rpb_content x.Rpb_get_resp.content in
  let _vclock =
    Piqirun.gen_optional_field 2 gen__binary x.Rpb_get_resp.vclock in
  let _unchanged =
    Piqirun.gen_optional_field 3 gen__bool x.Rpb_get_resp.unchanged
  in Piqirun.gen_record code [ _content; _vclock; _unchanged ]
and gen__rpb_put_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_put_req.bucket in
  let _key = Piqirun.gen_optional_field 2 gen__binary x.Rpb_put_req.key in
  let _vclock =
    Piqirun.gen_optional_field 3 gen__binary x.Rpb_put_req.vclock in
  let _content =
    Piqirun.gen_required_field 4 gen__rpb_content x.Rpb_put_req.content in
  let _w = Piqirun.gen_optional_field 5 gen__uint32 x.Rpb_put_req.w in
  let _dw = Piqirun.gen_optional_field 6 gen__uint32 x.Rpb_put_req.dw in
  let _return_body =
    Piqirun.gen_optional_field 7 gen__bool x.Rpb_put_req.return_body in
  let _pw = Piqirun.gen_optional_field 8 gen__uint32 x.Rpb_put_req.pw in
  let _if_not_modified =
    Piqirun.gen_optional_field 9 gen__bool x.Rpb_put_req.if_not_modified in
  let _if_none_match =
    Piqirun.gen_optional_field 10 gen__bool x.Rpb_put_req.if_none_match in
  let _return_head =
    Piqirun.gen_optional_field 11 gen__bool x.Rpb_put_req.return_head
  in
    Piqirun.gen_record code
      [ _bucket; _key; _vclock; _content; _w; _dw; _return_body; _pw;
        _if_not_modified; _if_none_match; _return_head ]
and gen__rpb_put_resp code x =
  let _content =
    Piqirun.gen_repeated_field 1 gen__rpb_content x.Rpb_put_resp.content in
  let _vclock =
    Piqirun.gen_optional_field 2 gen__binary x.Rpb_put_resp.vclock in
  let _key = Piqirun.gen_optional_field 3 gen__binary x.Rpb_put_resp.key
  in Piqirun.gen_record code [ _content; _vclock; _key ]
and gen__rpb_del_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_del_req.bucket in
  let _key = Piqirun.gen_required_field 2 gen__binary x.Rpb_del_req.key in
  let _rw = Piqirun.gen_optional_field 3 gen__uint32 x.Rpb_del_req.rw in
  let _vclock =
    Piqirun.gen_optional_field 4 gen__binary x.Rpb_del_req.vclock in
  let _r = Piqirun.gen_optional_field 5 gen__uint32 x.Rpb_del_req.r in
  let _w = Piqirun.gen_optional_field 6 gen__uint32 x.Rpb_del_req.w in
  let _pr = Piqirun.gen_optional_field 7 gen__uint32 x.Rpb_del_req.pr in
  let _pw = Piqirun.gen_optional_field 8 gen__uint32 x.Rpb_del_req.pw in
  let _dw = Piqirun.gen_optional_field 9 gen__uint32 x.Rpb_del_req.dw
  in
    Piqirun.gen_record code
      [ _bucket; _key; _rw; _vclock; _r; _w; _pr; _pw; _dw ]
and gen__rpb_list_buckets_resp code x =
  let _buckets =
    Piqirun.gen_repeated_field 1 gen__binary x.Rpb_list_buckets_resp.buckets
  in Piqirun.gen_record code [ _buckets ]
and gen__rpb_list_keys_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_list_keys_req.bucket
  in Piqirun.gen_record code [ _bucket ]
and gen__rpb_list_keys_resp code x =
  let _keys =
    Piqirun.gen_repeated_field 1 gen__binary x.Rpb_list_keys_resp.keys in
  let _isdone =
    Piqirun.gen_optional_field 2 gen__bool x.Rpb_list_keys_resp.isdone
  in Piqirun.gen_record code [ _keys; _isdone ]
and gen__rpb_get_bucket_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_get_bucket_req.bucket
  in Piqirun.gen_record code [ _bucket ]
and gen__rpb_get_bucket_resp code x =
  let _props =
    Piqirun.gen_required_field 1 gen__rpb_bucket_props
      x.Rpb_get_bucket_resp.props
  in Piqirun.gen_record code [ _props ]
and gen__rpb_set_bucket_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_set_bucket_req.bucket in
  let _props =
    Piqirun.gen_required_field 2 gen__rpb_bucket_props
      x.Rpb_set_bucket_req.props
  in Piqirun.gen_record code [ _bucket; _props ]
and gen__rpb_map_red_req code x =
  let _request =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_map_red_req.request in
  let _content_type =
    Piqirun.gen_required_field 2 gen__binary x.Rpb_map_red_req.content_type
  in Piqirun.gen_record code [ _request; _content_type ]
and gen__rpb_map_red_resp code x =
  let _phase =
    Piqirun.gen_optional_field 1 gen__uint32 x.Rpb_map_red_resp.phase in
  let _response =
    Piqirun.gen_optional_field 2 gen__binary x.Rpb_map_red_resp.response in
  let _isdone =
    Piqirun.gen_optional_field 3 gen__bool x.Rpb_map_red_resp.isdone
  in Piqirun.gen_record code [ _phase; _response; _isdone ]
and gen__rpb_index_req code x =
  let _bucket =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_index_req.bucket in
  let _index =
    Piqirun.gen_required_field 2 gen__binary x.Rpb_index_req.index in
  let _qtype =
    Piqirun.gen_required_field 3 gen__rpb_index_req_index_query_type
      x.Rpb_index_req.qtype in
  let _key = Piqirun.gen_optional_field 4 gen__binary x.Rpb_index_req.key in
  let _range_min =
    Piqirun.gen_optional_field 5 gen__binary x.Rpb_index_req.range_min in
  let _range_max =
    Piqirun.gen_optional_field 6 gen__binary x.Rpb_index_req.range_max
  in
    Piqirun.gen_record code
      [ _bucket; _index; _qtype; _key; _range_min; _range_max ]
and gen__rpb_index_req_index_query_type code x =
  Piqirun.int32_to_signed_varint code
    (match x with | `eq -> 0l | `range -> 1l)
and packed_gen__rpb_index_req_index_query_type x =
  Piqirun.int32_to_packed_signed_varint
    (match x with | `eq -> 0l | `range -> 1l)
and gen__rpb_index_resp code x =
  let _keys = Piqirun.gen_repeated_field 1 gen__binary x.Rpb_index_resp.keys
  in Piqirun.gen_record code [ _keys ]
and gen__rpb_content code x =
  let _value =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_content.value in
  let _content_type =
    Piqirun.gen_optional_field 2 gen__binary x.Rpb_content.content_type in
  let _charset =
    Piqirun.gen_optional_field 3 gen__binary x.Rpb_content.charset in
  let _content_encoding =
    Piqirun.gen_optional_field 4 gen__binary x.Rpb_content.content_encoding in
  let _vtag = Piqirun.gen_optional_field 5 gen__binary x.Rpb_content.vtag in
  let _links =
    Piqirun.gen_repeated_field 6 gen__rpb_link x.Rpb_content.links in
  let _last_mod =
    Piqirun.gen_optional_field 7 gen__uint32 x.Rpb_content.last_mod in
  let _last_mod_usecs =
    Piqirun.gen_optional_field 8 gen__uint32 x.Rpb_content.last_mod_usecs in
  let _usermeta =
    Piqirun.gen_repeated_field 9 Riak.gen__rpb_pair x.Rpb_content.usermeta in
  let _indexes =
    Piqirun.gen_repeated_field 10 Riak.gen__rpb_pair x.Rpb_content.indexes in
  let _deleted =
    Piqirun.gen_optional_field 11 gen__bool x.Rpb_content.deleted
  in
    Piqirun.gen_record code
      [ _value; _content_type; _charset; _content_encoding; _vtag; _links;
        _last_mod; _last_mod_usecs; _usermeta; _indexes; _deleted ]
and gen__rpb_link code x =
  let _bucket = Piqirun.gen_optional_field 1 gen__binary x.Rpb_link.bucket in
  let _key = Piqirun.gen_optional_field 2 gen__binary x.Rpb_link.key in
  let _tag = Piqirun.gen_optional_field 3 gen__binary x.Rpb_link.tag
  in Piqirun.gen_record code [ _bucket; _key; _tag ]
and gen__rpb_bucket_props code x =
  let _n_val =
    Piqirun.gen_optional_field 1 gen__uint32 x.Rpb_bucket_props.n_val in
  let _allow_mult =
    Piqirun.gen_optional_field 2 gen__bool x.Rpb_bucket_props.allow_mult
  in Piqirun.gen_record code [ _n_val; _allow_mult ]
  
let gen_binary x = gen__binary (-1) x
  
let gen_uint32 x = gen__uint32 (-1) x
  
let gen_bool x = gen__bool (-1) x
  
let gen_rpb_get_client_id_resp x = gen__rpb_get_client_id_resp (-1) x
  
let gen_rpb_set_client_id_req x = gen__rpb_set_client_id_req (-1) x
  
let gen_rpb_get_req x = gen__rpb_get_req (-1) x
  
let gen_rpb_get_resp x = gen__rpb_get_resp (-1) x
  
let gen_rpb_put_req x = gen__rpb_put_req (-1) x
  
let gen_rpb_put_resp x = gen__rpb_put_resp (-1) x
  
let gen_rpb_del_req x = gen__rpb_del_req (-1) x
  
let gen_rpb_list_buckets_resp x = gen__rpb_list_buckets_resp (-1) x
  
let gen_rpb_list_keys_req x = gen__rpb_list_keys_req (-1) x
  
let gen_rpb_list_keys_resp x = gen__rpb_list_keys_resp (-1) x
  
let gen_rpb_get_bucket_req x = gen__rpb_get_bucket_req (-1) x
  
let gen_rpb_get_bucket_resp x = gen__rpb_get_bucket_resp (-1) x
  
let gen_rpb_set_bucket_req x = gen__rpb_set_bucket_req (-1) x
  
let gen_rpb_map_red_req x = gen__rpb_map_red_req (-1) x
  
let gen_rpb_map_red_resp x = gen__rpb_map_red_resp (-1) x
  
let gen_rpb_index_req x = gen__rpb_index_req (-1) x
  
let gen_rpb_index_req_index_query_type x =
  gen__rpb_index_req_index_query_type (-1) x
  
let gen_rpb_index_resp x = gen__rpb_index_resp (-1) x
  
let gen_rpb_content x = gen__rpb_content (-1) x
  
let gen_rpb_link x = gen__rpb_link (-1) x
  
let gen_rpb_bucket_props x = gen__rpb_bucket_props (-1) x
  

