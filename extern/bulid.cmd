g++ -fPIC -std=c++11 -shared -Wl,-soname,libput_int.so -o libput_int.so -I/home/jroesch/Git/lean/src put_int.cpp -L/home/jroesch/Git/lean/build/debug -l gmp -l pthread -l mpfr -lleanshared -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
