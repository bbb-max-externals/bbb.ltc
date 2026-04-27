# cmake/bbb_external.cmake — bbb_add_external() 共通関数
#
# 各 external の CMakeLists.txt から呼び出す:
#   bbb_add_external()
#   bbb_add_external(DEPS ltc pthread)
#   bbb_add_external(MACOS_ONLY DEPS "-framework CoreServices")

function(bbb_add_external)
	cmake_parse_arguments(ARG
		"MACOS_ONLY;WIN32_ONLY;NO_HELP_COPY"
		"RPATH"
		"DEPS;INCLUDES;SOURCES"
		${ARGN}
	)

	# --- platform filter ---
	if(ARG_MACOS_ONLY AND NOT APPLE)
		message("Skipping ${PROJECT_NAME} (macOS only)")
		return()
	endif()
	if(ARG_WIN32_ONLY AND NOT WIN32)
		message("Skipping ${PROJECT_NAME} (Windows only)")
		return()
	endif()

	# --- find min-api ---
	if(NOT DEFINED C74_MIN_API_DIR)
		if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
			set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
		elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
			set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
		else()
			message(FATAL_ERROR "min-api not found. Add as git submodule: deps/min-api/")
		endif()
	endif()
	set(C74_MIN_API_DIR "${C74_MIN_API_DIR}" PARENT_SCOPE)

	# --- include pretarget (once) ---
	if(NOT C74_MIN_PRETARGET_INCLUDED)
		include(${C74_MIN_API_DIR}/script/min-pretarget.cmake)
		set(C74_MIN_PRETARGET_INCLUDED TRUE CACHE INTERNAL "")
	endif()

	# --- auto-glob sources if not specified ---
	if(NOT ARG_SOURCES)
		file(GLOB ARG_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
	endif()

	# --- shared headers ---
	set(SHARED_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../bbb")

	# --- derive unique target name from directory name ---
	get_filename_component(EXTERNAL_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

	# --- add library ---
	add_library(${EXTERNAL_NAME} MODULE ${ARG_SOURCES})

	# --- output directory ---
	set_target_properties(${EXTERNAL_NAME} PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY "${C74_LIBRARY_OUTPUT_DIRECTORY}"
	)

	# --- include directories ---
	target_include_directories(${EXTERNAL_NAME} PRIVATE
		${C74_MIN_API_DIR}/include
		${SHARED_INCLUDE_DIR}
		${ARG_INCLUDES}
	)

	# --- link libraries ---
	target_link_libraries(${EXTERNAL_NAME} PRIVATE ${ARG_DEPS})

	# --- RPATH ---
	if(ARG_RPATH)
		set_target_properties(${EXTERNAL_NAME} PROPERTIES
			BUILD_RPATH "${ARG_RPATH}"
			INSTALL_RPATH "${ARG_RPATH}"
		)
	endif()

	# --- include posttarget ---
	include(${C74_MIN_API_DIR}/script/min-posttarget.cmake)

	# --- help file copy ---
	if(NOT ARG_NO_HELP_COPY)
		file(GLOB HELP_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.maxhelp")
		foreach(HELP_FILE ${HELP_FILES})
			configure_file(${HELP_FILE} "${CMAKE_CURRENT_SOURCE_DIR}/../../../help/" COPYONLY)
		endforeach()
	endif()
endfunction()
