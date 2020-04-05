module simpleModule

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

function get_hparam2()
  integer :: get_hparam2

  get_hparam2 = hparam

end function get_hparam2

function get_hparam() bind(c)
  integer(C_INT) :: get_hparam

  get_hparam = int(hparam, C_INT)
end function get_hparam

function foo(x)
  integer :: foo, x
  foo = x * 2
end function foo

subroutine bar(x, a, b)
  integer, intent(in) :: x
  integer, intent(out) :: a, b

  a = x + 3
  b = x * 3
end subroutine bar

subroutine init_var
  integer :: i

  if(.not.allocated(s)) then
    allocate(s(10))
  else
    write(*,*) 's has already been allocated!'
  endif

  do i=1,10
    s(i) = i
  enddo

  write(*,*) s

end subroutine init_var

function get_s() bind(c)
  type(c_ptr) :: get_s

  get_s = c_loc(s)
end function get_s

subroutine print_s

  write(*,*) s

end subroutine print_s

subroutine print_var(x)
  real, intent(in):: x(:)

  write(*,*) x

end subroutine print_var

subroutine double_var(x)
  real, intent(inout):: x(:)

  x = x * 2
  write(*,*) x

end subroutine double_var

subroutine barreal(x, a, b)
  real, intent(in) :: x(2)
  real, intent(out) :: a(2), b(2)

  a = x + 3
  b = x * 3
end subroutine barreal

subroutine keg(x, a, b)
  real*8, intent(in) :: x
  real*8, intent(out) :: a, b

  a = x + 3.0
  b = x * 3.0
end subroutine keg

subroutine ruf(x, y)
  real*8, dimension(3), intent(in) :: x
  real*8, dimension(3), intent(out) :: y
  integer :: i

  DO i = 1, 3
    y(i) = 2*x(i)
  END DO
end subroutine ruf

subroutine stringtest(str1, str2)
  character(len=*) :: str1, str2
  write(*,*) str1
  write(*,*) str2
end subroutine stringtest

subroutine getIdentity(n,I)
    integer, intent(in) :: n
    integer, allocatable,dimension(:,:), intent(out) :: I
    integer :: j,k

    write(*,*) "creating " ,n, "x", n, "identity matrix"

    allocate(I(n,n))

    do j=1,n
        do k=1,n
        if(k==j) then
            I(j,k) = 1
        else
            I(j,k) = 0
        end if
    end do
    end do
end subroutine getIdentity

end module simplemodule
