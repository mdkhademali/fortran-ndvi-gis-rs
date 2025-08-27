module ascii_grid
  implicit none
  private
  public :: read_ascii_grid, write_ascii_grid, grid_type

  type :: grid_type
    integer :: ncols
    integer :: nrows
    real(8) :: xllcorner
    real(8) :: yllcorner
    real(8) :: cellsize
    real(8) :: nodata
    real(8), allocatable :: data(:,:)
  end type grid_type

contains

  subroutine read_ascii_grid(filename, g, ierr)
    character(len=*), intent(in) :: filename
    type(grid_type), intent(out) :: g
    integer, intent(out) :: ierr
    character(len=256) :: line
    integer :: ios, i, j, header_lines
    real(8) :: tmp
    ierr = 0
    open(unit=10, file=filename, status='old', action='read', iostat=ios)
    if (ios /= 0) then
      ierr = 1
      return
    end if

    ! initialize
    g%ncols = 0
    g%nrows = 0
    g%xllcorner = 0.0d0
    g%yllcorner = 0.0d0
    g%cellsize = 0.0d0
    g%nodata = -9999.0d0

    ! read header (robustly)
    header_lines = 0
    do
      read(10,'(A)', iostat=ios) line
      if (ios /= 0) exit
      header_lines = header_lines + 1
      if (index(adjustl(line),'NCOLS') /= 0) then
        read(line,*) tmp
        read(line,*, pos=1) ! no-op to avoid format issues
        read(line(7:),*) g%ncols
      else if (index(adjustl(line),'NROWS') /= 0) then
        read(line(6:),*) g%nrows
      else if (index(adjustl(line),'XLLCORNER') /= 0) then
        read(line(10:),*) g%xllcorner
      else if (index(adjustl(line),'YLLCORNER') /= 0) then
        read(line(10:),*) g%yllcorner
      else if (index(adjustl(line),'CELLSIZE') /= 0) then
        read(line(8:),*) g%cellsize
      else if (index(adjustl(line),'NODATA_VALUE') /= 0) then
        read(line(12:),*) g%nodata
      else
        ! first data line reached; break and reposition file to start of data
        exit
      end if
    end do

    if (g%ncols <= 0 .or. g%nrows <= 0) then
      ierr = 2
      close(10)
      return
    end if

    allocate(g%data(g%nrows, g%ncols))

    ! rewind and skip header_lines to read data
    rewind(10)
    do i = 1, header_lines
      read(10,'(A)', iostat=ios) line
    end do

    do i = 1, g%nrows
      do j = 1, g%ncols
        read(10,*, iostat=ios) g%data(i,j)
        if (ios /= 0) then
          ierr = 3
          close(10)
          return
        end if
      end do
    end do

    close(10)
    ierr = 0
  end subroutine read_ascii_grid

  subroutine write_ascii_grid(filename, g, ierr)
    character(len=*), intent(in) :: filename
    type(grid_type), intent(in) :: g
    integer, intent(out) :: ierr
    integer :: i,j, ios
    open(unit=11, file=filename, status='replace', action='write', iostat=ios)
    if (ios /= 0) then
      ierr = 1
      return
    end if
    write(11,'(A,I0)') 'NCOLS ', g%ncols
    write(11,'(A,I0)') 'NROWS ', g%nrows
    write(11,'(A,F0.6)') 'XLLCORNER ', g%xllcorner
    write(11,'(A,F0.6)') 'YLLCORNER ', g%yllcorner
    write(11,'(A,F0.6)') 'CELLSIZE ', g%cellsize
    write(11,'(A,F0.6)') 'NODATA_VALUE ', g%nodata

    do i = 1, g%nrows
      do j = 1, g%ncols
        write(11,'(F12.6)', advance='no') g%data(i,j)
      end do
      write(11,*)
    end do

    close(11)
    ierr = 0
  end subroutine write_ascii_grid

end module ascii_grid
