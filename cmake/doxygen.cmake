#
# Check if docs generation is enabled
# Set variables and create gen-docs target
#
if(${PROJECT_NAME}_ENABLE_DOXYGEN)
    set(DOXYGEN_CALLER_GRAPH YES)
    set(DOXYGEN_CALL_GRAPH YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/doc)

    find_package(Doxygen REQUIRED dot)
    doxygen_add_docs(gen-docs ${PROJECT_SOURCE_DIR})

    message(STATUS "Doxygen has been setup and documentation is now available.")
endif()