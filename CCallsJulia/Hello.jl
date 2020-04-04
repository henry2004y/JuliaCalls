# Hello.jl
module Hello
export foo!

foo!(x) = (x .*= 2) # multiply entries of x by 2 inplace
