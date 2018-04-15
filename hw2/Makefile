%: %.ml
	ocamlc -o $@ $^

test:
	echo -e '#use "hw2.ml";;\n#use "hw2test.ml";;' | ocaml

sample: hw2.mli hw2.ml hw2sample.ml
	ocamlopt -o $@ $^

sampleProfile: hw2.mli hw2.ml hw2sample.ml
	ocamlopt -p -o $@ $^

clean:
	rm -f *.cmi *.cmo *.cmx *.o *.out hw2 hw2test sample sampleProfile

.PHONY: clean test
