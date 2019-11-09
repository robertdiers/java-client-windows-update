@echo OFF
echo Updateing %env% Client...
TITLE Updateing %env% Client...
FOR /F "tokens=*" %%i in ('type client.properties') do SET %%i
IF NOT EXIST bin\wget.exe GOTO FILEERROR
del Client_%env%.zip
ECHO Unsafe wget operation - no certificate check
bin\wget.exe --no-check-certificate %updateserver%Client_%env%.zip
IF NOT EXIST Client_%env%.zip GOTO DOWNLOADERROR
TITLE Extracting New %env% Client...
copy bin\unzipinitial.exe unzip.exe
IF NOT EXIST unzip.exe GOTO FILEERROR
del bin\*.* /s /f /q
del jre\*.* /s /f /q
del lib\*.* /s /f /q
del logs\*.* /s /f /q
unzip.exe -o Client_%env%.zip
del version.txt
copy serverversion.txt version.txt
ECHO Update done!
call StartClient.bat
GOTO END

:DOWNLOADERROR
ECHO.
ECHO ##### EXCEPTION #####
ECHO Environment: %env%
ECHO %updateserver%Client_%env%.zip not available
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
ECHO Update not possible!
IF NOT EXIST Client_%env%.zip ECHO Please reload client @ %updateserver%
IF EXIST Client_%env%.zip ECHO Please extract Client_%env%.zip
ECHO ##### EXCEPTION #####
ECHO.
pause

GOTO END

:END