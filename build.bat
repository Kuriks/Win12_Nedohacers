@echo off
title Windows 12 Builder
echo Creating Windows 12 Setup Package...

REM Создаем SFX архив через PowerShell
powershell -Command "Compress-Archive -Path Windows12_Setup.ps1, README.md -DestinationPath Windows12_Files.zip"

REM Создаем BAT файл который распаковывает и запускает
echo @echo off > Windows12_Setup.exe
echo echo Extracting Windows 12 Setup... >> Windows12_Setup.exe
echo powershell -Command "Expand-Archive -Path %%~f0 -DestinationPath %%temp%%\Win12Setup" >> Windows12_Setup.exe
echo cd /d "%%temp%%\Win12Setup" >> Windows12_Setup.exe
echo powershell -ExecutionPolicy Bypass -File Windows12_Setup.ps1 >> Windows12_Setup.exe

echo.
echo Build complete! File created: Windows12_Setup.exe
pause
