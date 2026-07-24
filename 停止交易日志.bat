@echo off
title 停止交易日志系统

set PORT=8897
set KILLED=0

echo ========================================
echo   停止交易日志系统
echo ========================================
echo.

echo 正在查找运行中的服务...

REM 主策略：按端口 8897 找 LISTENING 的 PID
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT% ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
    set KILLED=1
)

REM 备用策略：按进程名 交易日志系统.exe 匹配
for /f "tokens=2 delims=," %%a in ('wmic process where "name='交易日志系统.exe'" get processid /format:csv 2^>nul ^| findstr /r "[0-9]"') do (
    taskkill /F /PID %%a >nul 2>&1
    set KILLED=1
)

if "%KILLED%"=="1" (
    echo.
    echo ========================================
    echo   服务已停止
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   未发现运行中的服务
    echo ========================================
)

ping 127.0.0.1 -n 3 >nul
