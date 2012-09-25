all: piqi nonnative native test
	echo "Build complete"

nonnative:
	ocamlfind ocamlc -package piqi.runtime -c riak_piqi.ml
	ocamlfind ocamlc -package piqi.runtime -c riak_kv_piqi.ml
	ocamlfind ocamlc -package piqi.runtime -c riak_search_piqi.ml
	ocamlfind ocamlc -package Unix -package piqi.runtime riak_piqi.cmo riak_kv_piqi.cmo riak_search_piqi.cmo -c riak.mli
	ocamlfind ocamlc -package Unix -package piqi.runtime riak_piqi.cmo riak_kv_piqi.cmo riak_search_piqi.cmo -c riak.ml

native:
	ocamlfind ocamlopt -package piqi.runtime -c riak_piqi.ml
	ocamlfind ocamlopt -package piqi.runtime -c riak_kv_piqi.ml
	ocamlfind ocamlopt -package piqi.runtime -c riak_search_piqi.ml
	ocamlfind ocamlopt -package Unix -package piqi.runtime Riak_piqi.cmx Riak_kv_piqi.cmx riak_search_piqi.cmx -c Riak.mli
	ocamlfind ocamlopt -package Unix -package piqi.runtime Riak_piqi.cmx Riak_kv_piqi.cmx riak_search_piqi.cmx -c Riak.ml

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
		-linkpkg riak_piqi.cmo riak_kv_piqi.cmo riak_search_piqi.cmo riak.cmo Test.ml

install:
	ocamlfind install riak META riak.cmi riak.cmo riak.mli riak_piqi.cmo riak_kv_piqi.cmo riak_search_piqi.cmo \
		riak.cmx riak_kv_piqi.cmx riak_piqi.cmx riak_search_piqi.cmx

clean:
	rm -f *.cmo
	rm -f *.cmi
	rm -f *.proto.piqi
	rm -f riak_kv_piqi.ml
	rm -f riak_piqi.ml
	rm -f riak_search_piqi.ml
