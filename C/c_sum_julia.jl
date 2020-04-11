C_code = """
#include <stddef.h>
double c_sum(size_t n, double *X) {
    double s = 0.0;
    for (size_t i = 0; i < n; ++i) {
        s += X[i];
    }
    return s;
}
"""
# compile to a shared library by piping C_code to gcc:
# (only works if you have gcc installed)
const Clib = tempname()
using Libdl
open(`gcc -fPIC -O3 -msse3 -xc -shared -o $(Clib * "." * Libdl.dlext) -`, "w") do f
    print(f, C_code)
end
c_sum(X::Array{Float64}) = ccall(("c_sum", Clib), Float64, (Csize_t, Ptr{Float64}), length(X), X)

# define a function to compute the relative (fractional) error |x-y| / mean(|x|,|y|)
relerr(x,y) = abs(x - y) * 2 / (abs(x) + abs(y))

a = rand(10^7) # array of random numbers in [0,1)
relerr(c_sum(a), sum(a))

using BenchmarkTools

c_bench = @btime c_sum($a)
