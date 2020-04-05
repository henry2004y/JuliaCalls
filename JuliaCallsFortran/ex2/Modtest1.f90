module test1

use iso_c_binding

implicit none

integer, parameter:: hparam = 10
integer :: h1 = 1
real :: r(2) = [1.0,2.0]
real, target, allocatable :: s(:)

contains

subroutine print_param()

  write(*,*) hparam

end subroutine print_param

end module test1
