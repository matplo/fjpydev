add_library(mptools "")

target_sources(mptools
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/mptools/strutil.hh>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/mptools/aleph.hh>
    $<INSTALL_INTERFACE:include/mptools/strutil.hh>
    $<INSTALL_INTERFACE:include/mptools/aleph.hh>
  PRIVATE
    src/strutil.cc
    src/aleph.cc
)
target_include_directories(mptools
  PUBLIC
    $<BUILD_INTERFACE:${PYTHIA8_DIR}/include>
    $<BUILD_INTERFACE:${FASTJET_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(mptools PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER $<TARGET_PROPERTY:mptools,INTERFACE_SOURCES>
)

# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(mptools PROPERTIES
    INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(mptools PROPERTIES
    INSTALL_RPATH "$ORIGIN")
endif()

target_link_libraries(mptools
  PUBLIC
    # CMakeSwig::fastjet
    ${FASTJET_LIBS}
    # ${PYTHIA8_LDFLAGS}
)

#target_link_libraries(mptools PUBLIC...)
add_library(CMakeSwig::mptools ALIAS mptools)

# Install
include(GNUInstallDirs)
install(TARGETS mptools
  EXPORT CMakeSwigTargets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/mptools
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
