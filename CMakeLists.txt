cmake_minimum_required(VERSION 3.19)
project(bbb.ltc)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- load bbb_add_external() ---
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/bbb_external.cmake)

# --- output directory ---
set(C74_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/externals)

# --- universal binary (macOS) ---
if(APPLE AND NOT CMAKE_OSX_ARCHITECTURES)
	set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "macOS architecture" FORCE)
endif()

# --- libltc (git submodule, no CMakeLists.txt) ---
set(LIBLTC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc)
add_library(ltc STATIC
	${LIBLTC_DIR}/src/decoder.c
	${LIBLTC_DIR}/src/encoder.c
	${LIBLTC_DIR}/src/ltc.c
	${LIBLTC_DIR}/src/timecode.c
)
target_include_directories(ltc PUBLIC ${LIBLTC_DIR}/src)

# --- auto-discover external projects ---
MACRO(SUBDIRLIST result curdir)
	FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
	SET(dirlist "")
	FOREACH(child ${children})
		IF(IS_DIRECTORY ${curdir}/${child})
			LIST(APPEND dirlist ${child})
		ENDIF()
	ENDFOREACH()
	SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(PROJECT_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/source/projects)
foreach(project_dir ${PROJECT_DIRS})
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/source/projects/${project_dir}/CMakeLists.txt")
		message("Generating: ${project_dir}")
		add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/source/projects/${project_dir})
	endif()
endforeach()

option(BBB_LTC_BUILD_TESTS "Build bbb.ltc tests" OFF)

if(BBB_LTC_BUILD_TESTS)
	enable_testing()
	set(CMAKE_EXE_LINKER_FLAGS "")
	foreach(config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
		set(CMAKE_EXE_LINKER_FLAGS_${config} "")
	endforeach()
	add_executable(bbb_ltc_timecode_tests tests/timecode_tests.cpp)
	target_include_directories(bbb_ltc_timecode_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/source)
	add_test(NAME bbb_ltc_timecode_tests COMMAND bbb_ltc_timecode_tests)
endif()

set(CMAKE_SUPPRESS_REGENERATION true)
