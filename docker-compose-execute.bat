@echo off
REM Execute docker compose command
docker compose --profile download up --build

REM Wait for the process to finish
:waitLoop
timeout /t 5 >nul
tasklist /FI "IMAGENAME eq docker-compose.exe" 2>NUL | find /I /N "docker-compose.exe">NUL
if "%ERRORLEVEL%"=="0" goto waitLoop

REM After the process is done, execute other commands if needed
REM For example:
echo Docker Compose process has finished.
echo Proceeding with other commands...
