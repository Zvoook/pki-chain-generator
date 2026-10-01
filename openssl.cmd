@echo off
setlocal
set "OPENSSL_BIN=C:\Program Files\Git\usr\bin\openssl.exe"
if not exist "%OPENSSL_BIN%" (
  echo OpenSSL not found: %OPENSSL_BIN% 1>&2
  exit /b 1
)
"%OPENSSL_BIN%" %*
exit /b %errorlevel%
