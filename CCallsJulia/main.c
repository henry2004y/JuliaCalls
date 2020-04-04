#include <julia.h>

JULIA_DEFINE_FAST_TLS() // only define this once, in an executable (not in a shared library) if you want fast code.

#include <stdio.h>

int main(int argc, char *argv[])
{
  /* required: setup the Julia context */
  jl_init();

  /* create a 1D array of length 100 */
  double length = 100;
  double *existingArray = (double*)malloc(sizeof(double)*length);

  /* create a *thin wrapper* around our C array */
  jl_value_t* array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);
  jl_array_t *x = jl_ptr_to_array_1d(array_type, existingArray, length, 0);
  JL_GC_PUSH1(&x);
  /* fill in values */
  double *xData = (double*)jl_array_data(x);
  for (int i = 0; i < length; i++)
    xData[i] = i * i;

  /* import `Hello` module from file Hello.jl */
  jl_eval_string("Base.include(Main, \"Hello.jl\")");
  jl_eval_string("using Main.Hello");
  jl_module_t* Hello = (jl_module_t *)jl_eval_string("Main.Hello");

  /* get `foo!` function */
  jl_function_t *foo = jl_get_function(Hello, "foo!");

  /* call the function */
  jl_call1(foo, (jl_value_t*)x);

  /* print new values of x */
  for (int i = 0; i < length; i++)
    printf("%.1f ", xData[i]);

  printf("\n");
  JL_GC_POP();

  getchar();

  /* exit */
  jl_atexit_hook(0);
  return 0;
}
