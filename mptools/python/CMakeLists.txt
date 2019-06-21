set_property(SOURCE mptools.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE mptools.i PROPERTY SWIG_MODULE_NAME pymptools)
swig_add_library(pymptools
	TYPE SHARED
	LANGUAGE python
	OUTPUT_DIR ${CMAKE_BINARY_DIR}/python/${PROJECT_NAME}/mptools
	SOURCES	mptools.i)

add_compile_definitions(SWIG)

target_include_directories(pymptools
	PRIVATE
	${FASTJET_DIR}/include
	${PYTHON_INCLUDE_DIRS}
	)
set_property(TARGET pymptools PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)

# note: macOS is APPLE and also UNIX !
if(APPLE)
	set_target_properties(pymptools PROPERTIES
		SUFFIX ".so"
		INSTALL_RPATH	"@loader_path;@loader_path/../../${PROJECT_NAME}/.libs"
		)
	set_property(TARGET pymptools APPEND PROPERTY
		LINK_FLAGS "-flat_namespace -undefined suppress"
		)
elseif(UNIX)
	set_target_properties(pymptools PROPERTIES
    INSTALL_RPATH	"$ORIGIN:$ORIGIN/../../${PROJECT_NAME}/.libs"
		)
endif()

target_link_libraries(pymptools
	PRIVATE
	mptools
	# ${PYTHIA8_LDFLAGS}
	${PYTHON_LIBRARIES}
	)
