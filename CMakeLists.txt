cmake_minimum_required(VERSION 3.15.0)

#
# Project details
#
project(
    cppkit
    VERSION 0.1.0
    LANGUAGES CXX
)

#
# cmake files include
#
include(cmake/compiler_warnings.cmake)
include(cmake/settings.cmake)
include(cmake/sources_headers.cmake)

#
# Set default build type (if not declared)
#
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()
message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")


#
# Add "-D_DEBUG" flag for debug build type under UNIX-like environments.
# This will allow to use the same _DEBUG macro in both Linux as well as Windows
# for debug specific code
#
if (UNIX)
    add_compile_options("$<$<CONFIG:DEBUG>:-D_DEBUG>")    #this will allow to use same _DEBUG macro available in both Linux as well as Windows - MSCV environment. Easy to put Debug specific code.
endif (UNIX)


#
# Setup alternative names (UPPERCASE and lowercase)
#
if(${PROJECT_NAME}_USE_ALT_NAMES)
    string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)
    message(STATUS "PROJECT_NAME_LOWERCASE: ${PROJECT_NAME_LOWERCASE}\r")
    message(STATUS "PROJECT_NAME_UPPERCASE: ${PROJECT_NAME_UPPERCASE}\n")
else()
    set(PROJECT_NAME_LOWERCASE ${PROJECT_NAME})
    set(PROJECT_NAME_UPPERCASE ${PROJECT_NAME})
    message(STATUS "PROJECT_NAME: ${PROJECT_NAME}\n")
endif()


#
# Prevent building in the source directory
#
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.\n")
endif()

#
# Include executable, headers and sources based on three options:
# 1. Executable
# 2. Headers Only
# 3. Library
#
if(${PROJECT_NAME}_BUILD_EXECUTABLE)
    add_executable(${PROJECT_NAME} ${exe_sources})

    message(STATUS "Found the following sources:")
    foreach(source IN LISTS exe_sources)
        message(STATUS "* ${source}")
    endforeach()

    if(${PROJECT_NAME}_ENABLE_UNIT_TESTING)
        add_library(${PROJECT_NAME}_LIB ${headers} ${sources})

        message(STATUS "Found the following headers:")
        foreach(header IN LISTS headers)
            message(STATUS "* ${header}")
        endforeach()
    endif()
    elseif(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
        add_library(${PROJECT_NAME} INTERFACE)

        message(STATUS "Found the following headers:")
        foreach(header IN LIST headers)
            message(STATUS "* ${header}")
        endforeach()
    else()
        add_library(
            ${PROJECT_NAME}
            ${headers}
            ${sources}
        ) 

    message(STATUS "Found the following sources:")
    foreach(source IN LISTS sources)
        message(STATUS "* ${source}")
    endforeach()
    message(STATUS "Found the following headers:")
    foreach(header IN LISTS headers)
        message(STATUS "* ${header}")
    endforeach()
endif()

message(STATUS "Added all header and implementation files.\n")


#
# Set project targets:
# 1. Archive files (.a .lib)
# 2. Shared libraries ().so .dll)
# 3. Executables
#
set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}"
)
if(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    set_target_properties(
        ${PROJECT_NAME}_LIB
        PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
        OUTPUT_NAME ${PROJECT_NAME}
    )
endif()


#
# Set the project standard and warnings
#
if(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
    target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_17)
else()
    target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_17)

    if(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
        target_compile_features(${PROJECT_NAME}_LIB PUBLIC cxx_std_17)
    endif()
endif()
set_project_warnings(${PROJECT_NAME})

message(STATUS "Applied compiler warnings. Using standard ${CMAKE_CXX_STANDARD}.\n")


# For Windows, it is necessary to link with the MultiThreaded library.
# Depending on how the rest of the project's dependencies are linked, it might be necessary
# to change the line to statically link with the library.
#
# This is done as follows:
#
# set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
#
# On Linux and Mac this variable is ignored. If any issues rise from it, try commenting it out
# and letting CMake decide how to link with it.
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")

message(STATUS "Successfully added all dependencies and linked against them.")


#
# Set the build/user include directories
# Allow usage of header files in the `src` directory, but only for utilities
#
if(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  target_include_directories(
    ${PROJECT_NAME}
    INTERFACE
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )
else()
  target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
  )
  if(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    target_include_directories(
      ${PROJECT_NAME}_LIB
      PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/src
    )
  endif()
endif()

message(STATUS "Finished setting up include directories.")
