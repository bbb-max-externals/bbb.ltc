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

set(CMAKE_SUPPRESS_REGENERATION true)
