cmake_minimum_required(VERSION 3.15)
project(GoldMod C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(FATAL_ERROR "Игра 32-битная: собирай x86 (Visual Studio: cmake -A Win32 ..)")
endif()

set(IMGUI third_party/imgui)
set(MINHOOK third_party/minhook)

add_library(GoldMod SHARED
    src/main.cpp src/il2cpp.cpp src/game.cpp src/overlay.cpp

    ${IMGUI}/imgui.cpp ${IMGUI}/imgui_draw.cpp ${IMGUI}/imgui_tables.cpp ${IMGUI}/imgui_widgets.cpp
    ${IMGUI}/imgui_impl_win32.cpp ${IMGUI}/imgui_impl_dx11.cpp ${IMGUI}/imgui_impl_dx9.cpp

    ${MINHOOK}/src/buffer.c ${MINHOOK}/src/hook.c ${MINHOOK}/src/trampoline.c ${MINHOOK}/src/hde/hde32.c
)

target_include_directories(GoldMod PRIVATE src ${IMGUI} ${MINHOOK}/include)
target_link_libraries(GoldMod PRIVATE d3d11 d3d9 dxgi d3dcompiler gdi32 user32 imm32 dwmapi)
target_compile_definitions(GoldMod PRIVATE WIN32_LEAN_AND_MEAN NOMINMAX _CRT_SECURE_NO_WARNINGS)

if(MSVC)
    # статическая CRT — чтобы не требовать vcruntime в игре
    set_property(TARGET GoldMod PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded")
    target_compile_options(GoldMod PRIVATE /utf-8)
else()
    target_link_options(GoldMod PRIVATE -static -static-libgcc -static-libstdc++)
endif()

set_target_properties(GoldMod PROPERTIES PREFIX "")
