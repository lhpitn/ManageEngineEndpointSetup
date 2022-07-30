# ManageEngineEndpointSetup
Some modification to ManageEngine Endpoint bat (and a new one) to be able to auto install it (eg. via GPO), bad visual basic stuff didn't work at our site

## why the heck not the official way?

the vbs file gpo didnt work here, and while trying to use the setup.bat in a modified way with pushd/popd (to get it run from an UNC-Path) we got we got errors like this:


```
Endpoint Central Agent installation failed. ErrorCode: 1603

```

and that in the event viewer:
```
Product: ManageEngine Endpoint Central - Agent -- Error 1722. There is a problem with this Windows Installer package. A program run as part of the setup did not finish as expected. Contact your support personnel or package vendor. Action _7D73D36E_09A6_4568_8914_071BDC3EB653, location: C:\Program Files (x86)\DesktopCentral_Agent\bin\dcagentregister.exe, command: -i dc
```

you may also can work around other problems like vbs is blocked by security policies/av-software...


# how to set it up

1. download your deployment package from your endpoint system from like https://{your endpoint hostname/ip}:8383/webclient#/uems/agent/ds-deployment-help
  you should get a zip file containing an folder called "directsetup" containing some files including the setup.bat
  

2. replace the setup.bat (interactive version) with mine (modified to make it non interactive ) (maybe first check if it is similar or if your version got another setup.bat (my only modifications are, if i remember correctly , adding GOTO INSTALLAGENT at the top, removing start in front of msiexec and adding /quiet to it and removing/REMing the pause at the end...)

3. put the zip modified onto an share that everybody has read rights ( like \\{your_domain}\NETLOGON\EndpointCentralAgent )

4. modifie the path in line 22 and 23 of unzipAndInstall.cmd to match your desired path (would suggest the same as in step 3) 

5. copy the unzip* files and the modified unzipAndInstall.cmd to the location

6. get your devices to run that file as admin/system (however you like it), as group policy system level (not user) logon script, remote powershell, your old remote execution stuff, or anything else you like (we are using a group policy and the purpose of building this script was that the official suggested GPO didn't work reliable (only one laptop got it, others even test device did not))

## license: 
this mod is free to use for everyone (public domain) but if you improve it please send me an merge request or issue with your improvements or share it otherwise to the public (like GPL but you can brake it) ... NO WARRANTY OF ANY KIND IS GIVEN, but feel free to leave an issue if you got difficulty's setting it up..

