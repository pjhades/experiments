FLAGS := \
	-lclangAST \
	-lclangASTMatchers \
	-lclangBasic \
	-lclangFrontend \
	-lclangTooling \
	-lLLVM

x: x.cpp
	g++ -g $(FLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f x
