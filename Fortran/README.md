# Julia Calls Fortran

Since C is the mostly supported language, the best way to call Fortran from Julia/C
is `use iso_c_binding`.
The major differences are:
1. By default Fortran subroutines and functions has an underscore in the front
in the object files. `iso_c_binding` eliminates this behavior.
2. Fortran allocatable arrays has descriptors besides raw data, which prohibits
Julia from getting the right values. `c_loc` function from the package allows one to get the correct C pointer to the array.

Future Fortran libraries should always follow the `iso_c_binding` to allow seamless
interoperability with other languages.

## Compile Shared Libraries

```
$ gfortran simplemodule.f95 -o simplemodule.so -shared -fPIC
```

If there are multiple source codes, just compile each of them into object files and link them together.
If there are multiple shared libraries with internal dependencies, just do what you do for a single dynamic library, and remember to inform the non-standard library locations to the runtime.

For more information of shared library, please refer to [this blog](https://henry2004y.github.io/2020-04-04-shared-library/).

## Basic Usages

Note that Fortran is case insensitive: all the function and variable names are lowercases in the library calls.

Input a single precision value, returns doubled value:
```julia
r1 = ccall((:__simplemodule_MOD_foo, "./simplemodule.so"), Int32,
            (Ptr{Int32},), Int32[1])
# 2
```

Note that if you write `Int32(1)`, which is scalar, it will return error.
Quoted from the official document:
> when calling a Fortran function, all inputs must be passed as pointers to allocated values on the heap or stack. This applies not only to arrays and other mutable objects which are normally heap-allocated, but also to scalar values such as integers and floats which are normally stack-allocated and commonly passed in registers when using C or Julia calling conventions.

In general, a proper way to pass scalar arguments should be:
```julia
r1 = ccall((:__simplemodule_MOD_foo, "./simplemodule.so"), Int32,
            (Ptr{Int32},), Ref{Int32}(1))
# 2
```

Similar for double precision:
```julia
x2 = 7.0
a2 = Cdouble[1.0]
b2 = Cdouble[1.0]

ccall((:__simplemodule_MOD_keg, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), Ref{Float64}(x2), a2, b2)
# a2 = 10.; b2 = 21.
```

For double precision arrays:
```julia
x3 = [1.0, 2.0, 3.0]
y3 = [0.0, 0.0, 0.0]

ccall((:__simplemodule_MOD_ruf, "./simplemodule.so"), Cvoid,
      (Ref{Float64}, Ref{Float64}), x3, y3)
# y3 = [2.0, 4.0, 6.0]
```

Print out strings:
```julia
str1 = "foo"
str2 = "bar"
ccall((:__simplemodule_MOD_stringtest, "./simplemodule.so"), Cvoid,
      (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
      str1, str2, sizeof(str1), sizeof(str2))
# foo
# bar
```

Print out module parameter:
```julia
ccall((:__simplemodule_MOD_print_param, "./simplemodule.so"), Cvoid, ())
```

Get module global array and operate on the value:
```julia
y3 = Float32[0.0, 0.0]
z3 = Float32[0.0, 0.0]
r = cglobal((:__simplemodule_MOD_r, "./simplemodule.so"), Float32)
ccall((:__simplemodule_MOD_barreal, "./simplemodule.so"), Cvoid,
      (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), r, y3, z3)
# y3 = [4.0, 5.0]
# z3 = [3.0, 6.0]
```

Allocate a Fortran `allocatable` global array and access through Julia:
```julia
ccall((:__simplemodule_MOD_init_var, "./simplemodule.so"), Cvoid, ())

ps = ccall((:get_s, "simplemodule.so"), Ptr{Cfloat}, ())
s = unsafe_wrap(Vector{Cfloat}, ps, 10)
```

Note that you cannot correctly access `s` directly through `cglobal`. I don't know why. However, the pointer return by
```
s = cglobal((:__simplemodule_MOD_s, "./simplemodule.so"), Float32)
```
can be successfully recognized by Fortran:
```
ccall((:__simplemodule_MOD_print_var, "./simplemodule.so"), Cvoid,
      (Ptr{Float64},), s)
# Display an array of [1.0,2.0,...,10.0]
```

Finally, there is currently no direct way of accessing Fortran parameters. A workaround is to add some Fortran functions (e.g. `get_hparam`) to copy the value from the parameters to variables:
```
a = ccall((:get_hparam, "./simplemodule.so"), Cint, ())
```

This is about it. As you can see, things can go wrong pretty easily.

## Explicitly Import the Library

You can explicitly import the shared library by using `Libdl`:
```
using Libdl
str1 = "foo"
str2 = "bar"
lib = Libdl.dlopen("./simplemodule.so")
sym = Libdl.dlsym(lib, :__simplemodule_MOD_stringtest)
ccall(sym, Cvoid,
      (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
      str1, str2, sizeof(str1), sizeof(str2))
Libdl.dlclose(lib)
```

## MPI Support

The shared libraries can contain MPI support.

One minimal example can be found in [ex3](ex3):
```
$ mpiexec -n 3 julia ex3/juliaCallsFortran.jl
```

Sometimes a not well-written dynamic library may contain only part of the MPI calls. For example, `MPI_Init()` may occur in the orginal main file of C/Fortran code and is excluded in the dynamic library. In these cases, you can use the `MPI.jl` package in Julia:
```julia
using MPI
MPI.Init()
ccall((:__batl_tree_MOD_test_tree, "./libBATL.so"), Cvoid,())
MPI.Finalize()
```

Julia's MPI wrapper over the C library can work together with C/Fortran MPI calls, which is truly amazing.

## Difference between `Ptr` and `Ref`

Note that for the code to work correctly, `result_array` must be declared to be
of type `Ref{Cdouble}` and not `Ptr{Cdouble}`. The memory is managed by Julia and
the `Ref` signature alerts Julia’s garbage collector to keep managing the memory
for `result_array` while the `ccall` executes. If `Ptr{Cdouble}` were used instead,
the `ccall` may still work, but Julia’s garbage collector would not be aware
that the memory declared for `result_array` is being used by the external C
function. As a result, the code may produce a memory leak if `result_array`
never gets freed by the garbage collector, or if the garbage collector
prematurely frees `result_array`, the C function may end up throwing an invalid
memory access exception.

## Author

* **Hongyang Zhou** [henry2004y](https://github.com/henry2004y)
