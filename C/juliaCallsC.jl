x = collect(Cint, 1:5)
#println(x)
#aM = ccall((:vectorMean, "myC.so"), Float64,
#           (Ptr{Cint},Cint), x, 5)
#println("Mean = ", aM)

x = ccall((:mean,"libmean.so"),Float64,(Float64,Float64),2.0,5.0)

ccall((:bilin_reg,"libtrace.so"),Float64, (Float64, Float64, Float64, Float64, Float64, Float64), 0.5,0.5,0.0,0.0,0.0,0.0)

ccall((:DoBreak,"libtrace.so"),Int32, (Int32,Int32,Int32,Int32), 1,2,3,4)



#=
For this to work,
Julia must be running either on the same path where libmean.so resides, or
the path to libmean.so is in LD_LIBRARY_PATH.
=#

#=
import Base: unsafe_convert

unsafe_convert(::Type{Ptr{Float64}}, q::Quaternions.Quaternion{Float64}) =
    convert(Ptr{Float32}, Ptr{Float32}(pointer_from_objref([imag(q), real(q)])))

x = ccall((:mean_,"libmean.so"),Cdouble,(Ptr{Cdouble},Ptr{Cdouble}),2.0,5.0)
=#

#=
Note that unlike C, all Fortran arguments must be passed by reference, hence
the use of Ptr{} on all the arguments. The tricky part was again linking the
datatypes, but this really just means tracing the required Julia type which can
be found here. The Fortran integer type meshes well with Cint, and the Fortran
real type associates with Julia’s Cfloat.
=#

# Calling Fortran
#a, b = 2.0, 5.0;
#c = ccall((:__simple_MOD_mean, "./simple.so"), Float64, (Ptr{Float64},Ptr{Float64}), a,b)
