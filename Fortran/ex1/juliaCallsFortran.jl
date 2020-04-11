x1 = 7
a1 = Int32[0]
b1 = Int32[0]

# This is invalid, because of type mismatch
#r1 = ccall((:__simplemodule_MOD_foo, "./simplemodule.so"), Int32,
#            (Ptr{Int32},), x1)

# This is valid!
r1 = ccall((:__simplemodule_MOD_foo, "./simplemodule.so"), Int32,
            (Ptr{Int32},), Int32[1])

println(r1)
println()

r1 = ccall((:__simplemodule_MOD_factorial, "./simplemodule.so"), Float32,
            (Ptr{Int32},), Int32[1])

x1 = Int32(7)

ccall((:__simplemodule_MOD_bar, "./simplemodule.so"), Cvoid,
      (Ptr{Int32}, Ptr{Int32}, Ptr{Int32}), Ref{Int32}(x1), a1, b1)

println(a1[1])
println(b1[1])
println()

x2 = 7.0
a2 = Cdouble[1.0]
b2 = Cdouble[1.0]

ccall((:__simplemodule_MOD_keg, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), Ref{Float64}(x2), a2, b2)

println(a2[1])
println(b2[1])
println()

x3 = [1.0, 2.0, 3.0]
y3 = [0.0, 0.0, 0.0]
ccall((:__simplemodule_MOD_ruf, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}), x3, y3)
# Seems to be the same as above
ccall((:__simplemodule_MOD_ruf, "./simplemodule.so"), Cvoid,
      (Ref{Float64}, Ref{Float64}), x3, y3)

println(y3)

str1 = "foo"
str2 = "bar"
ccall((:__simplemodule_MOD_stringtest, "./simplemodule.so"), Cvoid,
      (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
      str1, str2, sizeof(str1), sizeof(str2))

ccall((:__simplemodule_MOD_print_param, "./simplemodule.so"), Cvoid, ())

x3 = Float32[1.0, 2.0]
y3 = Float32[0.0, 0.0]
z3 = Float32[0.0, 0.0]
ccall((:__simplemodule_MOD_barreal, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), x3, y3, z3)

r = cglobal((:__simplemodule_MOD_r, "./simplemodule.so"), Float32)
ccall((:__simplemodule_MOD_barreal, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), r, y3, z3)

# allocate and visit array
ccall((:__simplemodule_MOD_init_var, "./simplemodule.so"), Cvoid, ())
s = cglobal((:__simplemodule_MOD_s, "./simplemodule.so"), Float32)
s_julia = zeros(Float32,10)
s_ref = Ref{Float32}

# use c_loc to get a C pointer to the data
ps = ccall((:get_s, "simplemodule.so"), Ptr{Cfloat}, ())
s = unsafe_wrap(Vector{Cfloat}, ps, 10)


ccall((:__simplemodule_MOD_print_s, "./simplemodule.so"), Cvoid, ())
# The allocated array pointer can be successfully recognized by Fortran,
# but it cannot be correctly identified by Julia?
ccall((:__simplemodule_MOD_print_var, "./simplemodule.so"), Cvoid,
      (Ptr{Float64},), s)
ccall((:__simplemodule_MOD_double_var, "./simplemodule.so"), Cvoid,
      (Ptr{Float64},), s)
b = unsafe_wrap(Array{Float32,1}, s, 10) # This is not working!

# Explicitly import the library
using Libdl
str1 = "foo"
str2 = "bar"
lib = Libdl.dlopen("./simplemodule.so")
sym = Libdl.dlsym(lib, :__simplemodule_MOD_stringtest)
ccall(sym, Cvoid,
      (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
      str1, str2, sizeof(str1), sizeof(str2))
Libdl.dlclose(lib)

# Import global variables
a = cglobal((:errno, :libc), Int32)
b = unsafe_load(a)

# import constant integer error?
a = cglobal((:__simplemodule_MOD_hparam, "./simplemodule.so"), Int32)
a = cglobal((:_hparam, "./simplemodule.so"), Int32)

# This is not working
a = cglobal((:__simplemodule_MOD_get_hparam2, "./simplemodule.so"), Int32)
# This works!
a = ccall((:get_hparam, "./simplemodule.so"), Cint, ())

# import integer
a = cglobal((:__simplemodule_MOD_h1, "./simplemodule.so"), Int32)
b = unsafe_load(a)

# import integer array
a = cglobal((:__simplemodule_MOD_r, "./simplemodule.so"), Float32)
# method 1
b = [unsafe_load(a,i) for i in 1:2]
# method 2
b = unsafe_wrap(Array{Float32,1}, a, 2)

unsafe_store!(a, 4, 1)


s = cglobal((:__simplemodule_MOD_s, "./simplemodule.so"), Float32)

# Error code!
I = zeros(Int32,1,1)
n = Ref{Int32}(3)
ccall((:__simplemodule_MOD_getidentity,"./simplemodule.so"), Cvoid ,
      (Ref{Int32},Ref{Int32}), n,I)
println(I)

# Now I know how to modify Julia array with Fortran functions

# How to get global parameter values?

# How to modify global variables?
