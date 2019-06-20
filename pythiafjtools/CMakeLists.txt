add_library(pythiafjtools "")

target_sources(pythiafjtools
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/PythiaFJTools/pyfjtools.hh>

    $<INSTALL_INTERFACE:include/PythiaFJTools/pyfjtools.hh>
  PRIVATE
    src/pyfjtools.cc
)
target_include_directories(pythiafjtools
  PUBLIC
    $<BUILD_INTERFACE:${PYTHIA8_DIR}/include>
    $<BUILD_INTERFACE:${FASTJET_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(pythiafjtools PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER $<TARGET_PROPERTY:pythiafjtools,INTERFACE_SOURCES>
)

# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(pythiafjtools PROPERTIES
    INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(pythiafjtools PROPERTIES
    INSTALL_RPATH "$ORIGIN")
endif()

target_link_libraries(pythiafjtools
  PUBLIC
    # CMakeSwig::fastjet
    ${FASTJET_LIBS}
    ${PYTHIA8_LDFLAGS}
)

#target_link_libraries(pythiafjtools PUBLIC...)
add_library(CMakeSwig::pythiafjtools ALIAS pythiafjtools)

# Install
include(GNUInstallDirs)
install(TARGETS pythiafjtools
  EXPORT CMakeSwigTargets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/pythiafjtools
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
