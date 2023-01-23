# Load the module and generate the functions
module CppHello
  using CxxWrap
  @wrapmodule(joinpath("build/lib","libtest"))

  function __init__()
    @initcxx
  end
end

# Call greet and show the result
@show CppHello.greet()
