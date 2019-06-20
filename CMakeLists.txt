# This file is just an orchestration
cmake_minimum_required(VERSION 3.14.2)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Apple: Don't modify install_name when touching RPATH.
if(POLICY CMP0068)
  cmake_policy(SET CMP0068 NEW)
endif()
# target_sources: use absolute path for INTERFACE_SOURCES.
if(POLICY CMP0076)
  cmake_policy(SET CMP0076 NEW)
endif()
# SWIG: use standard target name.
if(POLICY CMP0078)
  cmake_policy(SET CMP0078 NEW)
endif()
# SWIG: use SWIG_MODULE_NAME property.
if(POLICY CMP0086)
  cmake_policy(SET CMP0086 NEW)
endif()

project(fjpy VERSION 1.0 LANGUAGES CXX)
message(STATUS "version: ${PROJECT_VERSION}")

execute_process ( COMMAND fastjet-config --prefix WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_DIR OUTPUT_STRIP_TRAILING_WHITESPACE )
execute_process ( COMMAND fastjet-config --cxxflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_CXXFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
execute_process ( COMMAND fastjet-config --libs --plugins WORKING_DIRECTORY /tmp OUTPUT_VARIABLE FASTJET_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE )
message( STATUS "FASTJET_DIR: ${FASTJET_DIR}")
message( STATUS "FASTJET_CXXFLAGS: ${FASTJET_CXXFLAGS}")
message( STATUS "FASTJET_LIBS: ${FASTJET_LIBS}")

message( STATUS "CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
execute_process ( COMMAND
                 ${CMAKE_CURRENT_SOURCE_DIR}/buildtools/get_fj_contrib.sh
                 ${CMAKE_CURRENT_SOURCE_DIR} /tmp
#                 ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR}
                 OUTPUT_VARIABLE GET_FJ_CONTRIB
                 WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} )
message( STATUS "GET_FJ_CONTRIB: ${GET_FJ_CONTRIB}")

execute_process ( COMMAND pythia8-config --prefix WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_DIR OUTPUT_STRIP_TRAILING_WHITESPACE )
execute_process ( COMMAND pythia8-config --cxxflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_CXXFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
execute_process ( COMMAND pythia8-config --ldflags WORKING_DIRECTORY /tmp OUTPUT_VARIABLE PYTHIA8_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE )
message( STATUS "PYTHIA8_DIR: ${PYTHIA8_DIR}")
message( STATUS "PYTHIA8_CXXFLAGS: ${PYTHIA8_CXXFLAGS}")
message( STATUS "PYTHIA8_LDFLAGS: ${PYTHIA8_LDFLAGS}")
set(PYTHIA8_LDFLAGS "${PYTHIA8_LDFLAGS} -ldl")


#include(util)
set(CMAKE_VERBOSE_MAKEFILE ON)

# Force default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of build, options are: Debug, Release (default), RelWithDebInfo and MinSizeRel."
    FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Layout build dir like install dir
if(UNIX)
  option(BUILD_SHARED_LIBS "Build shared libraries(.so or .dyld)." ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  include_directories("/usr/local/include")
  link_directories("/usr/local/lib")
  # for multi-config builds (e.g. msvc,xcode)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/lib)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
  endforeach()
else()
  # Windows only support static build.
  set(BUILD_SHARED_LIBS OFF)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  # for multi-config builds (e.g. msvc,xcode)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/bin)
  endforeach()
  # Currently Only support static build for windows
  #include(swig)
endif()

# By default only the ortools C++ library is built.
option(BUILD_CXX "Build C++ library" ON)
option(BUILD_PYTHON "Build Python Library" OFF)
option(BUILD_JAVA "Build Java Library" OFF)
option(BUILD_DOTNET "Build .NET Library" OFF)
message(STATUS "Build C++ library: ${BUILD_CXX}")
message(STATUS "Build Python: ${BUILD_PYTHON}")
message(STATUS "Build Java: ${BUILD_JAVA}")
message(STATUS "Build .Net: ${BUILD_DOTNET}")

# By default all dependencies are NOT built (i.e. BUILD_DEPS=OFF).
# IF building any wrapper THEN Force BUILD_DEPS=ON
# IF BUILD_DEPS=ON THEN Force all BUILD_*=ON
include(CMakeDependentOption)
CMAKE_DEPENDENT_OPTION(BUILD_DEPS "Force re-build of all dependencies" OFF
  "NOT BUILD_PYTHON; NOT BUILD_JAVA; NOT BUILD_DOTNET" ON)

message(STATUS "Build all dependencies: ${BUILD_DEPS}")

# Build Needed dependencies
#add_subdirectory(cmake/dependencies dependencies)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR}/dependencies/install)

include(CTest)

include(cpp)

include(python)
include(java)
include(dotnet)
