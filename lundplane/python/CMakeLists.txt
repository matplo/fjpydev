set_property(SOURCE lundplane.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE lundplane.i PROPERTY SWIG_MODULE_NAME pylundplane)
swig_add_library(pylundplane
	TYPE SHARED
	LANGUAGE python
	OUTPUT_DIR ${CMAKE_BINARY_DIR}/python/${PROJECT_NAME}/LundPlane
	SOURCES	lundplane.i)

add_compile_definitions(SWIG)

target_include_directories(pylundplane
	PRIVATE
	${FASTJET_DIR}/include
	${PYTHON_INCLUDE_DIRS}
	)
set_property(TARGET pylundplane PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)

# note: macOS is APPLE and also UNIX !
if(APPLE)
	set_target_properties(pylundplane PROPERTIES
		SUFFIX ".so"
		INSTALL_RPATH	"@loader_path;@loader_path/../../${PROJECT_NAME}/.libs"
		)
	set_property(TARGET pylundplane APPEND PROPERTY
		LINK_FLAGS "-flat_namespace -undefined suppress"
		)
elseif(UNIX)
	set_target_properties(pylundplane PROPERTIES
    INSTALL_RPATH	"$ORIGIN:$ORIGIN/../../${PROJECT_NAME}/.libs"
		)
endif()

target_link_libraries(pylundplane
	PRIVATE
	lundplane
	${FASTJET_LIBS}
	${PYTHON_LIBRARIES}
	)
