ARRAY = 21 23 93 71 17 72 77 5 81 74 22 49 84 62 87 10 89 7 31 48 40 44 43 14 20 59 96 1 98 41 46 25 38 67 56 95 64 83 94 42 64 35 13 56 15 37 24 28 57 51 92 82 88 29 6 33 63 26 19 27 8 73 55 67 91 85 2 50 3 54 69 9 18 80 34 78 47 83 66 95 30 79 12 97 100 45 4 16 61 52 75 76 11 32 99 65 58 36 70 38
THREADS = 2 4 6 8
ITERATIONS = 100000 1000000 10000000
PROG = java -cp code UnsafeMemory
IMPLEMENTATIONS = Null Synchronized GetNSet BetterSafe

compile:
	javac -Xlint:all code/*.java

jmmplus.jar: code/*
	jar cf $@ -C code .

test:
	@$(foreach thread, $(THREADS), \
		$(foreach iteration, $(ITERATIONS), \
			$(foreach implementation, $(IMPLEMENTATIONS), \
				printf "%13s %3s %9s: " "$(implementation)" "$(thread)" "$(iteration)"; \
				$(PROG) $(implementation) $(thread) $(iteration) 100 $(ARRAY);)))

clean:
	find . -name '*.class' -delete

.PHONY: compile clean test
