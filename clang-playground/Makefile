CLANG_FLAGS := \
	-lclangAST \
	-lclangASTMatchers \
	-lclangBasic \
	-lclangFrontend \
	-lclangTooling \
	-lLLVM

LIBCLANG_FLAGS := -lclang

all: ast-matcher lib-clang

ast-matcher: ast-matcher.cpp
	g++ -g $(CLANG_FLAGS) -o $@ $^

lib-clang: lib-clang.c
	gcc -g $(LIBCLANG_FLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f ast-matcher lib-clang
