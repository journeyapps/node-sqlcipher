call git clone https://github.com/microsoft/vcpkg vcpkg
call .\vcpkg\bootstrap-vcpkg.bat

.\vcpkg\vcpkg install openssl:x64-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%
.\vcpkg\vcpkg install openssl:x86-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%
.\vcpkg\vcpkg install openssl:arm64-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%

if not exist .\openssl-windows mkdir .\openssl-windows .\openssl-windows\OpenSSL-Win64 .\openssl-windows\OpenSSL-Win32 .\openssl-windows\OpenSSL-Win64-ARM .\openssl-windows\openssl-include\openssl

copy .\vcpkg\installed\x64-windows-static\lib\*.* .\openssl-windows\OpenSSL-Win64
copy .\vcpkg\installed\x64-windows-static\include\openssl\*.* .\openssl-windows\openssl-include\openssl
copy .\vcpkg\installed\x86-windows-static\lib\*.* .\openssl-windows\OpenSSL-Win32
copy .\vcpkg\installed\arm64-windows-static\lib\*.* .\openssl-windows\OpenSSL-Win64-ARM
