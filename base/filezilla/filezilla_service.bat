@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

if "%OS%" == "Windows_NT" setlocal
rem ---------------------------------------------------------------------------
rem NT Service Install/Uninstall script
rem
rem Options
rem install                Install the service using Tomcat as service name.
rem                        Service is installed using default settings.
rem remove                 Remove the service from the System.
rem
rem name        (optional) If the second argument is present it is considered
rem                        to be new service name
rem
rem $Id: service.bat 1000718 2010-09-24 06:00:00Z mturk $
rem ---------------------------------------------------------------------------

cd /D %~dp0
title %~0

set "CURRENT_DIR=%cd%"
set "EXECUTABLE=%CURRENT_DIR%\FileZillaFTP\filezilla-server.exe"



rem Set default Service name
set SERVICE_NAME=FileZilla
set PR_DISPLAYNAME=FileZilla Server

goto NEXT

:ENDERROR
exit 1

:NEXT

if "x%~1x" == "xx" goto displayUsage
set SERVICE_CMD=%~1
shift
if "x%~1x" == "xx" goto checkServiceCmd
:checkUser
if "x%~1x" == "x/userx" goto runAsUser
if "x%~1x" == "x--userx" goto runAsUser
set SERVICE_NAME=%~1
set PR_DISPLAYNAME=FileZilla Server %~1
shift
if "x%~1x" == "xx" goto checkServiceCmd
goto checkUser
:runAsUser
shift
if "x%~1x" == "xx" goto displayUsage
set SERVICE_USER=%~1
shift
runas /env /savecred /user:%SERVICE_USER% "%COMSPEC% /K \"%SELF%\" %SERVICE_CMD% %SERVICE_NAME%"
goto end
:checkServiceCmd
if /i %SERVICE_CMD% == install goto doInstall
if /i %SERVICE_CMD% == remove goto doRemove
if /i %SERVICE_CMD% == uninstall goto doRemove
echo Unknown parameter "%1"
:displayUsage
echo.
echo Usage: service.bat install/remove [service_name] [/user username]
goto end

:doRemove
rem Remove the service
sc.exe delete "%SERVICE_NAME%"
if not errorlevel 1 goto removed
echo Failed removing '%SERVICE_NAME%' service
goto end
:removed
echo The service '%SERVICE_NAME%' has been removed
goto end

:doInstall
rem Install the service
echo Installing the service '%SERVICE_NAME%' ...

rem Use the environment variables as an example
rem Each command line option is prefixed with PR_

set PR_DESCRIPTION=FileZilla Server - https://filezilla-project.org/
sc.exe create "%SERVICE_NAME%" binPath= "\"%EXECUTABLE%\" --config-dir \"%CURRENT_DIR%\FileZillaFTP\config\"" ^
  start= auto ^
  DisplayName= "%PR_DISPLAYNAME%"

if not errorlevel 1 goto installed
echo Failed installing '%SERVICE_NAME%' service
goto ENDERROR
:installed
rem Clear the environment variables. They are not needed any more.
set PR_DISPLAYNAME=
set PR_DESCRIPTION=

echo The service '%SERVICE_NAME%' has been installed.

:end
cd "%CURRENT_DIR%"

