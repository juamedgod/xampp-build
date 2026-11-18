@echo off
cd /D %~dp0
echo FileZilla FTP Server is starting ... 
echo Starte FileZilla FTP Server ...

set "CURRENT_DIR=%cd%"

"FileZillaFTP\filezilla-server.exe" --config-dir "%CURRENT_DIR%\FileZillaFTP\config" &
