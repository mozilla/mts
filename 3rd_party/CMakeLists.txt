# propagate certain variables to parent scope
add_subdirectory(marian)
include_directories(marian/src)
include_directories(marian/src/3rd_party)
get_directory_property(CTI DIRECTORY marian DEFINITION CUDA_TOOLKIT_INCLUDE)
include_directories(${CTI})

# add_subdirectory(crow)
include_directories(crow/include)

add_subdirectory(ssplit-cpp)
include_directories(ssplit-cpp/src)
include_directories(rapidjson/include)

get_directory_property(EXT_LIBS DIRECTORY marian DEFINITION EXT_LIBS)
get_directory_property(CMAKE_C_FLAGS DIRECTORY marian DEFINITION CMAKE_C_FLAGS)
get_directory_property(CMAKE_CXX_FLAGS DIRECTORY marian DEFINITION CMAKE_CXX_FLAGS)
get_directory_property(INCLUDE_DIRECTORIES INCLUDE_DIRECTORIES)

set(EXT_LIBS ${EXT_LIBS} PARENT_SCOPE)
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} PARENT_SCOPE)
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)
set(INCLUDE_DIRECTORIES ${INCLUDE_DIRECTORIES} PARENT_SCOPE)
