@echo off
call build.bat
python ..\scripts\cmzc.py
rem ..\bin\cspect.exe -zxnext -brk -esc -w3 ..\files\bootloader.sna