cmake_minimum_required(VERSION 3.5.1)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if (POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW) # CMake 3.12
endif ()

project(marian_translator CXX C)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_ARCH native CACHE STRING "Compile for this CPU architecture.")

# Custom CMake options
option(COMPILE_CPU "Compile CPU version" ON)
option(COMPILE_CUDA "Compile GPU version" ON)
option(COMPILE_CUDA_SM35 "Compile GPU version with SM35 support" ON)
option(COMPILE_CUDA_SM50 "Compile GPU version with SM50 support" ON)
option(COMPILE_CUDA_SM60 "Compile GPU version with SM60 support" ON)
option(COMPILE_CUDA_SM70 "Compile GPU version with SM70 support" ON)
option(COMPILE_EXAMPLES "Compile examples" OFF)
option(COMPILE_REST_SERVER "Compile Marian REST server" ON)
option(COMPILE_SERVER "Compile marian-server" OFF)
option(COMPILE_TESTS "Compile tests" OFF)
option(UPDATE_SUBMODULES "Check for changes in submodules" OFF)
option(USE_CCACHE "Use ccache compiler cache (https://ccache.dev)" ON)
option(USE_CUDNN "Use CUDNN library" OFF)
option(USE_DOXYGEN "Build documentation with Doxygen" OFF)
option(USE_FBGEMM "Use FBGEMM" OFF)
option(USE_MKL "Compile with MKL support" ON)
option(USE_MPI "Use MPI library" OFF)
option(USE_NCCL "Use NCCL library" ON)
option(USE_SENTENCEPIECE "Download and compile SentencePiece" ON)
option(USE_STATIC_LIBS "Link statically against non-system libs" ON)

# Project versioning
find_package(Git QUIET)
include(GetVersionFromFile)
message(STATUS "Project name: ${PROJECT_NAME}")
message(STATUS "Project version: ${PROJECT_VERSION_STRING_FULL}")

include(UpdateSubmodules)

add_subdirectory(3rd_party)
message("EXT_LIBS ${EXT_LIBS}")
include_directories(${INCLUDE_DIRECTORIES})

list(APPEND BOOST_COMPONENTS system)
set(Boost_USE_STATIC_LIBS USE_STATIC_LIBS)
find_package(Boost COMPONENTS ${BOOST_COMPONENTS})
if(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
  set(EXT_LIBS ${EXT_LIBS} ${Boost_LIBRARIES})
  set(EXT_LIBS ${EXT_LIBS} ${ZLIB_LIBRARIES}) # hack for static compilation
else(Boost_FOUND)
  message(SEND_ERROR "Cannot find Boost libraries. Terminating.")
endif(Boost_FOUND)

if (COMPILE_CUDA)
  find_package(CUDA "9.0")
endif(COMPILE_CUDA)
if(USE_CUDNN)
  find_package(CUDNN "7.0")
endif(USE_CUDNN)

add_subdirectory(src)
