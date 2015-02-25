@echo off

if not defined WORKON_HOME (
    set "WORKON_HOME=%USERPROFILE%\Envs"
)

if not defined VIRTUALENVWRAPPER_PROJECT_FILENAME (
    set VIRTUALENVWRAPPER_PROJECT_FILENAME=.project
)

if [%1]==[] goto LIST
goto WORKON

:LIST
echo.
echo Pass a name to activate one of the following virtualenvs:
echo ==============================================================================
dir /b /ad "%WORKON_HOME%"
goto END

REM simple platform assumption
REM using only for checking for Scripts/bin difference
if exist "%~dp0..\pypy.exe" (
  set "SCRIPTS_FOLDER=bin"
) else (
  set "SCRIPTS_FOLDER=Scripts"
)


:WORKON
if defined VIRTUAL_ENV (
    call "%VIRTUAL_ENV%\%SCRIPTS_FOLDER%\deactivate.bat"
)

pushd "%WORKON_HOME%" 2>NUL && popd
if errorlevel 1 (
    mkdir "%WORKON_HOME%"
)

pushd "%WORKON_HOME%\%1" 2>NUL && popd
if errorlevel 1 (
    echo.
    echo.    virtualenv "%1" does not exist.
    echo.    Create it with "mkvirtualenv %1"
    goto END
)

if not exist "%WORKON_HOME%\%1\%SCRIPTS_FOLDER%\activate.bat" (
    echo.
    echo.    %WORKON_HOME%\%1
    echo.    doesn't contain a virtualenv ^(yet^).
    echo.    Create it with "mkvirtualenv %1"
    goto END
)

call "%WORKON_HOME%\%1\%SCRIPTS_FOLDER%\activate.bat"
if defined WORKON_OLDTITLE (
    title %1 ^(VirtualEnv^)
)

if exist "%WORKON_HOME%\%1\%VIRTUALENVWRAPPER_PROJECT_FILENAME%" (
    call cdproject.bat
) else (
    cd /d "%WORKON_HOME%\%1"
)

:END
