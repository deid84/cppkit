set(sources
    src/cli.cpp
)

set(exe_sources
	src/main.cpp
	${sources}
)

set(headers
    include/${PROJECT_NAME}/cli.hpp
)

set(test_sources
    src/cli_test.cpp
)