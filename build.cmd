@echo off
setlocal
set name=AlphaStyle_1.0.0.zip

rem -----------------

mkdir build 2>nul
del build\%name% 2>nul
"%PROGRAMFILES%\7-Zip\7z.exe" a -r build\%name% AlphaStyle\*.* 
endlocal


