cmake_minimum_required(VERSION 3.10)
project(lite.ai.toolkit)

set(CMAKE_CXX_STANDARD 11)
set(VERSION_STRING 0.1.1)
set(SOVERSION_STRING 0.1.1)

message(STATUS "Lite.AI.ToolKit  ${VERSION_STRING}")
message(STATUS "Project: lite.ai.toolkit")
message(STATUS "Version: ${VERSION_STRING}")
message(STATUS "SO Version: ${SOVERSION_STRING}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Root Path: ${CMAKE_SOURCE_DIR}")

# Linux GCC Compiler Options
if (CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-std=c++11 -Wno-deprecated ${CMAKE_CXX_FLAGS} ")
    message(STATUS "[Linux GCC Compiler Options]+:-std=c++11 -Wno-deprecated")
endif ()


# root dir
set(LITE_AI_ROOT_DIR ${CMAKE_SOURCE_DIR})
# set default build dir for lite.ai.toolkit
if (NOT DEFINED BUILD_LITE_AI_DIR)
    set(BUILD_LITE_AI_DIR ${LITE_AI_ROOT_DIR}/build/yolov3)
endif ()
set(LIBRARY_OUTPUT_PATH ${BUILD_LITE_AI_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${BUILD_LITE_AI_DIR}/bin)

# compile options for lite.ai.toolkit
option(LITE_AI_BUILD_LIB "build shared libraries." ON) # now, ON only
option(LITE_AI_BUILD_TEST "build test examples." ON)
option(INCLUDE_OPENCV "package OpenCV into lite.ai.toolkit." ON)
# inference engines setups: config.h.in -> config.h
option(ENABLE_ONNXRUNTIME "enable ONNXRuntime engine" ON)
# videoio interface setups, for future use
option(ENABLE_OPENCV_VIDEOIO "enable opencv videoio modules for detect_video apis" ON) # now, ON only
# inference engines backend setups for lite.ai.toolkit
option(BACKEND_ONNXRUNTIME "set ONNXRuntime as the main backend of lite.ai.toolkit" ON)

message(STATUS "Engines Enable Details ... ")
message(STATUS "INCLUDE_OPENCV: ${INCLUDE_OPENCV}")
message(STATUS "ENABLE_ONNXRUNTIME: ${ENABLE_ONNXRUNTIME}")

# setup include dir and lib dir
include_directories(${LITE_AI_ROOT_DIR}/include)
link_directories(${LITE_AI_ROOT_DIR}/lib)

# include custom cmake files.
include(cmake/setup_opencv_libs.cmake)
include(cmake/lite.ai.toolkit-cmd.cmake)

# configuration for lite.ai shared lib.
if (LITE_AI_BUILD_LIB)
    include(cmake/lite.ai.toolkit.cmake)
endif ()

# configuration for test examples.
if (LITE_AI_BUILD_LIB AND LITE_AI_BUILD_TEST)
    add_subdirectory(model)
    add_subdirectory(UI)
endif ()
