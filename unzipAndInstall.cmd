echo off

rem da das irgendwie nicht geht ist die vermutung das es sich halt nicht direkt vom netzlaufwerk (selbst mit pushd / popd) ausführen lässt hier mal als versuch mit per unzip lokal runterzukopieren und dann da zu starten...
cd %temp%

rem if exist C:\Program Files (x86)\DesktopCentral_Agent
SET MCS_ENDPOINT=DesktopCentral_Agent
IF NOT EXIST "%ProgramFiles(x86)%\%MCS_ENDPOINT%" GOTO INSTALL

rem else goto END..
echo "%ProgramFiles(x86)%\%MCS_ENDPOINT%" exist, exiting...
echo "%ProgramFiles(x86)%\%MCS_ENDPOINT%" exist, exiting... >> unzip.log
goto END

:INSTALL


md endpointSetup
cd endpointSetup
echo copying unzip*... >> unzip.log
echo copying unzip*...
copy \\{your_Domain or network path}\NETLOGON\EndpointCentralAgent\unzip* . >> unzip.log

unzip \\{your_Domain or network path}\NETLOGON\EndpointCentralAgent\directsetup.zip  >> unzip.log
echo unzip done, running setup.bat ... >> unzip.log
echo unzip done, running setup.bat ...
date /t >> unzip.log
time /t >> unzip.log

cd directsetup

start /WAIT /B  CMD /c setup.bat

cd ..

goto END

:END

date /t >> unzip.log
time /t >> unzip.log
echo done... >> unzip.log
rem pause
