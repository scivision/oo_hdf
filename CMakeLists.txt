# real32, real64 supported by HDF5 1.10 https://support.hdfgroup.org/HDF5/doc/RM/PredefDTypes.html
cmake_minimum_required (VERSION 3.2.2)
project(oo_hdf5 Fortran)

if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    list(APPEND FFLAGS -check all -traceback -warn -debug extended)
    set(F64 -r8)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
    if(${CMAKE_Fortran_COMPILER_VERSION} VERSION_LESS 5.4.1)
      message(ERROR " gfortran >= 5.4.1 required, you have " ${CMAKE_Fortran_COMPILER_VERSION})
    endif()
    list(APPEND FFLAGS -std=f2008ts -march=native -Wall -Wextra -Wpedantic -Werror=array-bounds -fbacktrace -fcheck=all -fmax-errors=3)
    set(F64 -fdefault-real-8)
endif()

add_compile_options(-O3 -g ${FFLAGS})
#------------------------
find_package(HDF5 REQUIRED COMPONENTS Fortran Fortran_HL)

# need BOTH includes, for some older systems!
include_directories(${HDF5_INCLUDE_DIRS} ${HDF5_Fortran_INCLUDE_DIRS})

add_library(h5oo src/H5_OO_mod.f90 src/H5_func_mod.f90 src/Strings_Func_mod.f90 src/Types_mod.f90)
target_link_libraries(h5oo PRIVATE ${HDF5_Fortran_LIBRARIES} ${HDF5_Fortran_HL_LIBRARIES})
#set_target_properties(h5oo PROPERTIES Fortran_MODULE_DIRECTORY mod.real64)

add_executable(test_h5oo_mod tests/test_objs.f90)
target_link_libraries(test_h5oo_mod h5oo)
#target_compile_options(test_h5oo_mod PRIVATE -Wno-compare-reals)
#set_target_properties(test_h5oo_mod PROPERTIES Fortran_MODULE_DIRECTORY mod.real64)
#---------------------------
enable_testing()
add_test(NAME h5oo_mod COMMAND test_h5oo_mod)

