@echo off
setlocal
cd /d "%~dp0"
set "PATH=C:\Program Files\Git\usr\bin;%PATH%"
if not exist "C:\Program Files\Git\usr\bin\openssl.exe" (
  echo OpenSSL is missing. 1>&2
  exit /b 1
)
if not exist "do_it.bat" (
  echo Put the teacher's do_it.bat and .cnf file in this directory first. 1>&2
  exit /b 2
)
call do_it.bat
exit /b %errorlevel%
