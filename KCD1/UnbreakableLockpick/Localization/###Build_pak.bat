@echo off

if /I "%CD%"=="C:\Windows" (
    echo Current path is C:\Windows. Exiting script...
    pause
    exit /b
)

for %%A in (.) do set "CurrentDirName=%%~nxA"

for /d %%X in (*) do (
    powershell -Command "Get-ChildItem -Path '%%X' -Exclude '*.bat', '*.pak' | Compress-Archive -DestinationPath '%%X.zip' -Force"
    move /Y "%%X.zip" "%%X_xml.pak" >nul 2>&1 && (
        echo Created %CurrentDirName%\%%X_xml.pak
    ) || (
        echo Error could not create %CurrentDirName%\%%X_xml.pak
    )
)