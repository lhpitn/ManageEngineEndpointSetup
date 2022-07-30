@ECHO OFF
rem cls
@setlocal enableextensions

GOTO INSTALLAGENT

@cd /d "%~dp0"
:README
	ECHO.
	ECHO ******************************************************************************
	ECHO.
	ECHO		ManageEngine Endpoint Central Remote Office Setup Wizard
	ECHO.
	ECHO This script will install the Endpoint Central agent in this computer and in the computers specified in the computernames.txt.You should have logged in as an administrator to install the Agent.
	ECHO.
	ECHO ******************************************************************************
	ECHO.
	ECHO.
	ECHO  1  - Install WAN Agent to client computers
	ECHO.
	ECHO  2  - Install WAN Agent in this computer
	ECHO.  
	ECHO  3  - Exit
	ECHO.
	:GETINPUT
	set INPUT=
	set /P INPUT=Enter the option: %=%
	IF "%INPUT%" == "1" GOTO INSTALLWANAGENT
	IF "%INPUT%" == "2" GOTO INSTALLAGENT
	IF "%INPUT%" == "3" GOTO :EOF
	IF "%INPUT%" == "q" GOTO :EOF
	if "%INPUT%"=="" GOTO README	
		
GOTO INVALID

:INSTALLAGENT
	
	msiexec  /quiet /i UEMSAgent.msi TRANSFORMS="UEMSAgent.mst" ENABLESILENT=yes REBOOT=ReallySuppress INSTALLSOURCE=Manual SERVER_ROOT_CRT="%cd%\DMRootCA-Server.crt" DS_ROOT_CRT="%cd%\DMRootCA.crt" /lv Agentinstalllog.txt 
	
	IF "%ERRORLEVEL%" == "0" GOTO AGENTINSTALLSUCCESS
	IF "%ERRORLEVEL%" == "3010" GOTO AGENTINSTALLSUCCESS
	IF "%ERRORLEVEL%" == "1603" GOTO AGENTINSTALLFAIL_FATAL
	IF "%ERRORLEVEL%" == "1612" GOTO AGENTINSTALLFAIL_FATAL
	IF "%ERRORLEVEL%" == "1619" GOTO AGENTINSTALLFAIL_UNZIP
	
GOTO AGENTINSTALLFAIL

:INSTALLWANAGENT
	
	ECHO.
	ECHO Please make sure you have logged in as admin user in this computer
	ECHO.
	start /B /wait dcremagentinstaller.exe "dssetup" "dc"
	IF "%ERRORLEVEL%" == "9059" GOTO AGENTINSTALLFAIL_UNZIP
GOTO SEELOGS

 :AGENTINSTALLFAIL_FATAL
 set ERROR=%ERRORLEVEL%
 ECHO.
 ECHO -----------------------------------------------------------------------------
 Msg %username% /TIME:0 /V /W "Please run setup.bat in 'Run as administrator' mode."
 ECHO.
 ECHO Endpoint Central Agent installation failed. ErrorCode: %ERROR%"
 net helpmsg %ERROR%
 ECHO -----------------------------------------------------------------------------
 GOTO ENDFILE
 
 :AGENTINSTALLFAIL_UNZIP
 set ERROR=%ERRORLEVEL%
 ECHO.
 ECHO -----------------------------------------------------------------------------
 Msg %username% /TIME:0 /V /W "Please Un-Zip/ Extract the contents and try running setup.bat." 
 ECHO Endpoint Central Agent installation failed. ErrorCode: %ERROR%"
 net helpmsg %ERROR%
 ECHO -----------------------------------------------------------------------------
 GOTO ENDFILE


:AGENTINSTALLSUCCESS
ECHO.
ECHO Endpoint Central Agent installed successfully.
ECHO.
GOTO ENDFILE

:AGENTINSTALLFAIL
ECHO.
ECHO -----------------------------------------------------------------------------
ECHO Endpoint Central Agent installation failed. ErrorCode: %ERRORLEVEL%
net helpmsg %ERRORLEVEL%
ECHO -----------------------------------------------------------------------------
GOTO ENDFILE

:INVALID
Msg %username% /TIME:0 /V /W "Please enter the valid option."
ECHO.
GOTO GETINPUT

:SEELOGS
ECHO.
ECHO See the logs.txt to verify the status of the installation of the WAN Agents.
GOTO ENDFILE

:ENDFILE
ECHO.
rem PAUSE