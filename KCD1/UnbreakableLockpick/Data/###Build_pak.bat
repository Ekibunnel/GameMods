@echo off

if /I "%CD%"=="C:\Windows" (
    echo Current path is C:\Windows. Exiting script...
    pause
    exit /b
)

for %%A in ("%~dp0..") do set "ZIP_NAME=%%~nxA"
for %%A in (.) do set "CurrentDirName=%%~nxA"

powershell -Command "Get-ChildItem -Path '.' -Exclude '*.bat', '*.pak', '%ZIP_NAME%.*' | Compress-Archive -DestinationPath '%ZIP_NAME%.zip' -Force"
move /Y %ZIP_NAME%.zip %ZIP_NAME%.pak >nul 2>&1 && (
    echo Created %CurrentDirName%\%ZIP_NAME%.pak
) || (
    echo Error could not create %CurrentDirName%\%ZIP_NAME%.pak
)