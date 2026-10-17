@echo off

if /I "%CD%"=="C:\Windows" (
    echo Current path is C:\Windows. Exiting script...
    pause
    exit /b
)

if exist "Data\" (
    cd "Data\"
    del /f /q "*.pak"
    call .\###Build_pak.bat
    cd ..
    echo --- Data .pak regenerated
) else (
    echo Folder "Data" not found
)

if exist "Localization\" (
    cd "Localization\"
    del /f /q "*.pak"
    call .\###Build_pak.bat
    cd ..
    echo --- Localization .pak regenerated
) else (
    echo Folder "Localization" not found
)

pause