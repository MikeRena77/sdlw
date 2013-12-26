REM @ECHO OFF
SETLOCAL
REM ###########################################################################
REM # NAME:         unregocx.bat
REM #
REM # DESCRIPTION: Un-registers all Nucleus base and application ocx files by
REM #  reading the ocx.lst and ocxappl.lst files.
REM #
REM ###########################################################################

IF [%1]==[] GOTO missingparam

IF [%2]==[] GOTO missingparam

SET APPL=%~1

SET BASE=%~2

SET BASEREGPATH=%2\TARGET\OCX

ECHO %BASEREGPATH%

IF NOT EXIST %BASEREGPATH% GOTO basepathnotfound

SET APPLREGPATH=%1\TARGET\OCX

ECHO %APPLREGPATH%

IF NOT EXIST %APPLREGPATH% GOTO applpathnotfound

SET BASEREGLIST="%BASE%\IPT\OCX\ocx.lst"

ECHO %BASEREGLIST%

IF NOT EXIST %BASEREGLIST% GOTO baselistnotfound

SET APPLREGLIST="%APPL%\IPT\OCX\ocxappl.lst"

ECHO %APPLREGLIST%

IF NOT EXIST %APPLREGLIST% GOTO appllistnotfound

REM # Read file names from the .lst file; the "eol=#" option means ignore
REM # lines beginning with that character. Don't stop on errors, but output
REM # a message and continue.

ECHO %APPLREGLIST%

FOR /F "usebackq eol=#" %%G IN (%BASEREGLIST%) DO (
 ECHO %BASEREGPATH%\%%G
 regsvr32 /u /s /c %BASEREGPATH%\%%G
 IF ERRORLEVEL 1 ( ECHO -- Error: %BASEREGPATH%\%%G
  ) ELSE ( ECHO %BASEREGPATH%\%%G ) )


FOR /F "usebackq eol=#" %%G IN ( %APPLREGLIST% ) DO (
 ECHO %APPLREGPATH%\%%G
 regsvr32 /u /s /c %APPLREGPATH%\%%G
 IF ERRORLEVEL 1 ( ECHO -- Error: %APPLREGPATH%\%%G
  ) ELSE ( ECHO %APPLREGPATH%\%%G ) )




:successexit
 ECHO.
 ECHO Un-register OCX Success
 GOTO silentexit

:missingparam
 ECHO.
 ECHO Error: The path parameter is missing
 GOTO errorexit

:basepathnotfound
 ECHO.
 ECHO Error: The path %BASEREGPATH% was not found
 GOTO errorexit

:applpathnotfound
 ECHO.
 ECHO Error: The path %APPLREGPATH% was not found
 GOTO errorexit
 
:baselistnotfound
 ECHO.
 ECHO Error: The list file %BASEREGLIST% was not found
 GOTO errorexit
 
:appllistnotfound
 ECHO.
 ECHO Error: The list file %APPLREGLIST% was not found
 GOTO errorexit

:errorexit
 ECHO.
 ECHO Un-register OCX FAILED

:silentexit
 ENDLOCAL
