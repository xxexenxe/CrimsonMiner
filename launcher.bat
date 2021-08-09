@ECHO OFF
ECHO Currently running launcher version 0.5. Downloaded from: https://github.com/korekiyoshinguuji/Mine4Crimson/
ECHO Before closing the miner, make sure to save the logs to verify with Mommy later on.
ECHO Make sure to add the folder to exceptions in your antivirus settings.
ECHO Otherwise, the downloaded file may get flagged and removed before you know it.
ECHO Checking for autorun settings.
IF EXIST "%cd%\settings.crimson" (
  ECHO Found autorun settings.
  GOTO AUTORUNWAIT
) ELSE (
  ECHO No autorun settings found. Forwarding to the menu.
  GOTO DOWNLOAD
)

:AUTORUNWAIT
ECHO Input Y within 10 seconds to go to settings.
ECHO Input N or wait 10 seconds to autorun.
CHOICE /T 10 /C YN /D N
IF %ERRORLEVEL%==1 (
  GOTO DOWNLOAD
)
IF %ERRORLEVEL%==2 (
  GOTO AUTORUN
)

:AUTORUN
ECHO Searching for executable.
IF EXIST "%cd%\data\miner.exe" (
  ECHO Executable exists, attempting autorun.
  GOTO RUN
) ELSE (
  ECHO Despite autorun settings, the executable doesn't exist. Forwarding to the menu and resetting autorun settings.
  DEL settings.crimson
  IF EXIST "%cd%\nosettings.crimson" (
    DEL nosettings.crimson
  )
  GOTO DOWNLOAD
)

:DOWNLOAD
IF EXIST "%cd%\settings.crimson" (
  SET AUTORUNSETTING=ON
) ELSE (
  SET AUTORUNSETTING=OFF
)
IF EXIST "%cd%\nosettings.crimson" (
  SET NOAUTORUNSETTING=ON
) ELSE (
  SET NOAUTORUNSETTING=OFF
)
IF NOT EXIST "%cd%\data\miner.exe" (
  SET NOMINER=Miner not found, download it first.
) ELSE (
  SET NOMINER=Miner found.
)
IF EXIST "%cd%\workername.crimson" (
  CALL :READUSERNAME
) ELSE (
  SET MENUWORKERNAME=No name set.
)
ECHO -------------------------------------------------------------------------------------
ECHO 1 - Download the miner.
ECHO 2 - Switch autorun setting. (Currently: %AUTORUNSETTING%)
ECHO 3 - Change workername. (%MENUWORKERNAME%)
ECHO 4 - Attempt to run the miner. (%NOMINER%)
ECHO -------------------------------------------------------------------------------------
ECHO.
SET /P M=Type 1, 2, 3, or 4, then press ENTER:
IF %M%==1 GOTO ACTUALDOWNLOAD
IF %M%==2 GOTO SWITCHAUTORUN
IF %M%==3 GOTO CHANGEUSERNAME
IF %M%==4 GOTO RUN

:ACTUALDOWNLOAD
ECHO.
ECHO Downloading the CUDA miner, please wait...
%SYSTEMROOT%\SYSTEM32\bitsadmin.exe /rawreturn /nowrap /transfer starter /dynamic /download /priority foreground https://github.com/develsoftware/GMinerRelease/releases/download/2.62/gminer_2_62_windows64.zip "%cd%\package.zip"
GOTO UNPACK

:UNPACK
ECHO.
ECHO Unpacking the downloaded file, please wait...
IF NOT EXIST "%cd%\data" mkdir %cd%\data
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Expand-Archive package.zip -DestinationPath %cd%\\data\\ -Force"
GOTO DOWNLOAD

:SWITCHAUTORUN
IF EXIST "%cd%\settings.crimson" (
  DEL settings.crimson
) ELSE (
  copy /y NUL settings.crimson >NUL
)
GOTO DOWNLOAD

:SWITCHNOAUTORUN
IF EXIST "%cd%\nosettings.crimson" (
  DEL nosettings.crimson
) ELSE (
  copy /y NUL nosettings.crimson >NUL
)
GOTO DOWNLOAD

:RUN
IF NOT EXIST "%cd%\data\miner.exe" (
  ECHO Miner not found. Make sure to download the miner beforehand and to add the folder as an exception in your antivirus.
  ECHO Returning to the menu.
  GOTO DOWNLOAD
)
IF EXIST "%cd%\workername.crimson" (
  for /F "tokens=*" %%a in (%cd%\workername.crimson) do (
    ECHO Attempting to run the executable.
    ECHO Beginning the mining process under workername %%a.
    .\data\miner.exe --algo ethash --server eth.2miners.com:2020 --user 0x0aFc552f2e06C7BdFFa9A9A4c351E0F1E3453d3f.%%a
    PAUSE
    GOTO ENDOFFILE
  )
) ELSE (
  GOTO SETUSERNAME
)
PAUSE
GOTO ENDOFFILE

:SETUSERNAME
ECHO No workername found set.
ECHO Please set a workername that will be definitely identifiable. Feel free to use a Twitter handle (@Handle), Discord tag (YourTag#XXXX) or anything else that will surely lead Mommy to you for easy verification.
ECHO Choosing a workername that does not distinguish you from other workers may lead to you being unable to receive compensation for your mining.
SET /P id=Enter your workername:
echo %id% > workername.crimson
GOTO RUN

:READUSERNAME
for /F "tokens=*" %%b in (%cd%\workername.crimson) do (
  SET MENUWORKERNAME=%%b
)
GOTO :EOF

:CHANGEUSERNAME
SET /P id=Enter your new workername:
echo %id%> workername.crimson
GOTO DOWNLOAD

:ENDOFFILE
PAUSE
