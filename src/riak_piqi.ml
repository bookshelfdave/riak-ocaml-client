module rec Riak_piqi :
             sig
               type uint32 = int32
               
               type binary = string
               
               type rpb_error_resp = Rpb_error_resp.t
               
               type rpb_get_server_info_resp = Rpb_get_server_info_resp.t
               
               type rpb_pair = Rpb_pair.t
               
               type rpb_get_server_info_req = Rpb_get_server_info_req.t
               
               type rpb_ping_req = Rpb_ping_req.t
               
               type rpb_ping_resp = Rpb_ping_resp.t
               
             end = Riak_piqi
and
  Rpb_error_resp :
    sig
      type t =
        { mutable errmsg : Riak_piqi.binary;
          mutable errcode : Riak_piqi.uint32
        }
      
    end = Rpb_error_resp
and
  Rpb_get_server_info_resp :
    sig
      type t =
        { mutable node : Riak_piqi.binary option;
          mutable server_version : Riak_piqi.binary option
        }
      
    end = Rpb_get_server_info_resp
and
  Rpb_pair :
    sig
      type t =
        { mutable key : Riak_piqi.binary;
          mutable value : Riak_piqi.binary option
        }
      
    end = Rpb_pair
and
  Rpb_get_server_info_req : sig type t = { _dummy : unit }
                                 end =
    Rpb_get_server_info_req
and Rpb_ping_req : sig type t = { _dummy : unit }
                        end = Rpb_ping_req
and Rpb_ping_resp : sig type t = { _dummy : unit }
                         end = Rpb_ping_resp
  
include Riak_piqi
  
let rec parse_binary x = Piqirun.string_of_block x
and parse_uint32 x = Piqirun.int32_of_varint x
and packed_parse_uint32 x = Piqirun.int32_of_packed_varint x
and parse_rpb_error_resp x =
  let x = Piqirun.parse_record x in
  let (_errmsg, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_errcode, x) = Piqirun.parse_required_field 2 parse_uint32 x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_error_resp.errmsg = _errmsg; Rpb_error_resp.errcode = _errcode; })
and parse_rpb_get_server_info_resp x =
  let x = Piqirun.parse_record x in
  let (_node, x) = Piqirun.parse_optional_field 1 parse_binary x in
  let (_server_version, x) = Piqirun.parse_optional_field 2 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     {
       Rpb_get_server_info_resp.node = _node;
       Rpb_get_server_info_resp.server_version = _server_version;
     })
and parse_rpb_pair x =
  let x = Piqirun.parse_record x in
  let (_key, x) = Piqirun.parse_required_field 1 parse_binary x in
  let (_value, x) = Piqirun.parse_optional_field 2 parse_binary x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_pair.key = _key; Rpb_pair.value = _value; })
and parse_rpb_get_server_info_req x =
  let x = Piqirun.parse_record x
  in
    (Piqirun.check_unparsed_fields x;
     { Rpb_get_server_info_req._dummy = (); })
and parse_rpb_ping_req x =
  let x = Piqirun.parse_record x
  in (Piqirun.check_unparsed_fields x; { Rpb_ping_req._dummy = (); })
and parse_rpb_ping_resp x =
  let x = Piqirun.parse_record x
  in (Piqirun.check_unparsed_fields x; { Rpb_ping_resp._dummy = (); })
  
let rec gen__binary code x = Piqirun.string_to_block code x
and gen__uint32 code x = Piqirun.int32_to_varint code x
and packed_gen__uint32 x = Piqirun.int32_to_packed_varint x
and gen__rpb_error_resp code x =
  let _errmsg =
    Piqirun.gen_required_field 1 gen__binary x.Rpb_error_resp.errmsg in
  let _errcode =
    Piqirun.gen_required_field 2 gen__uint32 x.Rpb_error_resp.errcode
  in Piqirun.gen_record code [ _errmsg; _errcode ]
and gen__rpb_get_server_info_resp code x =
  let _node =
    Piqirun.gen_optional_field 1 gen__binary x.Rpb_get_server_info_resp.node in
  let _server_version =
    Piqirun.gen_optional_field 2 gen__binary
      x.Rpb_get_server_info_resp.server_version
  in Piqirun.gen_record code [ _node; _server_version ]
and gen__rpb_pair code x =
  let _key = Piqirun.gen_required_field 1 gen__binary x.Rpb_pair.key in
  let _value = Piqirun.gen_optional_field 2 gen__binary x.Rpb_pair.value
  in Piqirun.gen_record code [ _key; _value ]
and gen__rpb_get_server_info_req code x = Piqirun.gen_record code []
and gen__rpb_ping_req code x = Piqirun.gen_record code []
and gen__rpb_ping_resp code x = Piqirun.gen_record code []
  
let gen_binary x = gen__binary (-1) x
  
let gen_uint32 x = gen__uint32 (-1) x
  
let gen_rpb_error_resp x = gen__rpb_error_resp (-1) x
  
let gen_rpb_get_server_info_resp x = gen__rpb_get_server_info_resp (-1) x
  
let gen_rpb_pair x = gen__rpb_pair (-1) x
  
let gen_rpb_get_server_info_req x = gen__rpb_get_server_info_req (-1) x
  
let gen_rpb_ping_req x = gen__rpb_ping_req (-1) x
  
let gen_rpb_ping_resp x = gen__rpb_ping_resp (-1) x
  

