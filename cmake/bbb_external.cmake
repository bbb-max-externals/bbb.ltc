# cmake/bbb_external.cmake — bbb_add_external() 共通関数
#
# 各 external の CMakeLists.txt から呼び出す:
#   bbb_add_external()
#   bbb_add_external(DEPS ltc)
#   bbb_add_external(MACOS_ONLY DEPS "-framework CoreServices")
#
# min-api の pretarget/posttarget スクリプトは project() 呼び出しを前提としており、
# サブディレクトリ構造と相性が悪いため、必要な設定のみ自前で行う。

function(bbb_add_external)
	cmake_parse_arguments(ARG
		"MACOS_ONLY;WIN32_ONLY;NO_HELP_COPY"
		"RPATH"
		"DEPS;INCLUDES;SOURCES"
		${ARGN}
	)

	# --- platform filter ---
	if(ARG_MACOS_ONLY AND NOT APPLE)
		message("Skipping ${EXTERNAL_NAME} (macOS only)")
		return()
	endif()
	if(ARG_WIN32_ONLY AND NOT WIN32)
		message("Skipping ${EXTERNAL_NAME} (Windows only)")
		return()
	endif()

	# --- find min-api (once) ---
	if(NOT DEFINED C74_MIN_API_DIR)
		if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
			set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
		elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
			set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
		else()
			message(FATAL_ERROR "min-api not found. Add as git submodule: deps/min-api/")
		endif()
		set(C74_MIN_API_DIR "${C74_MIN_API_DIR}" CACHE INTERNAL "")
	endif()

	# --- derive SDK paths ---
	set(C74_MAX_SDK_DIR "${C74_MIN_API_DIR}/max-sdk-base")
	set(C74_SUPPORT_DIR "${C74_MAX_SDK_DIR}/c74support")
	set(MAX_SDK_INCLUDES "${C74_SUPPORT_DIR}/max-includes")
	set(MAX_SDK_MSP_INCLUDES "${C74_SUPPORT_DIR}/msp-includes")
	set(MAX_SDK_JIT_INCLUDES "${C74_SUPPORT_DIR}/jit-includes")

	# --- output directory ---
	if(NOT DEFINED C74_LIBRARY_OUTPUT_DIRECTORY)
		set(C74_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../../externals")
		set(C74_LIBRARY_OUTPUT_DIRECTORY "${C74_LIBRARY_OUTPUT_DIRECTORY}" CACHE INTERNAL "")
	endif()

	# --- auto-glob sources if not specified ---
	if(NOT ARG_SOURCES)
		file(GLOB ARG_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
	endif()

	# --- shared headers ---
	set(SHARED_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../bbb")

	# --- derive unique target name from directory name ---
	get_filename_component(EXTERNAL_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

	# --- Apple: Universal Binary ---
	if(APPLE AND CMAKE_OSX_ARCHITECTURES STREQUAL "")
		set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
	endif()

	# --- add library ---
	add_library(${EXTERNAL_NAME} MODULE ${ARG_SOURCES})

	# --- C++17 ---
	set_property(TARGET ${EXTERNAL_NAME} PROPERTY CXX_STANDARD 17)
	set_property(TARGET ${EXTERNAL_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

	# --- output name = directory name (no lib prefix) ---
	set_target_properties(${EXTERNAL_NAME} PROPERTIES
		OUTPUT_NAME "${EXTERNAL_NAME}"
		PREFIX ""
	)
	# macOS: .mxo bundle → LIBRARY_OUTPUT_DIRECTORY
	# Windows: .mxe64 → RUNTIME_OUTPUT_DIRECTORY
	# Both: set all output dirs to the same path
	set_target_properties(${EXTERNAL_NAME} PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY "${C74_LIBRARY_OUTPUT_DIRECTORY}"
		LIBRARY_OUTPUT_DIRECTORY_RELEASE "${C74_LIBRARY_OUTPUT_DIRECTORY}"
		LIBRARY_OUTPUT_DIRECTORY_DEBUG "${C74_LIBRARY_OUTPUT_DIRECTORY}"
		RUNTIME_OUTPUT_DIRECTORY "${C74_LIBRARY_OUTPUT_DIRECTORY}"
		RUNTIME_OUTPUT_DIRECTORY_RELEASE "${C74_LIBRARY_OUTPUT_DIRECTORY}"
		RUNTIME_OUTPUT_DIRECTORY_DEBUG "${C74_LIBRARY_OUTPUT_DIRECTORY}"
	)

	# --- macOS bundle (.mxo) ---
	if(APPLE)
		set_property(TARGET ${EXTERNAL_NAME} PROPERTY BUNDLE True)
		set_property(TARGET ${EXTERNAL_NAME} PROPERTY BUNDLE_EXTENSION "mxo")
		set_target_properties(${EXTERNAL_NAME} PROPERTIES
			XCODE_ATTRIBUTE_WRAPPER_EXTENSION "mxo"
			MACOSX_BUNDLE_INFO_PLIST "${C74_MAX_SDK_DIR}/script/Info.plist.in"
		)

		# link MaxAudioAPI & JitterAPI
		find_library(MSP_LIBRARY "MaxAudioAPI"
			PATHS "${MAX_SDK_MSP_INCLUDES}" REQUIRED NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
		find_library(JITTER_LIBRARY "JitterAPI"
			PATHS "${MAX_SDK_JIT_INCLUDES}" REQUIRED NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
		target_link_libraries(${EXTERNAL_NAME} PUBLIC ${MSP_LIBRARY} ${JITTER_LIBRARY})

		# linker flags from max-sdk-base
		file(STRINGS "${C74_MAX_SDK_DIR}/script/max-linker-flags.txt" C74_SYM_MAX_LINKER_FLAGS)
		set_target_properties(${EXTERNAL_NAME} PROPERTIES
			LINK_FLAGS "${C74_SYM_MAX_LINKER_FLAGS}"
		)

		# code signing
		option(MAX_SDK_CODESIGN_EXTERNS "Sign macos externs during build" ON)
		if(MAX_SDK_CODESIGN_EXTERNS)
			add_custom_command(TARGET ${EXTERNAL_NAME} POST_BUILD
				COMMAND codesign -s - -f --deep $<TARGET_BUNDLE_DIR:${EXTERNAL_NAME}> 2>/dev/null
				COMMENT "Code signing with ad-hoc identity"
			)
		endif()

		# PkgInfo
		add_custom_command(TARGET ${EXTERNAL_NAME} POST_BUILD
			COMMAND cp "${C74_MAX_SDK_DIR}/script/PkgInfo"
				"${C74_LIBRARY_OUTPUT_DIRECTORY}/${EXTERNAL_NAME}.mxo/Contents/PkgInfo"
			VERBATIM
			COMMENT "Copy PkgInfo"
		)

		# deployment target
		set(CMAKE_OSX_DEPLOYMENT_TARGET "10.11" CACHE STRING "Minimum OS X deployment version" FORCE)
	endif()

	# --- Windows (.mxe64) ---
	if(WIN32)
		set_target_properties(${EXTERNAL_NAME} PROPERTIES SUFFIX ".mxe64")

		# link Max SDK libraries (static .lib)
		set(MaxAPI_LIB "${MAX_SDK_INCLUDES}/x64/MaxAPI.lib")
		set(MaxAudio_LIB "${MAX_SDK_MSP_INCLUDES}/x64/MaxAudio.lib")
		set(Jitter_LIB "${MAX_SDK_JIT_INCLUDES}/x64/jitlib.lib")
		target_link_libraries(${EXTERNAL_NAME} PUBLIC ${MaxAPI_LIB} ${MaxAudio_LIB} ${Jitter_LIB})

		# Windows definitions
		target_compile_definitions(${EXTERNAL_NAME} PRIVATE
			MAXAPI_USE_MSCRT
			WIN_VERSION
			_USE_MATH_DEFINES
		)
	endif()

	# --- include directories ---
	target_include_directories(${EXTERNAL_NAME} PRIVATE
		${C74_MIN_API_DIR}/include
		${MAX_SDK_INCLUDES}
		${MAX_SDK_MSP_INCLUDES}
		${MAX_SDK_JIT_INCLUDES}
		${MAX_SDK_INCLUDES}/..
		${SHARED_INCLUDE_DIR}
		${ARG_INCLUDES}
	)

	# --- compile definitions ---
	target_compile_definitions(${EXTERNAL_NAME} PRIVATE DC74_MIN_API)

	# --- link libraries ---
	target_link_libraries(${EXTERNAL_NAME} PRIVATE ${ARG_DEPS})

	# --- RPATH ---
	if(ARG_RPATH)
		set_target_properties(${EXTERNAL_NAME} PROPERTIES
			BUILD_RPATH "${ARG_RPATH}"
			INSTALL_RPATH "${ARG_RPATH}"
		)
	endif()

	# --- help file copy ---
	if(NOT ARG_NO_HELP_COPY)
		file(GLOB HELP_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.maxhelp")
		foreach(HELP_FILE ${HELP_FILES})
			configure_file(${HELP_FILE} "${CMAKE_CURRENT_SOURCE_DIR}/../../../help/" COPYONLY)
		endforeach()
	endif()
endfunction()
