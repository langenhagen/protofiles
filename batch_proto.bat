rem Batch file stuff

rem ------------------------------------------------------------------------------------------------
rem rem is for comments

rem ------------------------------------------------------------------------------------------------
rem run a command form outside a command shell
cmd /c
cmd.exe /c

rem ------------------------------------------------------------------------------------------------
rem `set -x` equivalent
@echo on
rem `set +x` equivalent
@echo off

rem ------------------------------------------------------------------------------------------------
rem Navigating directories

cd my\folder
cd C:\my\folder

pushd my/folder
popd

rem ------------------------------------------------------------------------------------------------
rem call a batch script from inside another batch script
rem You can omit the .bat suffix

call myscript.bat
call myscript

rem ------------------------------------------------------------------------------------------------
rem pause a batch script
rem often used at the end of a script to give the user time to read the output

rem Displays the message "Press any key to continue . . ."
pause

rem suppress the message
pause >nul

rem ------------------------------------------------------------------------------------------------
rem print stuff
echo Hello there!

rem ------------------------------------------------------------------------------------------------
rem PATH variable

SET PATH=%PATH%;C:\foo\spaces are allowed\without quotation marks
echo %PATH%

rem ------------------------------------------------------------------------------------------------
rem %cd$ is the $PWD equivalent

echo %cd%


rem ------------------------------------------------------------------------------------------------
rem chaining

rem or
mkdir foo || echo Creating directory failed!
mkdir foo || exit /b 1

rem ------------------------------------------------------------------------------------------------
rem `ls` equivalent
dir
dir myfolder

rem ------------------------------------------------------------------------------------------------
rem Create a file
type nul > myfolder\\myfile.txt"

rem ------------------------------------------------------------------------------------------------
rem `cat` equivalent
type myfile

rem ------------------------------------------------------------------------------------------------
rem variables
set "myvar=mandi"

rem ------------------------------------------------------------------------------------------------
rem if
if not exist "%myvar%" (
    mkdir "%myvar%"
)

rem ------------------------------------------------------------------------------------------------
rem for

rem if /I: case insensitive
for %%I in ("%source_folder%\*.*") do (
    if /I not "%%~xI"==".txt" (
        copy "%%I" "%target_folder%\"
    )
)

rem ------------------------------------------------------------------------------------------------
rem delete files and folders

rem delete a file
del myfile

rem delete everything inside a folder, by default with interactive confirmation /Q: without interactive confirmation
del myfolder
del /Q myfolder

rem Delete a directory; by default directory must be empty, /S: remove tree; /Q: don't ask for confirmation
rmdir myemptyfolder
rmdir /Q /S myfolder

rem ------------------------------------------------------------------------------------------------
rem copy stuff

rem copies all files; copies also files without suffix; does not copy subfolders
copy ..\*.* ..\myfolder
