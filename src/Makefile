all:
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
	ocamlfind ocamlc -package piqi.runtime -c riak_piqi.ml
	ocamlfind ocamlc -package piqi.runtime -c riak_kv_piqi.ml
	ocamlfind ocamlc -package piqi.runtime -c riak_search_piqi.ml
	ocamlfind ocamlc -package Unix -package piqi.runtime Riak_piqi.cmo Riak_kv_piqi.cmo riak_search_piqi.cmo -c Riak.mli
	ocamlfind ocamlc -package Unix -package piqi.runtime Riak_piqi.cmo Riak_kv_piqi.cmo riak_search_piqi.cmo -c Riak.ml
	ocamlfind ocamlc -o RiakTests -package Unix -package oUnit -package piqi.runtime -linkpkg Riak_piqi.cmo Riak_kv_piqi.cmo riak_search_piqi.cmo Riak.cmo Test.ml

#install:
#	ocamlfind install Riak META Riak.cmi Riak.cmo Riak.mli 

clean:
	rm -f *.cmo
	rm -f *.cmi
	rm -f *.proto.piqi
	rm -f riak_kv_piqi.ml
	rm -f riak_piqi.ml
	rm -f riak_search_piqi.ml
