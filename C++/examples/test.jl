# Load the module and generate the functions
module CppHello
  using CxxWrap
  @wrapmodule(joinpath("build/lib","libtest"))

  function __init__()
    @initcxx
  end
end

using Test
using CxxWrap: CxxPtr, isnull

# Call greet and show the result
@show CppHello.greet()

# Call struct
w = CppHello.World()
@show @test CppHello.greet(w) == "default hello"
CppHello.set(w, "hello")
@test CppHello.greet(w) == "hello"

# Pointers
d = CppHello.MyData()
CppHello.setvalue!(d, 10)

a = CppHello.MyData(9)
@test CppHello.value(a) == 9

nd = Ref(CxxPtr{CppHello.MyData}(C_NULL))
@test isnull(nd[])
CppHello.writepointerref!(nd)
@test !isnull(nd[])
@test CppHello.value(nd[][]) == 30
CppHello.setvalue!(nd[][], 40)
@test CppHello.value(nd[][]) == 40
CppHello.delete(nd[]) # This is needed, since Ptrs are not handled by GC in Julia!

# Arrays
ta = [1.,2.]
CppHello.test_array_set(ta, 0, 3.)