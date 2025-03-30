#  Pico Build Action - Simple blink test program CMake config.
#  Copyright 2024 Samyar Sadat Akhavi
#  Written by Samyar Sadat Akhavi, 2024.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https: www.gnu.org/licenses/>.


# Set minimum required version of CMake
cmake_minimum_required(VERSION 3.12)

# Set Pico Board and Pico Platform
set(PICO_PLATFORM rp2350-arm-s)
set(PICO_BOARD pico2)

# Include build functions from the Pico SDK
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

# Set project name and C/C++ standards
string(TIMESTAMP DATEVER "%Y.%m.%d" UTC)
project(Blink VERSION ${DATEVER} LANGUAGES C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the Pico SDK
pico_sdk_init()

# Add source files
add_executable(${PROJECT_NAME} blink.c)

# Create map/bin/hex/uf2 files
pico_add_extra_outputs(${PROJECT_NAME})

# Link to libraries
target_link_libraries(${PROJECT_NAME} pico_stdlib)

# PicoTool binary information
pico_set_program_name(${PROJECT_NAME} ${PROJECT_NAME})
pico_set_program_version(${PROJECT_NAME} ${PROJECT_VERSION})
pico_set_program_description(${PROJECT_NAME} "Pico Build Action - Simple blink test program")

# CMake flags
set(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -ffunction-sections -fdata-sections")
set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -ffunction-sections -fdata-sections")