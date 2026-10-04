@echo off
cmake -S . -B build -A Win32 && cmake --build build --config Release
echo.
echo DLL: build\Release\GoldMod.dll
pause
