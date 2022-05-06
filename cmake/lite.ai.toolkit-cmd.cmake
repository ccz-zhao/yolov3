# config lite.ai shared lib.
function(add_lite_ai_toolkit_shared_library version soversion)
    

    # 2. glob headers files
    file(GLOB LITE_HEAD ${LITE_AI_ROOT_DIR}/include/lite/*.h)

    # 3. glob sources files
    file(GLOB LITE_SRCS ${LITE_AI_ROOT_DIR}/include/lite/*.cpp)
    message(STATUS "LITE_SRCS: ${LITE_AI_ROOT_DIR}/include/lite/")
    set(LITE_DEPENDENCIES ${OpenCV_LIBS})

    if (ENABLE_ONNXRUNTIME)
        include(cmake/lite.ai.toolkit-onnxruntime.cmake)
        set(LITE_SRCS ${LITE_SRCS} ${ORT_SRCS})
        set(LITE_DEPENDENCIES ${LITE_DEPENDENCIES} onnxruntime)
    endif()

    # 4. shared library
    add_library(lite.ai.toolkit SHARED ${LITE_SRCS})
    target_link_libraries(lite.ai.toolkit ${LITE_DEPENDENCIES})
    set_target_properties(lite.ai.toolkit PROPERTIES VERSION ${version} SOVERSION ${soversion})

    message("Installing Lite.AI.ToolKit Headers ...")
    file(INSTALL ${LITE_HEAD} DESTINATION ${BUILD_LITE_AI_DIR}/include/lite)

    message(">>>> Added Shared Library: lite.ai.toolkit !")

endfunction()

# add custom command for lite.ai shared lib.
function(add_lite_ai_toolkit_engines_headers_command)
    add_custom_command(TARGET lite.ai.toolkit
            PRE_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${EXECUTABLE_OUTPUT_PATH}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${LIBRARY_OUTPUT_PATH}
            COMMAND ${CMAKE_COMMAND} -E echo "Preparing  ${LIBRARY_OUTPUT_PATH} ... done!"
            COMMAND ${CMAKE_COMMAND} -E echo "Preparing  ${EXECUTABLE_OUTPUT_PATH} ... done!"
            )

    # copy opencv2 headers
    if (INCLUDE_OPENCV)
        add_custom_command(TARGET lite.ai.toolkit
                PRE_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory ${BUILD_LITE_AI_DIR}/include/opencv2
                )
        add_custom_command(TARGET lite.ai.toolkit
                PRE_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${LITE_AI_ROOT_DIR}/include/opencv2 ${BUILD_LITE_AI_DIR}/include/opencv2
                COMMAND ${CMAKE_COMMAND} -E echo "Installing opencv2 headers to ${BUILD_LITE_AI_DIR}/opencv2 ... done!"
                )
    endif()

    if (ENABLE_ONNXRUNTIME)
        add_custom_command(TARGET lite.ai.toolkit
                PRE_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory ${BUILD_LITE_AI_DIR}/include/onnxruntime
                )
        # copy onnxruntime headers
        add_custom_command(TARGET lite.ai.toolkit
                PRE_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${LITE_AI_ROOT_DIR}/include/onnxruntime ${BUILD_LITE_AI_DIR}/include/onnxruntime
                COMMAND ${CMAKE_COMMAND} -E echo "Installing onnxruntime headers to ${BUILD_LITE_AI_DIR}/include/onnxruntime ... done!"
                )

    endif()


endfunction()

function(add_lite_ai_toolkit_engines_libs_command)
    # copy opencv libs
    if (INCLUDE_OPENCV)
        message("Installing OpenCV libs        ->  INCLUDE_OPENCV:      ${INCLUDE_OPENCV} ...")
        file(GLOB ALL_OpenCV_LIBS ${LITE_AI_ROOT_DIR}/lib/*opencv*)
        file(GLOB FFMPEG_AV_LIBS ${LITE_AI_ROOT_DIR}/lib/*av*)
        file(GLOB FFMPEG_SW_LIBS ${LITE_AI_ROOT_DIR}/lib/*sw*)
        file(INSTALL ${ALL_OpenCV_LIBS} DESTINATION ${LIBRARY_OUTPUT_PATH})
        file(INSTALL ${FFMPEG_AV_LIBS} DESTINATION ${LIBRARY_OUTPUT_PATH})
        file(INSTALL ${FFMPEG_SW_LIBS} DESTINATION ${LIBRARY_OUTPUT_PATH})
    endif()
    # copy onnxruntime libs
    if (ENABLE_ONNXRUNTIME)
        message("Installing ONNXRuntime libs  ->  ENABLE_ONNXRUNTIME: ${ENABLE_ONNXRUNTIME} ...")
        file(GLOB ALL_ONNXRUNTIME_LIBS ${LITE_AI_ROOT_DIR}/lib/*onnxruntime*)
        file(INSTALL ${ALL_ONNXRUNTIME_LIBS} DESTINATION ${LIBRARY_OUTPUT_PATH})
    endif()
    
endfunction()

function(add_lite_ai_toolkit_test_custom_command)
    if (LITE_AI_BUILD_TEST)
        # copy opencv & lite.ai.toolkit & engines libs to bin directory
        add_custom_command(TARGET lite.ai.toolkit
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${LIBRARY_OUTPUT_PATH} ${EXECUTABLE_OUTPUT_PATH}
                COMMAND ${CMAKE_COMMAND} -E echo "Installing all lite.ai.toolkit libs to ${EXECUTABLE_OUTPUT_PATH} ... done!"
                )
    endif()
endfunction()

function(add_lite_executable executable_name field)
    add_executable(${executable_name} ${field}/test_${executable_name}.cpp)
    target_link_libraries(${executable_name} lite.ai.toolkit)  # link lite.ai.toolkit
    message(">>>> Added Lite Executable: ${executable_name} !")
endfunction ()
