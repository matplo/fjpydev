if(NOT BUILD_CXX)
  return()
endif()

if(UNIX)
  message(STATUS "Building on a unix system")
  set(CMAKE_MACOSX_RPATH 1)
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
  # for gmp installed with brew
  if (EXISTS /usr/local/include AND EXISTS /usr/local/lib)
    include_directories("/usr/local/include" SYSTEM)
    link_directories("/usr/local/lib")
    message(STATUS "Assuming that /usr/local has the stuff from homebrew ...")
  endif()
else()
  message(STATUS "Building on non-unix system - that's fine.")
endif()

# add_subdirectory(fastjet)
add_subdirectory(recursivetools)
add_subdirectory(lundplane)
add_subdirectory(pythiafjtools)
add_subdirectory(mptools)

# Install
include(GNUInstallDirs)
install(EXPORT CMakeSwigTargets
  NAMESPACE CMakeSwig::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig
  COMPONENT Devel)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/CMakeSwigConfig.cmake.in
  "${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)
install(
  FILES
  "${PROJECT_BINARY_DIR}/CMakeSwigConfig.cmake"
  "${PROJECT_BINARY_DIR}/CMakeSwigConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/CMakeSwig"
  COMPONENT Devel)
