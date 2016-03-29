!*****************************************************************************************
!>
!  Just an example using the lambert module.
!
!  ```gfortran test.f90 ../../lib/libfat.a -I../../mod -O3 -o test```

    program lambert_test_1

    use fortran_astrodynamics_toolkit

    implicit none

    real(wp),dimension(3)               :: r1         !! first cartesian position [km]
    real(wp),dimension(3)               :: r2         !! second cartesian position [km]
    real(wp)                            :: tof        !! time of flight [sec]
    real(wp)                            :: mu         !! gravity parameter [km^3/s^2]
    logical                             :: long_way   !! when true, do "long way" (>pi) transfers
    integer                             :: multi_revs !! maximum number of multi-rev solutions to compute
    real(wp),dimension(:,:),allocatable :: v1         !! vector containing 3d arrays with the cartesian components of the velocities at r1
    real(wp),dimension(:,:),allocatable :: v2         !! vector containing 3d arrays with the cartesian components of the velocities at r2
    logical                             :: status_ok  !! true if everything is OK
    integer                             :: i          !! counter

    r1 = [20.0d3, 20.0d3, zero]
    r2 = [-20.0d3, 10.0d3, zero]
    tof = 1.0d0 * day2sec
    mu = 398600.0_wp

    long_way=.true.
    multi_revs = 1
    call solve_lambert_gooding(r1,r2,tof,mu,long_way,multi_revs,v1,v2,status_ok)
    if (.not. status_ok) write(*,*) 'error'
    write(*,*) size(v1,2), 'long way solutions'
    call propagate_trajectory('longway_n=0_s=1.txt',     [r1,v1(:,1)])
    call propagate_trajectory('longway_n=1_s=1.txt',     [r1,v1(:,2)])
    call propagate_trajectory('longway_n=1_s=2.txt',     [r1,v1(:,3)])

    long_way=.false.
    multi_revs = 1
    call solve_lambert_gooding(r1,r2,tof,mu,long_way,multi_revs,v1,v2,status_ok)
    if (.not. status_ok) write(*,*) 'error'
    write(*,*) size(v1,2), 'short way solutions'
    call propagate_trajectory('shortway_n=0_s=1.txt',     [r1,v1(:,1)])
    call propagate_trajectory('shortway_n=1_s=1.txt',     [r1,v1(:,2)])
    call propagate_trajectory('shortway_n=1_s=2.txt',     [r1,v1(:,3)])

    contains
!*****************************************************************************************

        subroutine propagate_trajectory(name,rv0)

        implicit none

        character(len=*),intent(in) :: name

        real(wp),dimension(6),intent(in) :: rv0
        real(wp),dimension(6) :: rv,rvf
        integer :: iunit

        open(newunit=iunit,file=trim(name),status='REPLACE')

        !propagate it:
        rv = rv0
        write(iunit,'(*(E30.16,1X,A))') rv(1),',',rv(2),',',rv(3)
        do i=1,int(day2sec)
            call propagate(mu, rv, one, rvf)
            rv = rvf
            write(iunit,'(*(E30.16,1X,A))') rv(1),',',rv(2),',',rv(3)
        end do

        close(iunit)

        end subroutine propagate_trajectory

    end program lambert_test_1
!*****************************************************************************************
