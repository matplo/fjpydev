# - Locate HepMC library
# Defines:
#
#  HEPMC_FOUND
#  HEPMC_INCLUDE_DIR
#  HEPMC_INCLUDE_DIRS (not cached)
#  HEPMC_<component>_LIBRARY
#  HEPMC_LIBRARIES (not cached)
#  HEPMC_LIBRARY_DIRS (not cached)

find_path(HEPMC_INCLUDE_DIR HepMC/GenEvent.h HINTS $ENV{HEPMC_DIR}/include)
set(HEPMC_INCLUDE_DIRS ${HEPMC_INCLUDE_DIR})

if(NOT HepMC_FIND_COMPONENTS)
  set(HepMC_FIND_COMPONENTS HepMC)
endif()

foreach(component ${HepMC_FIND_COMPONENTS})
  find_library(HEPMC_${component}_LIBRARY NAMES HepMC${component} ${component} HINTS $ENV{HEPMC_DIR}/lib)
  list(APPEND HEPMC_LIBRARIES ${HEPMC_${component}_LIBRARY})
  get_filename_component(_comp_dir ${HEPMC_${component}_LIBRARY} PATH)
  list(APPEND HEPMC_LIBRARY_DIRS ${_comp_dir})
endforeach()

if(HEPMC_LIBRARY_DIRS)
  list(REMOVE_DUPLICATES HEPMC_LIBRARY_DIRS)
  set(HEPMC_LINK_LIBRARIES "-Wl,-rpath,${HEPMC_LIBRARY_DIRS} -L${HEPMC_LIBRARY_DIRS}")
  foreach(component ${HepMC_FIND_COMPONENTS})
  	  message(STATUS "- processing: ${component}")
  	  # execute_process ( COMMAND "basename ${component}" --prefix WORKING_DIRECTORY /tmp OUTPUT_VARIABLE LIBFILE OUTPUT_STRIP_TRAILING_WHITESPACE )
	  set(HEPMC_LINK_LIBRARIES "${HEPMC_LINK_LIBRARIES} -l${component}")
  endforeach()
endif()

# handle the QUIETLY and REQUIRED arguments and set HEPMC_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(HepMC DEFAULT_MSG HEPMC_INCLUDE_DIR HEPMC_LIBRARIES HEPMC_LINK_LIBRARIES)
