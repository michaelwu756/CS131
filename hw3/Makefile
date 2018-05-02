compile:
	javac code/*

jmmplus.jar: code/*
	jar cf $@ -C code .

clean:
	find . -name '*.class' -delete

.PHONY: compile clean
