@echo off
chcp 65001
title AutoBackup 自动备份
color 3f
:inirestart
dir backup.ini
if errorlevel 1 (
    echo [backup]>>backup.ini
    echo # backup.ini  AutoBackup配置文件>>backup.ini
    echo.>>backup.ini
    echo startbackup=true>>backup.ini
    echo # 设置开服备份（布尔值）>>backup.ini
    echo.>>backup.ini
    echo timebackup=true>>backup.ini
    echo # 设置定时备份（布尔值）>>backup.ini
    echo.>>backup.ini
    echo servercommand=bedrock_server.exe>>backup.ini
    echo # 设置服务端启动命令（缺省值）>>backup.ini
    echo.>>backup.ini
    echo independent=false>>backup.ini
    echo # 独立模式（servercommand、startbackup、timebackup、backuptype项将失效）>>backup.ini
    echo.>>backup.ini
    echo backuptype=hot>>backup.ini
    echo # 备份模式（冷备份-cold 热备份-hot 冷备份目前只适用于不使用其他外置启动的服务端）>>backup.ini
    echo.>>backup.ini
    echo worlds=worlds>>backup.ini
    echo # 设置需备份位置（缺省值）>>backup.ini
    echo.>>backup.ini
    echo timer=1800>>backup.ini
    echo # 设置定时备份间隔（单位：秒 0~99999内整数）>>backup.ini
    echo.>>backup.ini
    echo backupcommand=7z.exe a>>backup.ini
    echo # 备份命令开头（缺省值）>>backup.ini

    set inisummon=true
    goto inirestart
) else (
    for /f "delims=" %%i in (
        'type "backup.ini"^|find "="'
    ) do set %%i
)
md backup
if not errorlevel 1 (
    set file=true
)
cls

if not "%file%" == "" (
    echo [%time:~0,8% WARN] 保存文件夹已生成
)
if not "%inisummon%" == "" (
    echo [%time:~0,8% WARN] 配置文件已生成
)

if /i not "%startbackup%" == "true" (
    if /i not "%startbackup%" == "false" (
        echo [%time:~0,8% ERROR] 配置项 startbackup 错误（非布尔值）
        set error=true
    )
)
if /i not "%timebackup%" == "true" (
    if /i not "%timebackup%" == "false" (
        echo [%time:~0,8% ERROR] 配置项 timebackup 错误（非布尔值）
        set error=true
    )
)
if /i not "%independent%" == "true" (
    if /i not "%independent%" == "false" (
        echo [%time:~0,8% ERROR] 配置项 independent 错误（非布尔值）
        set error=true
    )
)
if /i not "%timebackup%" == "false" (
    if /i not "%backuptype%" == "cold" (
        if /i not "%backuptype%" == "hot" (
            echo [%time:~0,8% ERROR] 配置项 backuptype 错误（非预设值）
            set error=true
        )
    )
)
if "%servercommand%" == "" (
    if /i "%independent%" == "false" (
        echo [%time:~0,8% ERROR] 配置项 servercommand 错误（为空）
        set error=true
    )
)
if /i not "%startbackup%" == "false" (
    if /i not "%timebackup%" == "false" (
        if /i not "%independent%" == "false" (
            if "%worlds%" == "" (
                echo [%time:~0,8% ERROR] 配置项 worlds 错误（为空）
                set error=true
            )
        )
    )
)
if /i not "%timebackup%" == "false" (
    if "%timer%" == "" (
        echo [%time:~0,8% ERROR] 配置项 timer 错误（为空）
        set error=true
    )
)
if /i not "%startbackup%" == "false" (
    if /i not "%timebackup%" == "false" (
        if /i not "%independent%" == "false" (
            if "%backupcommand%" == "" (
                echo [%time:~0,8% ERROR] 配置项 backupcommand 错误（为空）
                set error=true
            )
        )
    )
)
if not "%error%" == "" (
    goto pause
)

if /i %independent% == true (
    goto independent
)
if /i %startbackup% == false (
    goto timebackupstart
)
echo [%time:~0,8% INFO] 正在开始备份存档(开服备份)...
color af
if "%time:~0,1%" == " " (
    %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z %worlds%
) else (
    %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z %worlds%
)
if errorlevel 9009 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    echo [%time:~0,8% INFO] 备份完成！正在启动服务端...（按任意键跳过）
    color 3f
    timeout /t 3 >nul
    cls
)

:timebackupstart
if /i %timebackup% == false (
    goto serverstart
)
start %servercommand%
if errorlevel 9059 (
    cls
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    echo [%time:~0,8% INFO] 服务端启动成功！自动备份运行中...
)

:timebackup
timeout /t %timer% /nobreak >nul
:independent
echo [%time:~0,8% INFO] 正在开始备份存档(定时备份)...
color af
if /i %independent% == false (
    if /i %backuptype% == hot (
        if "%time:~0,1%" == " " (
            %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z %worlds%
        ) else (
            %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z %worlds%
        )
    ) else (
        taskkill /f /im %servercommand% /t
        if "%time:~0,1%" == " " (
            %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z %worlds%
        ) else (
            %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z %worlds%
        )
    )
) else (
    if "%time:~0,1%" == " " (
        %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z %worlds%
    ) else (
        %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z %worlds%
    )
)
if errorlevel 9009 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    echo [%time:~0,8% INFO] 备份完成！距离下次备份还有%timer%秒。
    color 3f
    if /i %independent% == false (
        if /i %backuptype% == cold (
            start %servercommand%
        )
    )
    if /i %timebackup% == true (
        goto timebackup
    ) else if /i %independent% == true (
        goto timebackup
    )
)

:serverstart
if /i %startbackup% == false (
    if /i %timebackup% == false (
        echo [%time:~0,8% WARN] 备份功能已被全部关闭！请检查配置文件！
    )
)
%servercommand%
if errorlevel 9059 (
    cls
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
)

:pause
color cf
echo [%time:~0,8% WARN] 按任意键退出...
pause >nul
