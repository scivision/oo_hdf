!#################################################################################################!
!BSD 3-Clause License
!
!Copyright (c) 2017, Ricardo Torres
!All rights reserved.
!
!Redistribution and use in source and binary forms, with or without
!modification, are permitted provided that the following conditions are met:
!
!* Redistributions of source code must retain the above copyright notice, this
!  list of conditions and the following disclaimer.

!* Redistributions in binary form must reproduce the above copyright notice,
!  this list of conditions and the following disclaimer in the documentation
!  and/or other materials provided with the distribution.

!* Neither the name of the copyright holder nor the names of its
!  contributors may be used to endorse or promote products derived from
!  this software without specific prior written permission.
!
!THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
!AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
!IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
!DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
!FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
!DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
!SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
!CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
!OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
!OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!#################################################################################################!

module H5_Func_mod
  use hdf5
  use h5ds
  use h5d
  use Types_mod
  use Strings_Func_mod, only: To_upper
  implicit none
  integer, private, parameter :: LEN_STR_ATTR  = 80

  interface Read_Att
    module procedure Read_Char_Attr0
    module procedure Read_Char_Attr1
    module procedure Read_Int_Attr0
    module procedure Read_Int_Attr1
    module procedure Read_Real32_Attr0
    module procedure Read_Real32_Attr1
    module procedure Read_Real64_Attr0
    module procedure Read_Real64_Attr1
  end interface Read_Att

  interface Create_Attr
    module procedure Create_Int16_Attr0
    module procedure Create_Int16_Attr1
    module procedure Create_Int32_Attr0
    module procedure Create_Int32_Attr1
    module procedure Create_Real32_Attr0
    module procedure Create_Real32_Attr1
    module procedure Create_Real64_Attr0
    module procedure Create_Real64_Attr1
    module procedure Create_Char_Attr0
    module procedure Create_Char_Attr1
  end interface Create_Attr

  interface Read_Dset
     module procedure Read_Int_0d_dataset
     module procedure Read_Int_1d_dataset
     module procedure Read_Int_2d_dataset
     module procedure Read_Int_3d_dataset
     module procedure Read_Int_4d_dataset
     module procedure Read_Int_5d_dataset
     module procedure Read_Int_6d_dataset
     module procedure Read_Real32_0d_dataset
     module procedure Read_Real32_1d_dataset
     module procedure Read_Real32_2d_dataset
     module procedure Read_Real32_3d_dataset
     module procedure Read_Real32_4d_dataset
     module procedure Read_Real32_5d_dataset
     module procedure Read_Real32_6d_dataset
     module procedure Read_Real64_0d_dataset
     module procedure Read_Real64_1d_dataset
     module procedure Read_Real64_2d_dataset
     module procedure Read_Real64_3d_dataset
     module procedure Read_Real64_4d_dataset
     module procedure Read_Real64_5d_dataset
     module procedure Read_Real64_6d_dataset
  end interface Read_Dset

  interface Create_Dset
    module procedure Create_Int8_1d_Dataset
    module procedure Create_Int16_1d_Dataset
    module procedure Create_Int32_1d_Dataset
    module procedure Create_Real32_1d_Dataset
    module procedure Create_Real64_1d_Dataset
    module procedure Create_Int8_2d_Dataset
    module procedure Create_Int16_2d_Dataset
    module procedure Create_Int32_2d_Dataset
    module procedure Create_Real32_2d_Dataset
    module procedure Create_Real64_2d_Dataset
    module procedure Create_Int8_3d_Dataset
    module procedure Create_Int16_3d_Dataset
    module procedure Create_Int32_3d_Dataset
    module procedure Create_Real32_3d_Dataset
    module procedure Create_Real64_3d_Dataset
    module procedure Create_Int8_4d_Dataset
    module procedure Create_Int16_4d_Dataset
    module procedure Create_Int32_4d_Dataset
    module procedure Create_Real32_4d_Dataset
    module procedure Create_Real64_4d_Dataset
    module procedure Create_Int8_5d_Dataset
    module procedure Create_Int16_5d_Dataset
    module procedure Create_Int32_5d_Dataset
    module procedure Create_Real32_5d_Dataset
    module procedure Create_Real64_5d_Dataset
    module procedure Create_Int8_6d_Dataset
    module procedure Create_Int16_6d_Dataset
    module procedure Create_Int32_6d_Dataset
    module procedure Create_Real32_6d_Dataset
    module procedure Create_Real64_6d_Dataset
  end interface Create_Dset

  interface Read_Slab
    module procedure Read_Int_1dSlab
    module procedure Read_Int_2dSlab
    module procedure Read_Int_3dSlab
    module procedure Read_Int_4dSlab
    module procedure Read_Int_5dSlab
    module procedure Read_Real_1dSlab
    module procedure Read_Real_2dSlab
    module procedure Read_Real_3dSlab
    module procedure Read_Real_4dSlab
    module procedure Read_Real_5dSlab
  end interface Read_Slab

  contains
!#################################################################################################!
  function hdf_open_file(filename, state, mode) result(file_id)
    integer(HID_T) :: file_id            !< HDF5 id of the file
    character(len=*), intent(in) :: filename        !< the HDF5 filename
    character(len=*), optional, intent(in) :: state !< file state (OLD, NEW, REPLACE)
    character(len=*), optional, intent(in) :: mode  !< file mode (READ, WRITE, READWRITE)
    integer :: hdferr
    character(len=16) :: state2, mode2

    ! open hdf5 interface
    call h5open_f(hdferr)

    ! set defaults
    state2 = 'NEW'
    if (present(state)) state2 = To_upper(state)
    mode2 = 'READWRITE'
    if (present(mode)) mode2 = To_upper(mode)

    ! open/create hdf5 file
    if (state2 == 'OLD' .or. state2 == 'O') then
      if (mode2 == 'READ' .or. mode2 == 'R') then
        call h5fopen_f(filename, H5F_ACC_RDONLY_F, file_id, hdferr)
      elseif ( (mode2 == 'WRITE') .or. (mode2 == 'W') .or. &
           (mode2 == 'READWRITE') .or. (mode2 == 'RW') ) then
        call h5fopen_f(filename, H5F_ACC_RDWR_F, file_id, hdferr)
      else
        print*,"hdf_open: mode = "//trim(mode2)//" not supported."
        print*,"Use READ, WRITE or READWRITE (R, W, RW)"
        stop
      end if
    elseif (state2 == 'NEW' .or. state2 == 'N') then
      call h5fcreate_f(filename, H5F_ACC_TRUNC_F, file_id, hdferr)
    elseif (state2 == 'REPLACE' .or. state2 == 'RP') then
      call h5fcreate_f(filename, H5F_ACC_EXCL_F, file_id, hdferr)
    else
      print*,"hdf_open: state = "//trim(state2)//" not supported."
      print*,"Use OLD, NEW or REPLACE (O, N, RP)"
      stop
    end if

  end function hdf_open_file

!#################################################################################################!
  function hdf_close_file(file_id) result(hdferr)
    integer(HID_T), intent(in) :: file_id  !< file id to be closed
    integer :: hdferr

    call h5fclose_f(file_id, hdferr)
  end function hdf_close_file

!#################################################################################################!
  subroutine hdf_close(hdferr)
    integer, intent(out) :: hdferr

    call h5close_f(hdferr)
  end subroutine hdf_close

!#################################################################################################!
  function hdf_create_group(loc_id, group_name) result(grp_id)
    integer(HID_T), intent(in) :: loc_id         !< location id where to put the group
    character(len=*), intent(in) :: group_name   !< name of the group
    integer(HID_T) :: grp_id
    integer :: hdferr

    call h5gcreate_f(loc_id, group_name, grp_id, hdferr)
  end function hdf_create_group

!#################################################################################################!
  function hdf_open_group(loc_id, group_name) result(grp_id)
    integer(HID_T), intent(in) :: loc_id         !< location id where to put the group
    character(len=*), intent(in) :: group_name   !< name of the group
    integer(HID_T) :: grp_id      !< id for the group
    integer :: hdferr

    call h5gopen_f(loc_id, group_name, grp_id, hdferr)
  end function hdf_open_group

!#################################################################################################!
  function hdf_close_group(grp_id) result(hdferr)
    integer(HID_T), intent(in) :: grp_id   !< id for the group
    integer :: hdferr

    call h5gclose_f(grp_id, hdferr)
  end function hdf_close_group

!#################################################################################################!
  function grp_num_of_obj(grp_id, nlinks) result(hdferr)
    integer(kind=HID_T), intent(in) :: grp_id   !< id for the group
    integer, intent(out) :: nlinks
    integer :: max_corder, storage_type, hdferr

    call h5gget_info_f(grp_id, storage_type, nlinks, max_corder, hdferr)
  end function grp_num_of_obj

!#################################################################################################!
  function grp_obj_name_idx(grp_id, idx, obj_name) result(hdferr)
    integer(kind=HID_T), intent(in) :: grp_id   !< id for the group
    integer(kind=HID_T), intent(in) :: idx
    character(len=*), intent(out) :: obj_name
    character(len=80) :: group_name
    integer(kind=HID_T) :: obj_id
    integer :: hdferr

    hdferr = get_obj_name(grp_id, group_name)
    call h5oopen_by_idx_f(grp_id, trim(group_name), H5_INDEX_NAME_F, H5_ITER_INC_F, int(idx,8), obj_id, hdferr)
    hdferr = get_obj_name(obj_id, obj_name)
    call h5oclose_f(obj_id, hdferr)
  end function grp_obj_name_idx

!#################################################################################################!
  function grp_obj_type(grp_id, obj_name, obj_type) result(hdferr)
    integer(kind=HID_T), intent(in) :: grp_id   !< id for the group
    character(len=*), intent(in) :: obj_name
    integer, intent(out) :: obj_type
    integer(kind=HID_T) :: obj_id
    integer :: hdferr

    call h5oopen_f(grp_id, obj_name, obj_id, hdferr)
    call h5iget_type_f(obj_id, obj_type, hdferr)
    call h5oclose_f(obj_id, hdferr)
  end function grp_obj_type

!#################################################################################################!
  function obj_is_dset(grp_id, obj_name, is_dset) result(hdferr)
    integer(kind=HID_T), intent(in) :: grp_id   !< id for the group
    character(len=*), intent(in) :: obj_name
    logical, intent(out) :: is_dset
    integer :: obj_type, hdferr

    hdferr = grp_obj_type(grp_id, obj_name, obj_type)
    is_dset=.false.
    if(obj_type==H5I_DATASET_F) is_dset=.true.
  end function obj_is_dset

!#################################################################################################!
  function obj_is_grp(grp_id, obj_name, is_grp) result(hdferr)
    integer(kind=HID_T), intent(in) :: grp_id   !< id for the group
    character(len=*), intent(in) :: obj_name
    logical, intent(out) :: is_grp
    integer :: obj_type, hdferr

    hdferr = grp_obj_type(grp_id, obj_name, obj_type)
    is_grp=.false.
    if(obj_type==H5I_GROUP_F) is_grp=.true.
  end function obj_is_grp

!#################################################################################################!
  function hdf_get_rank(loc_id, dset_name, d_rank) result(hdferr)
    integer(HID_T), intent(in) :: loc_id        !< location id
    character(len=*), intent(in) :: dset_name   !< dataset name
    integer, intent(out) :: d_rank                !< rank of the dataset
    integer(HID_T) :: dset_id, dspace_id
    integer :: hdferr

    call h5dopen_f(loc_id, dset_name, dset_id, hdferr)
    call h5dget_space_f(dset_id, dspace_id, hdferr)
    call h5sget_simple_extent_ndims_f(dspace_id, D_RANK, hdferr)

    call h5sclose_f(dspace_id, hdferr)
    call h5dclose_f(dset_id, hdferr)
  end function hdf_get_rank

!#################################################################################################!
  function hdf_get_dims(loc_id, dset_name, dims) result(hdferr)
    integer(HID_T), intent(in) :: loc_id        !< location id
    character(len=*), intent(in) :: dset_name   !< name of dataset
    integer, intent(out) :: dims(:)             !< dimensions of the dataset
    integer(HID_T) :: dset_id, dspace_id
    integer :: D_RANK
    integer(HSIZE_T) :: dset_dims(6), max_dims(6)
    integer :: hdferr

    call h5dopen_f(loc_id, dset_name, dset_id, hdferr)
    call h5dget_space_f(dset_id, dspace_id, hdferr)
    call h5sget_simple_extent_ndims_f(dspace_id, D_RANK, hdferr)
    call h5sget_simple_extent_dims_f(dspace_id, dset_dims(1:D_RANK), max_dims(1:D_RANK), hdferr)
    dims(1:D_RANK) = int(dset_dims(1:D_RANK))

    call h5sclose_f(dspace_id, hdferr)
    call h5dclose_f(dset_id, hdferr)
  end function hdf_get_dims

!#################################################################################################!
    subroutine get_dset_type(loc_id, dset_name, dset_type, dset_type_size, hdferr)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer(HID_T) :: dset_id, datatype_id
      integer, intent(out) :: hdferr
      integer, intent(out) :: dset_type
      integer(SIZE_T), intent(out) :: dset_type_size


      dset_id=open_dset(loc_id, dset_name)

      call h5dget_type_f(dset_id, datatype_id, hdferr)
      call h5tget_class_f(datatype_id, dset_type, hdferr)
      call h5tget_size_f(datatype_id, dset_type_size, hdferr)
      call h5tclose_f(datatype_id, hdferr)

      hdferr=close_dset(dset_id)
    end subroutine get_dset_type

!#################################################################################################!
    integer(HID_T) function Get_Obj_Id(file_id, d_name, d_idx, gr_id, stat)
      ! Returns an object identifier.
      ! If dataset name "d_name" or index "d_idx" is given, a
      ! dataset is returned from the  file and group with the
      ! respective identifiers "file_id" and "gr_id".
      ! If no input arguments for the dataset name and index are given,
      ! the group identifier is returned.
      ! If no group id is given, the root group ("/") is returned.
      integer(HID_T), intent(in) :: file_id
      character (len=*) ,optional, intent(in) :: d_name
      character (len=LEN_STR_ATTR) :: buff_name
      integer, optional, intent(in) :: d_idx
      integer, optional, intent (out) :: stat
      integer :: hdferr
      integer :: obj_type
      integer(HID_T), optional ,intent(in) :: gr_id
      integer(HID_T) :: buff_gr_id

      if(present(gr_id)) then
        buff_gr_id =  gr_id
      else
        ! Open root group:
        call H5gopen_f(file_id, "/", buff_gr_id, hdferr)
      end if

      if (.not. present(d_name)) then
        if (present(d_idx)) then
          call H5gget_obj_info_idx_f(file_id, "/", d_idx, buff_name, obj_type, hdferr)
          call H5dopen_f(buff_gr_id, trim(buff_name), get_obj_id, hdferr)
        else
          get_obj_id = buff_gr_id
        end if
      else
        call H5dopen_f(buff_gr_id, trim(d_name), get_obj_id, hdferr)
      end if
      if (present(stat)) stat = hdferr
    end function Get_Obj_Id

!#################################################################################################!
    function Ch_Attr_exist(obj_id, a_name)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        logical :: Ch_Attr_exist
        integer(HID_T) :: attr_id, space_id
        integer :: hdferr

        call h5aexists_f(obj_id, a_name, Ch_Attr_exist, hdferr)
    end function Ch_Attr_exist

!#################################################################################################!
    function number_attrs(obj_id)
        integer(HID_T), intent(in) :: obj_id
        integer(kind=HID_T) :: number_attrs
        TYPE(h5o_info_t), TARGET   :: object_info
        integer :: hdferr

        call h5oget_info_f(obj_id, object_info, hdferr)
        number_attrs = object_info%num_attrs
    end function number_attrs

!#################################################################################################!
    subroutine attr_type_size(obj_id, a_name, att_type, att_type_size, hdferr)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, type_id
        integer :: hdferr
        integer, intent(out) :: att_type
        integer(SIZE_T), intent(out) :: att_type_size

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_class_f(type_id, att_type, hdferr)
        call h5tget_size_f(type_id, att_type_size, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end subroutine attr_type_size

!#################################################################################################!
    function get_att_name_idx(obj_id, obj_name, idx, a_name) result(hdferr)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in)  :: obj_name
        integer, intent(in) :: idx
        character(len=*), intent(out) :: a_name
        integer :: hdferr

        call h5aget_name_by_idx_f(obj_id, obj_name, H5_INDEX_NAME_F, H5_ITER_INC_F, int(idx,8), a_name, hdferr)
    end function get_att_name_idx

!#################################################################################################!
  function get_att_dims(loc_id, a_name, dims) result(hdferr)
    integer(HID_T), intent(in) :: loc_id        !< location id
    character(len=*), intent(in) :: a_name   !< name of dataset
    integer, intent(out) :: dims(:)             !< dimensions of the dataset
    integer(HID_T) :: attr_id, dspace_id
    integer :: D_RANK
    integer(HSIZE_T) :: aset_dims(6), max_dims(6)
    integer :: hdferr

    call h5aopen_f(loc_id, a_name, attr_id, hdferr)
    call H5aget_space_f(attr_id, dspace_id, hdferr)
    call h5sget_simple_extent_ndims_f(dspace_id, D_RANK, hdferr)
    call h5sget_simple_extent_dims_f(dspace_id, aset_dims(1:D_RANK), max_dims(1:D_RANK), hdferr)
    dims(1:D_RANK) = int(aset_dims(1:D_RANK))

    call h5sclose_f(dspace_id, hdferr)
    call h5aclose_f(attr_id,hdferr)
  end function get_att_dims

!#################################################################################################!
    function get_obj_name(obj_id, obj_name) result(hdferr)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(inout)  :: obj_name
        integer(kind=8) :: name_size
        integer :: hdferr

        call h5iget_name_f(obj_id, obj_name, int(len(obj_name),8), name_size, hdferr)
    end function get_obj_name

!#################################################################################################!
    function Create_Int16_Attr0(obj_id, a_name, val) result(stat)
        integer(kind=I16), intent(in) :: val
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 2 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
        adims = [0]
        call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Int16_Attr0

!#################################################################################################!
    function Create_Int16_Attr1(obj_id, a_name, val) result(stat)
        integer(kind=I16), contiguous, intent(in) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 2 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
        adims = shape(val, kind=HID_T)
        if( adims(1)==1 ) then
          call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        else
          call H5screate_simple_f(rank(val), adims, space_id, hdferr)
        end if
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Int16_Attr1

!#################################################################################################!
    function Create_Int32_Attr0(obj_id, a_name, val) result(stat)
        integer(kind=HID_T), intent(in) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 4 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
        adims = [0]
        call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_INTEGER, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Int32_Attr0

!#################################################################################################!
    function Create_Int32_Attr1(obj_id, a_name, val) result(stat)
        integer(kind=HID_T), contiguous, intent(in) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 4 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
        adims = shape(val, kind=HID_T)
        if( adims(1)==1 ) then
          call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        else
          call H5screate_simple_f(rank(val), adims, space_id, hdferr)
        end if
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_INTEGER, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Int32_Attr1

!#################################################################################################!
    function Create_Char_Attr0(obj_id, a_name, val) result(stat)
        character(len=*), intent(in) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: HDFSIZE
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
        adims = [0]
        call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        HDFSIZE=len(val)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, type_id, trim(val), adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Char_Attr0

!#################################################################################################!
    function Create_Char_Attr1(obj_id, a_name, val) result(stat)
        character(len=*), intent(in) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(HSIZE_T) :: adims(1) !Attribut Dimension
        integer(kind=SIZE_T) :: HDFSIZE

        call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
        adims = shape(val, kind=HID_T)
        if( adims(1)==1 ) then
          call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        else
          call H5screate_simple_f(rank(val), adims, space_id, hdferr)
        end if
        HDFSIZE=len(val)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, type_id, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Char_Attr1

!#################################################################################################!
    function Create_Real32_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=SP), intent(in) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 4 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
        adims = [0]
        call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_REAL, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Real32_Attr0

!#################################################################################################!
    function Create_Real32_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=SP), contiguous, intent(in) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 4 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
        adims = shape(val, kind=HID_T)
        if( adims(1)==1 ) then
          call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        else
          call H5screate_simple_f(rank(val), adims, space_id, hdferr)
        end if
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, H5T_NATIVE_REAL, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Real32_Attr1

!#################################################################################################!
    function Create_Real64_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=DP), intent(in) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 8 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
        adims = [0]
        call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, type_id, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Real64_Attr0

!#################################################################################################!
    function Create_Real64_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=DP), contiguous, intent(in) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T), parameter :: HDFSIZE = 8 ! DataType Size in Bytes
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
        adims = shape(val, kind=HID_T)
        if( adims(1)==1 ) then
          call H5screate_f(H5S_SCALAR_F, space_id, hdferr)
        else
          call H5screate_simple_f(rank(val), adims, space_id, hdferr)
        end if
        call H5tset_size_f(type_id, HDFSIZE, hdferr)
        call H5acreate_f(obj_id, trim(a_name), type_id, space_id, attr_id, hdferr)
        call H5awrite_f(attr_id, type_id, val, adims, stat)
        call H5aclose_f(attr_id,hdferr)
    end function Create_Real64_Attr1

!#################################################################################################!
    function Create_Empty_Dataset(obj_id, d_name) result(dset_id)
        ! Creates an empty dataset with the only purpose of an attributes
        ! storage. (Here used to hold the spatial reference system
        ! attributes, 'grid_maping'.)
        integer(HID_T), intent(in) :: obj_id
        integer(HID_T) :: dset_id, space_id
        character (len=*), intent(in) :: d_name
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(HSIZE_T) :: adims(1) ! Attribut Dimension
        adims = [0]
        call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
        call H5screate_simple_f(1, adims, space_id, hdferr)
        call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, stat)
        call H5dclose_f(dset_id,hdferr)
        call H5tclose_f(type_id, hdferr)
        call H5sclose_f(space_id, hdferr)
    end function Create_Empty_Dataset

!#################################################################################################!
    function Read_Int_1dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        integer(kind=HID_T), intent(out) :: val(:)
        integer, parameter :: D_RANK=rank(val)
        character(len=255), intent(in) :: dset_name
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Int_1dSlab

!#################################################################################################!
    function Read_Real_1dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        real(kind=SP), intent(out) :: val(:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_REAL, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Real_1dSlab

!#################################################################################################!
    function Read_Int_2dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        integer(kind=HID_T), intent(out) :: val(:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Int_2dSlab

!#################################################################################################!
    function Read_Real_2dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        real(kind=SP), intent(out) :: val(:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_REAL, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Real_2dSlab

!#################################################################################################!
    function Read_Int_3dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        integer(kind=HID_T), intent(out) :: val(:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Int_3dSlab

!#################################################################################################!
    function Read_Real_3dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        real(kind=SP), intent(out) :: val(:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_REAL, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Real_3dSlab

!#################################################################################################!
    function Read_Int_4dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        integer(kind=HID_T), intent(out) :: val(:,:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Int_4dSlab

!#################################################################################################!
    function Read_Real_4dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        real(kind=SP), intent(out) :: val(:,:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_REAL, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Real_4dSlab

!#################################################################################################!
    function Read_Int_5dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        integer(kind=HID_T), intent(out) :: val(:,:,:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Int_5dSlab

!#################################################################################################!
    function Read_Real_5dSlab(obj_id,dset_name,offset,dshape,val) result(dset_id)
        ! Reads a section of a HDF5 dataset
        !
        implicit none
        integer(HID_T), intent(in) :: obj_id
        character(len=255), intent(in) :: dset_name
        real(kind=SP), intent(out) :: val(:,:,:,:,:)
        integer, parameter :: D_RANK=rank(val)
        integer(kind=HSIZE_T), intent(in) :: offset(D_RANK), dshape(D_RANK)
        integer(kind=HSIZE_T) :: offset_out(D_RANK)
        integer :: ierr
        integer(kind=HID_T) :: dset_id, dataspace, memspace

        offset_out = [0,0,0,0,0]

        call H5dopen_f(obj_id, dset_name, dset_id, ierr)
        call H5dget_space_f(dset_id, dataspace, ierr)
        call H5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, ierr)

        call H5screate_simple_f(D_RANK, dshape, memspace, ierr)

        call H5sselect_hyperslab_f(memspace, H5S_SELECT_SET_F, offset_out, dshape, ierr)

        call H5dread_f(dset_id, H5T_NATIVE_REAL, val, dshape, ierr, memspace, dataspace)

        call H5sclose_f(dataspace, ierr)
        call H5sclose_f(memspace, ierr)
        call H5dclose_f(dset_id, ierr)
    end function Read_Real_5dSlab

!#################################################################################################!
    function Read_Char_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        character(len=*), intent(out) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character(len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = shape(val, kind=HID_T)
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Char_Attr1

!#################################################################################################!
    function Read_Char_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        character(len=*), intent(out) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = [0]
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Char_Attr0

!#################################################################################################!
    function Read_Real32_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=SP), intent(out) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = shape(val, kind=HID_T)
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Real32_Attr1

!#################################################################################################!
    function Read_Real32_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=SP), intent(out) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = [0]
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Real32_Attr0

!#################################################################################################!
    function Read_Real64_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=DP), intent(out) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = shape(val, kind=HID_T)
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Real64_Attr1

!#################################################################################################!
    function Read_Real64_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        real(kind=DP), intent(out) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = [0]
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Real64_Attr0


!#################################################################################################!
    function Read_Int_Attr1(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        integer(kind=HID_T), intent(out) :: val(:)
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = shape(val, kind=HID_T)
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Int_Attr1

!#################################################################################################!
    function Read_Int_Attr0(obj_id, a_name, val) result(stat)
        ! Returns the exit status of the HDF5 API when writing an attribute.
        ! If dataset name "d_name" or index "d_idx" is given, a
        ! dataset attribute is set from the dataset in file
        ! and group with the respective identifiers "file_id" and "gr_id".
        ! If no input arguments for the dataset name and index are given,
        ! the attribute will be set at the given group in the file.
        ! If no group id is given, the dataset will be get from
        ! the root group ("/").
        integer(kind=HID_T), intent(out) :: val
        integer(HID_T), intent(in) :: obj_id
        character (len=*), intent(in) :: a_name
        integer(HID_T) :: attr_id, space_id
        integer :: stat
        integer :: hdferr
        integer(HID_T) :: type_id ! DataType identifier
        integer(SIZE_T) :: hdfsize
        integer(HSIZE_T) :: adims(1) !Attribut Dimension

        call h5aopen_f(obj_id, a_name, attr_id, hdferr)
        call h5aget_type_f(attr_id, type_id, hdferr)
        call h5tget_size_f(type_id, hdfsize, hdferr)

        adims = [0]
        call h5aread_f(attr_id, type_id, val, adims, hdferr)
        call H5aclose_f(attr_id,hdferr)
    end function Read_Int_Attr0

!#################################################################################################!
    function Read_Int_0d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val                ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = (/ 0 /)

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_0d_dataset

!#################################################################################################!
    function Read_Int_1d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:)             ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_1d_dataset

!#################################################################################################!
    function Read_Int_2d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:,:)           ! val to be written

      integer(SIZE_T) :: dims(2)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_2d_dataset

!#################################################################################################!
    function Read_Int_3d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:,:,:)         ! val to be written

      integer(SIZE_T) :: dims(3)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_3d_dataset

!#################################################################################################!
    function Read_Int_4d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:,:,:,:)       ! val to be written

      integer(SIZE_T) :: dims(4)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_4d_dataset

!#################################################################################################!
    function Read_Int_5d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:,:,:,:,:)     ! val to be written

      integer(SIZE_T) :: dims(5)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_5d_dataset

!#################################################################################################!
    function Read_Int_6d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer, intent(out) :: val(:,:,:,:,:,:)   ! val to be written

      integer(SIZE_T) :: dims(6)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_INTEGER, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Int_6d_dataset

!#################################################################################################!
    function Read_Real32_0d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val               ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = (/ 0 /)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_0d_dataset

!#################################################################################################!
    function Read_Real32_1d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:)            ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_1d_dataset

!#################################################################################################!
    function Read_Real32_2d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:,:)          ! val to be written

      integer(SIZE_T) :: dims(2)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_2d_dataset

!#################################################################################################!
    function Read_Real32_3d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:,:,:)        ! val to be written

      integer(SIZE_T) :: dims(3)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_3d_dataset

!#################################################################################################!
    function Read_Real32_4d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:,:,:,:)      ! val to be written

      integer(SIZE_T) :: dims(4)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_4d_dataset

!#################################################################################################!
    function Read_Real32_5d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:,:,:,:,:)    ! val to be written

      integer(SIZE_T) :: dims(5)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_5d_dataset

!#################################################################################################!
    function Read_Real32_6d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=SP), intent(out) :: val(:,:,:,:,:,:)  ! val to be written

      integer(SIZE_T) :: dims(6)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_REAL, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real32_6d_dataset

!#################################################################################################!
    function Read_Real64_0d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val               ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = (/ 0 /)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_0d_dataset

!#################################################################################################!
    function Read_Real64_1d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:)            ! val to be written

      integer(SIZE_T) :: dims(1)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_1d_dataset

!#################################################################################################!
    function Read_Real64_2d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:,:)          ! val to be written

      integer(SIZE_T) :: dims(2)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_2d_dataset

!#################################################################################################!
    function Read_Real64_3d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:,:,:)        ! val to be written

      integer(SIZE_T) :: dims(3)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_3d_dataset

!#################################################################################################!
    function Read_Real64_4d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:,:,:,:)      ! val to be written

      integer(SIZE_T) :: dims(4)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)
      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_4d_dataset

!#################################################################################################!
    function Read_Real64_5d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:,:,:,:,:)    ! val to be written

      integer(SIZE_T) :: dims(5)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_5d_dataset

!#################################################################################################!
    function Read_Real64_6d_dataset(loc_id, dset_name, val) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      real(kind=DP), intent(out) :: val(:,:,:,:,:,:)  ! val to be written

      integer(SIZE_T) :: dims(6)
      integer(HID_T) :: dset_id
      integer :: ierr

      dims = shape(val, kind=HID_T)

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
      call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, val, dims, ierr)
      call h5dclose_f(dset_id, ierr)
    end function Read_Real64_6d_dataset

!#################################################################################################!
    function Extend_Int8_1d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_1d_Dataset

!#################################################################################################!
    function Extend_Int16_1d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_1d_Dataset

!#################################################################################################!
    function Extend_Int32_1d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_1d_Dataset

!#################################################################################################!
    function Extend_Real32_1d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_1d_Dataset

!#################################################################################################!
    function Extend_Real64_1d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_1d_Dataset

!#################################################################################################!
    function Extend_Int8_2d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_2d_Dataset

!#################################################################################################!
    function Extend_Int16_2d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_2d_Dataset

!#################################################################################################!
    function Extend_Int32_2d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_2d_Dataset

!#################################################################################################!
    function Extend_Real32_2d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_2d_Dataset

!#################################################################################################!
    function Extend_Real64_2d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_2d_Dataset

!#################################################################################################!
    function Extend_Int8_3d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_3d_Dataset

!#################################################################################################!
    function Extend_Int16_3d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_3d_Dataset

!#################################################################################################!
    function Extend_Int32_3d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_3d_Dataset

!#################################################################################################!
    function Extend_Real32_3d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_3d_Dataset

!#################################################################################################!
    function Extend_Real64_3d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_3d_Dataset

!#################################################################################################!
    function Extend_Int8_4d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_4d_Dataset

!#################################################################################################!
    function Extend_Int16_4d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_4d_Dataset

!#################################################################################################!
    function Extend_Int32_4d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_4d_Dataset

!#################################################################################################!
    function Extend_Real32_4d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_4d_Dataset

!#################################################################################################!
    function Extend_Real64_4d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_4d_Dataset

!#################################################################################################!
    function Extend_Int8_5d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_5d_Dataset

!#################################################################################################!
    function Extend_Int16_5d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_5d_Dataset

!#################################################################################################!
    function Extend_Int32_5d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_5d_Dataset

!#################################################################################################!
    function Extend_Real32_5d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_5d_Dataset

!#################################################################################################!
    function Extend_Real64_5d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_5d_Dataset

!#################################################################################################!
    function Extend_Int8_6d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call h5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int8_6d_Dataset

!#################################################################################################!
    function Extend_Int16_6d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call h5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,4), data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int16_6d_Dataset

!#################################################################################################!
    function Extend_Int32_6d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call h5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Int32_6d_Dataset

!#################################################################################################!
    function Extend_Real32_6d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call h5dwrite_f(dset_id, H5T_NATIVE_REAL, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real32_6d_Dataset

!#################################################################################################!
    function Extend_Real64_6d_Dataset(loc_id, d_name, new_size, offset, dshape, val) result(stat)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:,:,:)
      character (len=*), intent(in) :: d_name
      integer(kind=HID_T), intent(in) :: loc_id
      integer, parameter :: D_RANK=rank(val)
      integer(kind=HSIZE_T), intent(in) :: new_size(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: offset(D_RANK)
      integer(kind=HSIZE_T), intent(in) :: dshape(D_RANK)
      integer(kind=HSIZE_T) :: data_dims(D_RANK)
      integer(kind=HID_T) :: dataspace
      integer(kind=HID_T) :: memspace
      integer(kind=HID_T) :: dset_id
      integer :: error
      integer :: stat

      data_dims = dshape

      call h5dopen_f(loc_id, d_name, dset_id, error)
      call h5dset_extent_f(dset_id, new_size, error)
      call h5screate_simple_f (D_RANK, data_dims, memspace, error)
      call h5dget_space_f(dset_id, dataspace, error)
      call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, offset, dshape, error)

      call h5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, data_dims, stat, memspace, dataspace)

      call h5sclose_f(dataspace, error)
      call h5dclose_f(dset_id, error)
    end function Extend_Real64_6d_Dataset

!#################################################################################################!
    function Create_Int8_1d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_1d_Dataset

!#################################################################################################!
    function Create_Int16_1d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I16), contiguous, intent(in) :: val(:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_1d_Dataset

!#################################################################################################!
    function Create_Int32_1d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=HID_T), contiguous, intent(in) :: val(:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_1d_Dataset

!#################################################################################################!
    function Create_Real32_1d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=SP), contiguous, intent(in) :: val(:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_1d_Dataset

!#################################################################################################!
    function Create_Real64_1d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_1d_Dataset

!#################################################################################################!
    function Create_Int8_2d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_2d_Dataset

!#################################################################################################!
    function Create_Int16_2d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I16), contiguous, intent(in) :: val(:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_2d_Dataset

!#################################################################################################!
    function Create_Int32_2d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_2d_Dataset

!#################################################################################################!
    function Create_Real32_2d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=SP), contiguous, intent(in) :: val(:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_2d_Dataset

!#################################################################################################!
    function Create_Real64_2d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_2d_Dataset

!#################################################################################################!
    function Create_Int8_3d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_3d_Dataset

!#################################################################################################!
    function Create_Int16_3d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_3d_Dataset

!#################################################################################################!
    function Create_Int32_3d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_3d_Dataset

!#################################################################################################!
    function Create_Real32_3d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_3d_Dataset

!#################################################################################################!
    function Create_Real64_3d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_3d_Dataset

!#################################################################################################!
    function Create_Int8_4d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_4d_Dataset

!#################################################################################################!
    function Create_Int16_4d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_4d_Dataset

!#################################################################################################!
    function Create_Int32_4d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_4d_Dataset

!#################################################################################################!
    function Create_Real32_4d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_4d_Dataset

!#################################################################################################!
    function Create_Real64_4d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_4d_Dataset

!#################################################################################################!
    function Create_Int8_5d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_5d_Dataset

!#################################################################################################!
    function Create_Int16_5d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I16), contiguous, intent(in) :: val(:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_5d_Dataset

!#################################################################################################!
    function Create_Int32_5d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=HID_T), contiguous, intent(in) :: val(:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_5d_Dataset

!#################################################################################################!
    function Create_Real32_5d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=SP), contiguous, intent(in) :: val(:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, stat)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_5d_Dataset

!#################################################################################################!
    function Create_Real64_5d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: stat
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, hdferr)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_5d_Dataset

!#################################################################################################!
    function Create_Int8_6d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(kind=I8), contiguous, intent(in) :: val(:,:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_CHARACTER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, int(val,kind=HID_T), adims, hdferr)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int8_6d_Dataset

!#################################################################################################!
    function Create_Int16_6d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(I16), contiguous, intent(in) :: val(:,:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_STD_I16LE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, adims, hdferr)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int16_6d_Dataset

!#################################################################################################!
    function Create_Int32_6d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      integer(I32), contiguous, intent(in) :: val(:,:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_INTEGER, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_INTEGER, fill_val, hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)
      call H5dwrite_f(dset_id, H5T_NATIVE_INTEGER, val, adims, hdferr)
      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Int32_6d_Dataset

!#################################################################################################!
    function Create_Real32_6d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(SP), contiguous, intent(in) :: val(:,:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_REAL, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_REAL, real(fill_val, kind=SP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)

      call H5dwrite_f(dset_id, H5T_NATIVE_REAL, val, adims, hdferr)

      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real32_6d_Dataset

!#################################################################################################!
    function Create_Real64_6d_Dataset(obj_id, d_name, val, fill_val, in_chunk_size, comp_level, extendable) result(dset_id)
      real(kind=DP), contiguous, intent(in) :: val(:,:,:,:,:,:)
      integer(HID_T), intent(in) :: obj_id
      integer(HID_T) :: dset_id, space_id
      character (len=*), intent(in) :: d_name
      integer :: hdferr
      integer, parameter :: D_RANK=rank(val)
      integer(HID_T) :: type_id ! DataType identifier
      integer, optional, intent(in) :: fill_val
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer(kind=HSIZE_T) :: chunk_size
      integer(HSIZE_T) :: adims(D_RANK), max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)
      integer(HID_T) :: prp_id ! Property identifier

      adims = shape(val)
      call create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)

      call H5tcopy_f(H5T_NATIVE_DOUBLE, type_id, hdferr)
      if (present(fill_val)) then
        call H5pset_fill_value_f(prp_id, H5T_NATIVE_DOUBLE, real(fill_val, kind=DP), hdferr)
      end if

      call H5screate_simple_f(D_RANK, adims, space_id, hdferr, max_dims)
      call H5dcreate_f(obj_id, d_name, type_id, space_id, dset_id, hdferr, prp_id)

      call H5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, val, adims, hdferr)

      call H5dclose_f(dset_id,hdferr)
      call H5tclose_f(type_id, hdferr)
      call H5sclose_f(space_id, hdferr)
      call H5pclose_f(prp_id, hdferr)
    end function Create_Real64_6d_Dataset

!#################################################################################################!
    subroutine create_propriety_list(D_RANK, adims, in_chunk_size, comp_level, extendable, prp_id, max_dims)
      integer, intent(in) :: D_RANK
      integer(kind=HSIZE_T), intent(in) :: adims(D_RANK)
      integer(kind=HID_T), optional, intent(in) :: in_chunk_size ! Chunk size
      integer, optional, intent(in) :: comp_level ! Compression level
      integer(kind=HID_T), optional, intent(in) :: extendable
      integer(kind=HID_T), intent(out) :: prp_id ! Property identifier
      integer(kind=HSIZE_T), intent(out) :: max_dims(D_RANK) ! Dataset Dimension, MaxDimension ->
                                               ! -> (MaxDimension is here used to enable extend for the time dimension)

      integer(kind=HSIZE_T) :: chunk_size
      logical :: lcompress
      integer(kind=HID_T) :: i
      integer(kind=HSIZE_T) :: chunk_arr(D_RANK)
      integer :: hdferr

      call H5pcreate_f(H5P_DATASET_CREATE_F, prp_id, hdferr)

      if( present(in_chunk_size) ) then
          chunk_size=int(in_chunk_size,HSIZE_T)
      else
          chunk_size=100
      end if

      chunk_arr=chunk_size

      lcompress = .true.
      if (present(extendable) .and. extendable>0 .and. extendable<=D_RANK) then
        do i=D_RANK,D_RANK-extendable+1,-1
          chunk_arr(i)=int(1,kind=HSIZE_T)
        end do
        max_dims(:D_RANK-extendable) = adims(:D_RANK-extendable)
        max_dims((D_RANK-extendable+1):) = H5S_UNLIMITED_F
        call H5pset_chunk_f(prp_id, D_RANK, chunk_arr, hdferr)
        if (minval(max_dims(:D_RANK-extendable))<chunk_size) lcompress = .false.
      else
        max_dims = adims
        if (minval(max_dims)>chunk_size) then
          call H5pset_chunk_f(prp_id, D_RANK, chunk_arr, hdferr)
        else
          lcompress = .false.
        end if
      end if

      if (present(comp_level) .and. lcompress) then
        call H5pset_deflate_f(prp_id, comp_level, hdferr)
      end if
    end subroutine create_propriety_list

!#################################################################################################!
    function open_dset(loc_id, dset_name) result(dset_id)
      integer(HID_T), intent(in) :: loc_id        ! local id in file
      character(len=*), intent(in) :: dset_name   ! name of dataset
      integer(HID_T) :: dset_id
      integer :: ierr

      call h5dopen_f(loc_id, dset_name, dset_id, ierr)
    end function open_dset

!#################################################################################################!
    function close_dset(dset_id) result(ierr)
      integer(HID_T), intent(in) :: dset_id
      integer :: ierr
      call h5dclose_f(dset_id, ierr)
    end function close_dset

!#################################################################################################!
    function def_scale(dim_id, dim_name) result(ierr)
      integer(kind=HID_T), intent(in) :: dim_id
      character(len=*), intent(in), optional :: dim_name
      integer :: ierr

      if (present(dim_name)) then
        call h5dsset_scale_f(dim_id, ierr, dim_name)
      else
        call h5dsset_scale_f(dim_id, ierr)
      end if
    end function def_scale

!#################################################################################################!
    function set_scale(dset_id, dim_id, idx_dim) result(ierr)
      integer(kind=HID_T), intent(in) :: dset_id
      integer(kind=HID_T), intent(in) :: dim_id
      integer, intent(in) :: idx_dim
      integer :: ierr
      call h5dsattach_scale_f(dset_id, dim_id, idx_dim, ierr)
    end function set_scale

!#################################################################################################!
end module H5_Func_mod
