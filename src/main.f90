program compute_ndvi
  use ascii_grid
  implicit none
  type(grid_type) :: red, nir, out
  integer :: ierr
  character(len=256) :: red_file, nir_file, out_file
  integer :: i,j
  real(8) :: rval, nval, ndvi

  red_file = 'sample_data/red_band.asc'
  nir_file = 'sample_data/nir_band.asc'
  out_file = 'output/ndvi.asc'

  call read_ascii_grid(trim(red_file), red, ierr)
  if (ierr /= 0) then
    print *, 'Error reading red band, code=', ierr
    stop
  end if
  call read_ascii_grid(trim(nir_file), nir, ierr)
  if (ierr /= 0) then
    print *, 'Error reading nir band, code=', ierr
    stop
  end if

  ! check dims
  if (red%ncols /= nir%ncols .or. red%nrows /= nir%nrows) then
    print *, 'Input dimensions do not match.'
    stop
  end if

  out = red
  allocate(out%data(out%nrows, out%ncols))

  do i = 1, out%nrows
    do j = 1, out%ncols
      rval = red%data(i,j)
      nval = nir%data(i,j)
      if (rval == red%nodata .or. nval == nir%nodata) then
        out%data(i,j) = out%nodata
      else
        if (abs(nval + rval) < 1.0e-12) then
          out%data(i,j) = out%nodata
        else
          ndvi = (nval - rval) / (nval + rval)
          out%data(i,j) = ndvi
        end if
      end if
    end do
  end do

  call write_ascii_grid(trim(out_file), out, ierr)
  if (ierr /= 0) then
    print *, 'Error writing output, code=', ierr
    stop
  end if

  print *, 'NDVI written to: ', trim(out_file)
end program compute_ndvi
