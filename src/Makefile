all: piqi nonnative test
	@echo "Build complete"

nonnative:
	ocamlfind ocamlc -a -package piqi.runtime riak_piqi.ml -o riak_piqi.cma
	ocamlfind ocamlc -a -package piqi.runtime riak_kv_piqi.ml -o riak_kv_piqi.cma
	ocamlfind ocamlc -a -package piqi.runtime riak_search_piqi.ml -o riak_search_piqi.cma
	ocamlfind ocamlc -c -package Unix -package piqi.runtime riak_piqi.cma riak_kv_piqi.cma riak_search_piqi.cma Riak.mli -o Riak.cmi
	ocamlfind ocamlc -a -package Unix -package piqi.runtime riak_piqi.cma riak_kv_piqi.cma riak_search_piqi.cma Riak.ml -o Riak.cma

native:
	ocamlfind ocamlopt -package piqi.runtime -c riak_piqi.ml
	ocamlfind ocamlopt -package piqi.runtime -c riak_kv_piqi.ml
	ocamlfind ocamlopt -package piqi.runtime -c riak_search_piqi.ml
	ocamlfind ocamlopt -package Unix -package piqi.runtime riak_piqi.cmx riak_kv_piqi.cmx riak_search_piqi.cmx -c riak.mli
	ocamlfind ocamlopt -package Unix -package piqi.runtime riak_piqi.cmx riak_kv_piqi.cmx riak_search_piqi.cmx -c riak.ml

piqi:
	piqi of-proto riak.proto
	piqi of-proto riak_kv.proto
	piqi of-proto riak_search.proto
	cat riak.piqi.additions >> riak.proto.piqi
	# rename done to isdone. "done" is a keyword in OCaml
	# Note: the author of Piqi explained a different way to do this that I need
	# to apply
	# https://gist.github.com/3195858
	sed -i.orig -e"s/\.name done/\.name isdone \.proto-name \"done\""/ riak_kv.proto.piqi
	piqic ocaml --pp riak.proto.piqi
	piqic ocaml --pp riak_kv.proto.piqi
	piqic ocaml --pp riak_search.proto.piqi

test:
	ocamlfind ocamlc -o RiakTests -package Unix -package oUnit -package piqi.runtime \
		-linkpkg riak_piqi.cma riak_kv_piqi.cma riak_search_piqi.cma Riak.cma Test.ml
	@echo "You should now have a RiakTests executable in the src directory."
	@echo "To run the tests, export the following 2 variables to a running instance of Riak:"
	@echo "RIAK_OCAML_TEST_IP"
	@echo "RIAK_OCAML_TEST_PORT"
	@echo "Then run the RiakTest program"
install:
	ocamlfind install riak META Riak.cmi Riak.cma Riak.mli riak_piqi.cma riak_kv_piqi.cma riak_search_piqi.cma

install-test:
	ocamlfind ocamlc -o RiakTests -package Unix -package oUnit -package piqi.runtime -package riak -linkpkg Test.ml


clean:
	rm -f *.cmo
	rm -f *.cma
	rm -f *.cmi
	rm -f *.cmx
	rm -f *.o
	rm -f *.proto.piqi
	rm -f riak_kv_piqi.ml
	rm -f riak_piqi.ml
	rm -f riak_search_piqi.ml
