@echo off
setlocal

pushd "%~dp0"

if not exist .\vcpkg (
  call git clone --depth 1 https://github.com/microsoft/vcpkg vcpkg
  if errorlevel 1 goto :fail
) else (
  pushd .\vcpkg
  call git pull --ff-only
  if errorlevel 1 goto :fail
  popd
)

call .\vcpkg\bootstrap-vcpkg.bat
if errorlevel 1 goto :fail

call .\vcpkg\vcpkg install openssl:x64-windows-static
if errorlevel 1 goto :fail
call .\vcpkg\vcpkg install openssl:x86-windows-static
if errorlevel 1 goto :fail
call .\vcpkg\vcpkg install openssl:arm64-windows-static
if errorlevel 1 goto :fail

if exist .\OpenSSL-Win32 rmdir /s /q .\OpenSSL-Win32
if exist .\OpenSSL-Win64 rmdir /s /q .\OpenSSL-Win64
if exist .\OpenSSL-Win64-ARM rmdir /s /q .\OpenSSL-Win64-ARM
if exist .\openssl-include rmdir /s /q .\openssl-include

mkdir .\OpenSSL-Win32
if errorlevel 1 goto :fail
mkdir .\OpenSSL-Win64
if errorlevel 1 goto :fail
mkdir .\OpenSSL-Win64-ARM
if errorlevel 1 goto :fail
mkdir .\openssl-include
if errorlevel 1 goto :fail
mkdir .\openssl-include\openssl
if errorlevel 1 goto :fail

xcopy /Y /I .\vcpkg\installed\x64-windows-static\lib\*.* .\OpenSSL-Win64\ >nul
if errorlevel 1 goto :fail
xcopy /Y /I .\vcpkg\installed\x64-windows-static\include\openssl\*.* .\openssl-include\openssl\ >nul
if errorlevel 1 goto :fail
xcopy /Y /I .\vcpkg\installed\x86-windows-static\lib\*.* .\OpenSSL-Win32\ >nul
if errorlevel 1 goto :fail
xcopy /Y /I .\vcpkg\installed\arm64-windows-static\lib\*.* .\OpenSSL-Win64-ARM\ >nul
if errorlevel 1 goto :fail

popd
exit /b 0

:fail
set EXIT_CODE=%errorlevel%
popd
exit /b %EXIT_CODE%
