cmake_minimum_required(VERSION 3.20)
project(cpp_agent_forge_starter LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(cpp_agent_forge_starter src/main.cpp)
target_compile_options(cpp_agent_forge_starter PRIVATE -Wall -Wextra -Wpedantic)

enable_testing()
add_executable(cpp_agent_forge_smoke_test tests/smoke_test.cpp)
target_compile_options(cpp_agent_forge_smoke_test PRIVATE -Wall -Wextra -Wpedantic)
add_test(NAME cpp_agent_forge_smoke_test COMMAND cpp_agent_forge_smoke_test)
