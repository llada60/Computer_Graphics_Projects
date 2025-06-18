cmake_minimum_required(VERSION 3.0)

SET(CMAKE_EXPORT_COMPILE_COMMANDS 1)
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

project(tpShadow)

add_executable(
  tpShadow
  src/main.cpp
  src/Error.cpp
  src/Mesh.cpp
  src/ShaderProgram.cpp)


add_subdirectory(dep/glad)
target_link_libraries(${PROJECT_NAME} PRIVATE glad)

if(NOT EXISTS "dep/glfw")
  find_package(glfw3 REQUIRED)
else()
  add_subdirectory(dep/glfw)
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE glfw)

if(NOT EXISTS "dep/glm")
  find_package(glm REQUIRED)
  if(GLM_FOUND)
    include_directories("${GLM_INCLUDE_DIR}")
  endif()
else()
  add_subdirectory(dep/glm)
  target_link_libraries(${PROJECT_NAME} PRIVATE glm)
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_DL_LIBS})

add_custom_command(TARGET tpShadow
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:tpShadow> ${CMAKE_CURRENT_SOURCE_DIR})
