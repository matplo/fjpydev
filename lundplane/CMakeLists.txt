add_library(lundplane "")

target_sources(lundplane
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/LundPlane/LundGenerator.hh>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/LundPlane/LundJSON.hh>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/LundPlane/LundWithSecondary.hh>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/LundPlane/SecondaryLund.hh>

    $<INSTALL_INTERFACE:include/LundPlane/LundGenerator.hh>
    $<INSTALL_INTERFACE:include/LundPlane/LundJSON.hh>
    $<INSTALL_INTERFACE:include/LundPlane/LundWithSecondary.hh>
    $<INSTALL_INTERFACE:include/LundPlane/SecondaryLund.hh>

  PRIVATE
    src/LundGenerator.cc
    src/LundWithSecondary.cc
    src/SecondaryLund.cc
    # src/LundPlane/example.cc
    # src/LundPlane/example_secondary.cc
)
target_include_directories(lundplane
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/LundPlane>
    $<BUILD_INTERFACE:${FASTJET_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(lundplane PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER $<TARGET_PROPERTY:lundplane,INTERFACE_SOURCES>
)

# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(lundplane PROPERTIES
    INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(lundplane PROPERTIES
    INSTALL_RPATH "$ORIGIN")
endif()

target_link_libraries(lundplane
  PUBLIC
    # CMakeSwig::fastjet
    ${FASTJET_LIBS}
)

#target_link_libraries(lundplane PUBLIC...)
add_library(CMakeSwig::lundplane ALIAS lundplane)

# Install
include(GNUInstallDirs)
install(TARGETS lundplane
  EXPORT CMakeSwigTargets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/lundplane
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
