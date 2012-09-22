#!/bin/sh
curl -v -X PUT \
	-d 'data1' \
	-H "x-riak-index-field1_bin: val1" \
	-H "x-riak-index-field2_int: 1001" \
	http://127.0.0.1:8098/riak/mybucket/mykey1

curl -v -X PUT \
	-d 'data2' \
	-H "x-riak-index-Field1_bin: val2" \
	-H "x-riak-index-Field2_int: 1002" \
	http://127.0.0.1:8098/riak/mybucket/mykey2

curl -v -X PUT \
	-d 'data3' \
	-H "X-RIAK-INDEX-FIELD1_BIN: val3" \
	-H "X-RIAK-INDEX-FIELD2_INT: 1003" \
	http://127.0.0.1:8098/riak/mybucket/mykey3

curl -v -X PUT \
	-d 'data4' \
	-H "x-riak-index-field1_bin: val4, val4, val4a, val4b" \
	-H "x-riak-index-field2_int: 1004, 1004, 1005, 1006" \
	-H "x-riak-index-field2_int: 1004" \
	-H "x-riak-index-field2_int: 1004" \
	-H "x-riak-index-field2_int: 1004" \
	-H "x-riak-index-field2_int: 1007" \
	http://127.0.0.1:8098/riak/mybucket/mykey4
