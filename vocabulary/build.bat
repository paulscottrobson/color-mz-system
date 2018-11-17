@echo off
python ..\scripts\buildwords.py 
copy __words.asm ..\kernel\temp
