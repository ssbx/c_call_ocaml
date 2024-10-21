OCAML_LIBS = $(shell ocamlopt -where)

.PHONY: default
default: run


.PHONY: run
run: exemple
	./exemple

.PHONY: clean
clean:
	rm -f mymod_opt.o mymod_wrapper.o libmymod.a mymod.cmi \
		mymod.cmx mymod.cmo mymod.o exemple

mymod_opt.o: mymod.ml
	ocamlopt -output-obj -o mymod_opt.o mymod.ml

mymod_wrapper.o: mymod_wrapper.c
	cc -c mymod_wrapper.c

libmymod.a: mymod_wrapper.o mymod_opt.o
	cp $(OCAML_LIBS)/libasmrun.a libmymod.a
	chmod +w libmymod.a
	ar r libmymod.a mymod_opt.o mymod_wrapper.o

exemple: exemple.c libmymod.a
	cc -o exemple -I $(OCAML_LIBS) exemple.c libmymod.a -ldl -lm -lpthread
