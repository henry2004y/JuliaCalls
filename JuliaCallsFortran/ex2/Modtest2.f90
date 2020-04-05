module test2

!use iso_c_binding

implicit none


contains

  subroutine print_test()

    write(*,*) "hello_world!"

  end subroutine print_test

end module test2
