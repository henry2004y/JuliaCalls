# Julia calls ctrac2d.c
# The output data is usually in single precision, but the tracer requires double
# precision.

#Test cEuler 1
nx = Int32(841)
ny = Int32(121)
maxstep = Int32(10000)

xgrid = Vector{Float64}(undef,nx)   # grid x
ygrid = Vector{Float64}(undef,nx)   # grid y
ux = Vector{Float64}(undef,nx*ny)   # field x
uy = Vector{Float64}(undef,nx*ny)   # field y
xt = Vector{Float64}(undef,maxstep) # output x
yt = Vector{Float64}(undef,maxstep) # output y
ds = 1.0

for i=1:nx
   xgrid[i] = -10.0+0.25*(i-1)
   ygrid[i] = xgrid[i]
end

for i=1:nx, j=1:ny
   ux[(i-1)*ny+j] = xgrid[i]
   uy[(i-1)*ny+j] = -1.0*ygrid[j]
end


npoints = ccall((:cEuler,"libtrace.so"),Cint,
   (Cint,Cint,Cint,Float64,Float64,Float64,Ptr{Cdouble},Ptr{Cdouble},
   Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble}),
   nx, ny, maxstep, ds, 1.0, 10.0, xgrid, ygrid, ux, uy, xt, yt)

println("Npoints = ", npoints)
println("Grid goes from ", round(xgrid[1],digits=2), " to ", round(xgrid[nx],digits=2))
println("Our trace starts at ", round(xt[1],digits=2), " ", round(yt[1],digits=2))
println("...and ends at ", round(xt[npoints+1],digits=2), " ",round(yt[npoints+1],digits=2))

npoints = ccall((:cRk4,"libtrace.so"),Cint,
   (Cint,Cint,Cint,Float64,Float64,Float64,Ptr{Cdouble},Ptr{Cdouble},
   Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble}),
   nx, ny, maxstep, ds, 1.0, 10.0, xgrid, ygrid, ux, uy, xt, yt)

println("Npoints = ", npoints)
println("Grid goes from ", round(xgrid[1],digits=2), " to ", round(xgrid[nx],digits=2))
println("Our trace starts at ", round(xt[1],digits=2), " ", round(yt[1],digits=2))
println("...and ends at ", round(xt[npoints+1],digits=2), " ",round(yt[npoints+1],digits=2))
