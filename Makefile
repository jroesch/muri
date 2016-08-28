LEAN=~/Git/lean/bin/lean

all: target/libfs.so
	$(LEAN) src/muri.lean

target/lib%.so : extern/%.cpp
	mkdir -p target
	g++ -fPIC -std=c++11 -shared -o $@ \
		-I/Users/jroesch/Git/lean/src $< \
		-L/Users/jroesch/Git/lean/build/debug -g \
		-l gmp -l pthread -l mpfr -lleanshared

clean:
	rm -rf target/*
