@echo off
cd /D %~dp0
echo FileZilla FTP Server is stopping ... 
echo Stoppe FileZilla FTP Server ... 
@echo off
cd /D %~dp0
cmd.exe /C start "" /MIN call "@@XAMPP_INSTALLDIR@@\killprocess.bat" "filezilla-server.exe"
