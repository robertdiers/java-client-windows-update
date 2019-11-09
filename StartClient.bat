@echo OFF

set logpath=log
mkdir "%logpath%"

FOR /F "tokens=*" %%i in ('type client.properties') do SET %%i
echo Environment: %env%
echo Update: %update%
echo Updateserver: %updateserver%

if %update% EQU true GOTO UPDATE

:EXECUTION

TITLE Starting %env% Client...

set XX=lib\<your_jar>.jar

IF NOT EXIST jre\bin\java.exe GOTO FILEERROR
jre\bin\java ^
	-classpath %XX% ^
	-Xmx512m ^	
	<your_main_class>

rem pause

GOTO END

:DOWNLOADERROR
ECHO.
ECHO ##### EXCEPTION #####
ECHO Environment: %env%
ECHO %updateserver%serverversion.txt not available
ECHO Please try again later or enable firewall ports!
ECHO ##### EXCEPTION #####
ECHO.
pause

GOTO END

:FILEERROR
ECHO.
ECHO ##### EXCEPTION #####
ECHO Environment: %env%
ECHO bin/jre folder corrupt
ECHO Forcing an update!
ECHO Please press the Enter button...
ECHO ##### EXCEPTION #####
ECHO.
pause
IF NOT EXIST update.bat copy bin\updateinitial.bat update.bat
call update.bat %updateserver%

GOTO END

:UPDATE

TITLE Checking For Update...
IF NOT EXIST version.txt copy bin\versioninitial.txt version.txt
copy bin\updateinitial.bat update.bat
del serverversion.txt
IF NOT EXIST bin\wget.exe GOTO FILEERROR
bin\wget.exe --no-check-certificate %updateserver%serverversion.txt
IF NOT EXIST serverversion.txt GOTO DOWNLOADERROR
FOR /F "tokens=*" %%i in ('type serverversion.txt') do SET %%i
set serverversion=%version% 
FOR /F "tokens=*" %%i in ('type version.txt') do SET %%i
set clientversion=%version%
if %serverversion%==%clientversion% GOTO EXECUTION
call update.bat %updateserver%

:END



