let piqi = Riak_messages_piqi.piqi
  
let _ = Piqirun_ext.init_piqi piqi
  
let _string_piqtype = Piqirun_ext.find_piqtype "string"
  
let _httplistresources_response_piqtype =
  Piqirun_ext.find_piqtype "riak-messages/httplistresources-response"
  
let parse_string ?opts x (format : Piqirun_ext.input_format) =
  let x_pb = Piqirun_ext.convert _string_piqtype format `pb x ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_string buf
  
let parse_httplistresources_response ?opts x
                                     (format : Piqirun_ext.input_format) =
  let x_pb =
    Piqirun_ext.convert _httplistresources_response_piqtype format `pb x
      ?opts in
  let buf = Piqirun.init_from_string x_pb
  in Riak_messages_piqi.parse_httplistresources_response buf
  
let gen_string ?opts x (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_string x in
  let x_pb = Piqirun.to_string buf
  in Piqirun_ext.convert _string_piqtype `pb format x_pb ?opts
  
let gen_httplistresources_response ?opts x
                                   (format : Piqirun_ext.output_format) =
  let buf = Riak_messages_piqi.gen_httplistresources_response x in
  let x_pb = Piqirun.to_string buf
  in
    Piqirun_ext.convert _httplistresources_response_piqtype `pb format x_pb
      ?opts
  
let print_string x = Pervasives.print_endline (gen_string x `piq)
  
let prerr_string x = Pervasives.prerr_endline (gen_string x `piq)
  
let print_httplistresources_response x =
  Pervasives.print_endline (gen_httplistresources_response x `piq)
  
let prerr_httplistresources_response x =
  Pervasives.prerr_endline (gen_httplistresources_response x `piq)
  

