@ECHO OFF

SET RELEASE=1.1.11

REM Full release with Sources and EXE
SET ZIP=QuickPutty-with-sources-%RELEASE%.zip
IF EXIST "%ZIP%" DEL /Q /F "%ZIP%"
7z a "%ZIP%" . -xr@.gitignore -xr!.git

REM Sources only
SET ZIP=QuickPutty-sources-only-%RELEASE%.zip
IF EXIST "%ZIP%" DEL /Q /F "%ZIP%"
7z a "%ZIP%" . -xr@.gitignore -xr!.git -xr!bin

REM Sources only
SET ZIP=QuickPutty-EXE-only-%RELEASE%.zip
IF EXIST "%ZIP%" DEL /Q /F "%ZIP%"
7z a "%ZIP%" . -xr@.gitignore -xr!.git -xr!src -x!*.GIF -x!*.BAT -x!.gitignore -x!*.md -x!*.TXT 
