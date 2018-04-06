%: %.ml
	ocamlc -o $@ $^

test:
	echo -e '#use "hw1.ml";;\n#use "hw1test.ml";;' | ocaml

sample:
	echo -e '#use "hw1.ml";;\n#use "hw1sample.ml";;' | ocaml

clean:
	rm -f *.cmi *.cmo hw1 hw1test hw1sample

.PHONY: clean test sample
