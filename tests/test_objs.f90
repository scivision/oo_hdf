program test_h5_funcs
  use H5_OO_mod
  implicit none

  type(H5File) :: f1
  type(H5Dataset) :: d1, d2
  type(H5Group) :: g1


  integer :: read_a(19)

  integer :: test_arr(4,3)
  integer :: i, j
  real(DP) :: r8_dset(4)


  f1=H5File("new_test_file.h5", "N", "W")

  call f1%setAttribute('thgttg',42)

  d1=H5Dataset('2d_i32',f1)

  call d1%setFillValue(-1)

  print*,'file ID',f1%id

  call f1%setGroup('newgroup',g1)

  d2=H5Dataset('4d_r64',g1)
!  call d1%showstatus()

  do concurrent (i=1:size(test_arr(:,1)))
    do concurrent (j=1:size(test_arr(1,:)))
      test_arr(i,j)=i*j
    end do
  end do

  call d1%setDataset(int(test_arr,1))

  call d1%setAttribute('thgttg',int(42,2))

  call d2%setDataset(real([[1],[2],[4],[5]],DP))
  stop
  call d1%setAttribute('att1', int([4,4,2,5,4,6,3,1,1,5,5,2,4,2154545,6,2,4,7,6],4))

  call f1%closeFile()


  f1=H5File("new_test_file.h5", "O", "R")

  call f1%getAttribute('thgttg',i)
  print*,i

  call f1%openGroup('newgroup',g1)

  d1=H5Dataset('2d_i32',f1)
  call d1%getAttribute('att1',read_a)
  print*,read_a

  d2=H5Dataset('4d_r64',g1)

  call d2%getDataset(r8_dset)

  print*,r8_dset

  call f1%closeFile()


end program test_h5_funcs
