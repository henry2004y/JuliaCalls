ccall((:foo,"libfoo.so"),Cvoid,())
# Hello, I am a shared library

ccall((:foo2,"libfoo.so"),Cvoid,())
# Hello, I am a foo2
