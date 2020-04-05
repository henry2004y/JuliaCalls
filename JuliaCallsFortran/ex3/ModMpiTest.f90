module MpiTest

  use mpi
  use omp_lib

  implicit none

  integer :: iBlock
  integer :: iIter

  integer :: iProc, tag, ierror, nProc, jProc
  integer, parameter :: required=MPI_THREAD_SERIALIZED
  integer :: provided ! Provided level of MPI threading support
  integer :: status(MPI_STATUS_SIZE)
  real    :: wtime0
  !----------------------------------------------------------------------------
contains
  subroutine test
    ! Initialize MPI
    !call MPI_Init(error)
    call MPI_Init_Thread(required, provided, ierror)

    ! Get the number of processes
    call MPI_Comm_size(MPI_COMM_WORLD, nProc, ierror)

    ! Get the individual process ID
    call MPI_Comm_rank(MPI_COMM_WORLD, iProc, ierror)

    ! Check the threading support level
    if (provided .lt. required) then
      ! Insufficient support, degrade to 1 thread and warn the user
      if (iProc .eq. 0) then
        write(*,*) "Warning:  This MPI implementation provides ",   &
        "insufficient threading support. Switching to pure MPI..."
      end if
      !$ call omp_set_num_threads(1)
    end if

    ! Print message from master worker
    if (iProc==0) then
      write(*,*) 'MPI test program'
      write(*,'(a,i8)') &
      'The number of processes used       = ',nProc
      !$ UseOpenMP = .true.
      !$ print *, "MPI+OpenMP hybrid program"
      !$ write ( *, '(a,i8)' ) &
      !$     'The number of processors available = ', omp_get_num_procs()
      !$ write ( *, '(a,i8)' ) &
      !$     'The number of threads available    = ', omp_get_max_threads()
      ! Set start time
      wtime0 = MPI_Wtime()
    end if

    call MPI_barrier(MPI_COMM_WORLD, ierror)
    if (iProc==0) then
      write(*,*) 'Total elapsed time on MPI   = ',MPI_Wtime() - wtime0
    end if

    do jProc = 0, nProc-1
      if(iProc == jProc)then
        !$acc update self(State_VGB)
        write(*,*) 'iProc = ',iProc
      end if
      call MPI_barrier(MPI_COMM_WORLD,ierror)
    end do

    ! Shut down MPI
    call MPI_Finalize(ierror)

    write(*,*) 'Test finished!'

  end subroutine test

end module MpiTest
