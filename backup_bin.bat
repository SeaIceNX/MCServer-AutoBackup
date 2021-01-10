@echo off
chcp 65001
for /f "delims=" %%i in (
    'type "backup.ini"^| find "="'
) do set %%i
set t1=%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%
set t2=%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%
md backup
title %title%
color 3f
cls

if /i not "%startbackup%" == "true" (
    if not "%startbackup%" == "false" (
        echo [%time:~0,8% ERROR]: 配置项 startbackup 错误（非布尔值）
        set error=true
    )
)
if /i not "%timebackup%" == "true" (
    if not "%timebackup%" == "false" (
        echo [%time:~0,8% ERROR]: 配置项 timebackup 错误（非布尔值）
        set error=true
    )
)
if /i not "%independent%" == "true" (
    if /i not "%independent%" == "false" (
        echo [%time:~0,8% ERROR]: 配置项 independent 错误（非布尔值）
        set error=true
    )
)
if "%servercommand%" == "" (
    if /i "%independent%" == "false" (
        echo [%time:~0,8% ERROR]: 配置项 servercommand 错误（为空）
        set error=true
    )
)
if "%worlds%" == "" (
    echo [%time:~0,8% ERROR]: 配置项 worlds 错误（为空）
    set error=true
)
if "%timer%" == "" (
    echo [%time:~0,8% ERROR]: 配置项 timer 错误（为空）
    set error=true
)
if "%backupcommand%" == "" (
    echo [%time:~0,8% ERROR]: 配置项 backupcommand 错误（为空）
    set error=true
)
if not "%error%" == "" (
    goto :pause
)

if /i %independent% == true (
    goto independent
)
if /i %startbackup% == false (
    goto timebackupstart
)

echo [%time:~0,8% INFO]: 正在开始备份存档...
if "%time:~0,1%" == " " (
    %backupcommand% backup\%t1%.7z %worlds%
) else (
    %backupcommand% backup\%t2%.7z %worlds%
)
echo.
echo [%time:~0,8% INFO]: 备份完成！正在开启服务器...
choice /t 3 /d y >nul
cls

:timebackupstart
if /i %timebackup% == false (
    goto serverstart
)
start %servercommand%
if errorlevel 9059 (
    echo [%time:~0,8% ERROR]: 服务端启动失败！请检查配置文件！
    goto pause
) else (
    echo [%time:~0,8% INFO]: 自动备份运行中...
)

:timebackup
choice /t %timer% /d y >nul
:independent
echo [%time:~0,8% INFO]: 正在开始备份存档...
if "%time:~0,1%" == " " (
    %backupcommand% backup\%t1%.7z %worlds%
) else (
    %backupcommand% backup\%t2%.7z %worlds%
)
echo [%time:~0,8% INFO]: 备份完成！距离下次备份还有%timer%秒。
if /i %timebackup% == true (
    goto timebackup
) else if /i %independent% == true (
    goto timebackup
)

:serverstart
if /i %startbackup% == false (
    if /i %timebackup% == false (
        echo [%time:~0,8% WARN]: 既然你把备份功能都关了，那还用这个干什么...
    )
)
%servercommand%
if errorlevel 9059 (
    echo [%time:~0,8% ERROR]: 服务端启动失败！请检查配置文件！
)

:pause
echo 按任意键退出...
pause >nul
