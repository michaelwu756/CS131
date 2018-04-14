%: %.ml
	ocamlc -o $@ $^

test:
	echo -e '#use "hw2.ml";;\n#use "hw2test.ml";;' | ocaml

sample:
	echo -e '#use "hw2.ml";;\n#use "hw2sample.ml";;' | ocaml

clean:
	rm -f *.cmi *.cmo hw2 hw2test hw2sample

.PHONY: clean test sample
