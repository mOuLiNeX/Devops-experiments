:: Windows 2008 R2 require KB3140245 hotfix
:: https://docs.microsoft.com/en-US/troubleshoot/windows-client/windows-7-eos-faq/troubleshoot-extended-security-updates-issues#any-activation-method
:: http://support.microsoft.com/kb/3140245

@echo off

@powershell -NoProfile -ExecutionPolicy Bypass -Command "((new-object net.webclient).DownloadFile('http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu', 'C:\Windows\Temp\windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu'))"

set hotfix="C:\Windows\Temp\windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
if not exist %hotfix% goto :eof

:: get windows version
for /f "tokens=2 delims=[]" %%G in ('ver') do (set _version=%%G)
for /f "tokens=2,3,4 delims=. " %%G in ('echo %_version%') do (set _major=%%G& set _minor=%%H& set _build=%%I)

:: 6.1
if %_major% neq 6 goto :eof
if %_minor% lss 1 goto :eof

@echo on
start /wait wusa "%hotfix%" /quiet /norestart
