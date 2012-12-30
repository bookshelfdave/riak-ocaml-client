let piqi = Riak_messages_piqi.piqi
  
let _ = Piqirun_ext.init_piqi piqi
  
let _int_piqtype = Piqirun_ext.find_piqtype "int"
  
let _bool_piqtype = Piqirun_ext.find_piqtype "bool"
  
let _string_piqtype = Piqirun_ext.find_piqtype "string"
  
let _httpsetbucketprops_piqtype =
  Piqirun_ext.find_piqtype "riak-messages/httpsetbucketprops"
  
let _bucketprops_piqtype =
  Piqirun_ext.find_piqtype "riak-messages/bucketprops"
  
let _httplistresources_response_piqtype =
  Piqirun_ext.find_piqtype "riak-messages/httplistresources-response"
  
let parse_int ?opts x (format : Piqirun_ext.input_format) =
  let x_pb = Piqirun_ext.convert _int_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb in Riak_messages_piqi.parse_int buf
  
let parse_bool ?opts x (format : Piqirun_ext.input_format) =
  let x_pb = Piqirun_ext.convert _bool_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_bool buf
  
let parse_string ?opts x (format : Piqirun_ext.input_format) =
  let x_pb = Piqirun_ext.convert _string_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_string buf
  
let parse_httpsetbucketprops ?opts x (format : Piqirun_ext.input_format) =
  let x_pb =
    Piqirun_ext.convert _httpsetbucketprops_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_httpsetbucketprops buf
  
let parse_bucketprops ?opts x (format : Piqirun_ext.input_format) =
  let x_pb = Piqirun_ext.convert _bucketprops_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_bucketprops buf
  
let parse_httplistresources_response ?opts x
                                     (format : Piqirun_ext.input_format) =
  let x_pb =
    Piqirun_ext.convert _httplistresources_response_piqtype format `pb x
      ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_httplistresources_response buf
  
let gen_int ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_int x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _int_piqtype `pb format x_pb ?opts
  
let gen_bool ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_bool x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _bool_piqtype `pb format x_pb ?opts
  
let gen_string ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_string x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _string_piqtype `pb format x_pb ?opts
  
let gen_httpsetbucketprops ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_httpsetbucketprops x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _httpsetbucketprops_piqtype `pb format x_pb ?opts
  
let gen_bucketprops ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_bucketprops x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _bucketprops_piqtype `pb format x_pb ?opts
  
let gen_httplistresources_response ?opts x
                                   (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_httplistresources_response x in
  let x_pb = Piqirun.to_string buf
  in
    Piqirun_ext.convert _httplistresources_response_piqtype `pb format x_pb
      ?opts
  
let print_int x = Pervasives.print_endline (gen_int x `piq)
  
let prerr_int x = Pervasives.prerr_endline (gen_int x `piq)
  
let print_bool x = Pervasives.print_endline (gen_bool x `piq)
  
let prerr_bool x = Pervasives.prerr_endline (gen_bool x `piq)
  
let print_string x = Pervasives.print_endline (gen_string x `piq)
  
let prerr_string x = Pervasives.prerr_endline (gen_string x `piq)
  
let print_httpsetbucketprops x =
  Pervasives.print_endline (gen_httpsetbucketprops x `piq)
  
let prerr_httpsetbucketprops x =
  Pervasives.prerr_endline (gen_httpsetbucketprops x `piq)
  
let print_bucketprops x = Pervasives.print_endline (gen_bucketprops x `piq)
  
let prerr_bucketprops x = Pervasives.prerr_endline (gen_bucketprops x `piq)
  
let print_httplistresources_response x =
  Pervasives.print_endline (gen_httplistresources_response x `piq)
  
let prerr_httplistresources_response x =
  Pervasives.prerr_endline (gen_httplistresources_response x `piq)
  

