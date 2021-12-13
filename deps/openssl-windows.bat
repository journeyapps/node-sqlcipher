call git clone https://github.com/microsoft/vcpkg vcpkg
call .\vcpkg\bootstrap-vcpkg.bat

.\vcpkg\vcpkg install openssl:x64-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%
.\vcpkg\vcpkg install openssl:x86-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%
.\vcpkg\vcpkg install openssl:arm64-windows-static
if %errorlevel% neq 0 exit /b %errorlevel%

if not exist .\OpenSSL-Win32 mkdir .\OpenSSL-Win32
if not exist .\OpenSSL-Win64 mkdir .\OpenSSL-Win64
if not exist .\OpenSSL-Win64-ARM mkdir .\OpenSSL-Win64-ARM
if not exist .\openssl-include mkdir .\openssl-include

copy .\vcpkg\installed\x64-windows-static\lib\*.* .\OpenSSL-Win64
copy .\vcpkg\installed\x64-windows-static\include\openssl\*.* .\openssl-include\openssl
copy .\vcpkg\installed\x86-windows-static\lib\*.* .\OpenSSL-Win32
copy .\vcpkg\installed\arm64-windows-static\lib\*.* .\OpenSSL-Win64-ARM
