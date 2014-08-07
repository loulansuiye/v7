CFLAGS = -W -Wall -pedantic -ansi -Wno-comment -g -O0 $(PROF) $(CFLAGS_EXTRA)
SLRE = ../slre
CFLAGS += -I$(SLRE) -I.

SOURCES = v7.c $(SLRE)/slre.c

all: v7

v: unit_test
	valgrind -q --leak-check=full ./unit_test
#	valgrind -q --leak-check=full ./v7 tests/run_tests.js
#	gcov -a unit_test.c

$(SLRE)/slre.c:
	cd .. && git clone https://github.com/cesanta/slre

unit_test: $(SOURCES) v7.h tests/unit_test.c
	g++ $(SOURCES) tests/unit_test.c -o $@ $(CFLAGS)

u:
	$(CC) $(SOURCES) tests/unit_test.c -o $@ -Weverything -Werror $(CFLAGS)
	./$@

v7: $(SOURCES) v7.h
	$(CC) $(SOURCES) -o $@ -DV7_EXE $(CFLAGS)

js: v7
	@./v7 tests/unit_test.js
	@rhino -version 130 tests/unit_test.js

t: v7
	./v7 tests/run_tests.js

w:
	wine cl unit_test.c $(SOURCES) /I$(SLRE) && wine unit_test.exe

clean:
	rm -rf *.gc* *.dSYM *.exe *.obj a.out u unit_test v7