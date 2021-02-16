@echo off
chcp 65001>nul
title AutoBackup
color 3f
title AutoBackup - 启动中...
:allrestart
dir backup.ini>nul
if errorlevel 1 (
    (
        echo [backup]>>backup.ini
        echo # backup.ini  AutoBackup配置文件>>backup.ini
        echo.>>backup.ini
        echo startbackup=true>>backup.ini
        echo # 是否开服备份>>backup.ini
        echo # 允许值："true"或"false">>backup.ini
        echo.>>backup.ini
        echo delaybackup=true>>backup.ini
        echo # 是否延时备份>>backup.ini
        echo # 允许值："true"或"false">>backup.ini
        echo.>>backup.ini
        echo servercommand=bedrock_server.exe>>backup.ini
        echo # 服务端启动命令>>backup.ini
        echo # 允许值：任何字符串>>backup.ini
        echo.>>backup.ini
        echo independent=false>>backup.ini
        echo # 是否独立模式>>backup.ini
        echo # "servercommand"、"startbackup"、"delaybackup"、"backuptype"项将失效>>backup.ini
        echo # 允许值："true"或"false">>backup.ini
        echo.>>backup.ini
        echo backuptype=hot>>backup.ini
        echo # 备份模式>>backup.ini
        echo # 允许值："cold"、"javacold"或"hot">>backup.ini
        echo.>>backup.ini
        echo worlds=worlds>>backup.ini
        echo # 需备份位置>>backup.ini
        echo # 允许值：任何字符串>>backup.ini
        echo.>>backup.ini
        echo delay=1800>>backup.ini
        echo # 延时备份间隔（单位：秒）>>backup.ini
        echo # 允许值：在[0, 99999]范围内的整数>>backup.ini
        echo.>>backup.ini
        echo backupcommand=7z.exe a>>backup.ini
        echo # 备份命令开头>>backup.ini
        echo # 允许值：任何字符串>>backup.ini
        echo.>>backup.ini
        echo restart=true>>backup.ini
        echo # 是否崩服自重启（延时备份关闭时有效）>>backup.ini
        echo # 允许值："true"或"false">>backup.ini
        echo.>>backup.ini
        echo restarttimer=3 >>backup.ini
        echo # 崩服自重启间隔（单位：秒）>>backup.ini
        echo # 崩服自重启有效时有效>>backup.ini
        echo # 允许值：[-1, 99999]内整数（-1表示等待用户按任何键重启）>>backup.ini
    )
    set inisummon=true
    goto allrestart
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
    echo [%date:~3,10% %time:~0,8% WARN] 生成了保存文件夹>>backup.log
    echo [%time:~0,8% WARN] 保存文件夹已生成
)
if not "%inisummon%" == "" (
    echo [%date:~3,10% %time:~0,8% WARN] 生成了配置文件>>backup.log
    echo [%time:~0,8% WARN] 配置文件已生成
)
if /i not "%startbackup%" == "true" (
    if /i not "%startbackup%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现startbackup项错误 已自动补充>>backup.log
        echo startbackup=true>>backup.ini
        goto allrestart
    )
)
if /i not "%delaybackup%" == "true" (
    if /i not "%delaybackup%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现delaybackup项错误 已自动补充>>backup.log
        echo delaybackup=true>>backup.ini
        goto allrestart
    )
)
if /i not "%independent%" == "true" (
    if /i not "%independent%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现independent项错误 已自动补充>>backup.log
        echo independent=false>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if /i not "%backuptype%" == "cold" (
        if /i not "%backuptype%" == "hot" (
            if /i not "%backuptype%" == "javacold" (
                echo [%date:~3,10% %time:~0,8% WARN] 发现backuptype项错误 已自动补充>>backup.log
                echo backuptype=hot>>backup.ini
                goto allrestart
            )
        )
    )
)
if /i "%independent%" == "false" (
    if "%servercommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现servercommand项错误 已自动补充>>backup.log
        echo servercommand=bedrock_server.exe>>backup.ini
        goto allrestart
    )
)
if /i "%startbackup%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现worlds项错误 已自动补充>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现worlds项错误 已自动补充>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%independent%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现worlds项错误 已自动补充>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%delay%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现worlds项错误 已自动补充>>backup.log
        echo delay=1800>>backup.ini
        goto allrestart
    )
)
if /i "%startbackup%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现backupcommand项错误 已自动补充>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现backupcommand项错误 已自动补充>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%independent%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现backupcommand项错误 已自动补充>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "false" (
    if /i not "%restart%" == "true" (
        if /i not "%restart%" == "false" (
            echo [%date:~3,10% %time:~0,8% WARN] 发现restart项错误 已自动补充>>backup.log
            echo restart=true>>backup.ini
            goto allrestart
        )
    )
)
if /i "%restart%" == "true" (
    if "%restarttimer%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] 发现restarttimer项错误 已自动补充>>backup.log
        echo restarttimer=3 >>backup.ini
        goto allrestart
    )
)

title AutoBackup
echo [%date:~3,10% %time:~0,8% INFO] AutoBackup被启动了>>backup.log
if /i %independent% == true (
    goto independent
)
if /i %startbackup% == false (
    goto delaybackupstart
)

title AutoBackup - 备份中...
echo [%time:~0,8% INFO] 正在开始备份存档(开服备份)...
color af
if "%time:~0,1%" == " " (
    %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
) else (
    %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
)
if errorlevel 9009 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    title AutoBackup
    echo [%date:~3,10% %time:~0,8% INFO] 进行了一次开服备份>>backup.log
    echo [%time:~0,8% INFO] 备份完成！正在启动服务端...（按任何键跳过）
    color 3f
    timeout /t 3 >nul
    cls
)

:delaybackupstart
if /i %delaybackup% == false (
    goto serverstart
)
title AutoBackup - 启动服务器中...
start %servercommand%
if errorlevel 9059 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 开服时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 开服时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    title AutoBackup - 等待中...
    echo [%date:~3,10% %time:~0,8% INFO] 启动了服务器>>backup.log
    echo [%time:~0,8% INFO] 服务端启动成功！自动备份运行中...
)
:delaybackup
timeout /t %delay% /nobreak >nul

:independent
title AutoBackup - 备份中...
echo [%time:~0,8% INFO] 正在开始备份存档(延时备份)...
color af
if /i %independent% == false (
    if /i %backuptype% == cold (
        taskkill /f /im %servercommand% /t
        if "%time:~0,1%" == " " (
            %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
        ) else (
            %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
        )
    ) else if /i %backuptype% == hot (
        if "%time:~0,1%" == " " (
            %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
        ) else (
            %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
        )
    ) else if /i %backuptype% == javacold (
        taskkill /f /im java.exe /t
        if "%time:~0,1%" == " " (
            %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
        ) else (
            %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
        )
    ) 
) else (
    if "%time:~0,1%" == " " (
        %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
    ) else (
        %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
    )
)
if errorlevel 9009 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 备份时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 备份失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else (
    title AutoBackup - 等待中...
    echo [%date:~3,10% %time:~0,8% INFO] 进行了一次延时备份>>backup.log
    echo [%time:~0,8% INFO] 备份完成！距离下次备份还有%delay%秒。
    color 3f
    if /i %independent% == false (
        if /i %backuptype% == cold (
            start %servercommand%
        )
    )
    if /i %delaybackup% == true (
        goto delaybackup
    ) else if /i %independent% == true (
        goto delaybackup
    )
)

:serverstart
title AutoBackup - 服务器
if /i %startbackup% == false (
    if /i %delaybackup% == false (
        echo [%time:~0,8% WARN] 备份功能已被全部关闭！请检查配置文件！
        title AutoBackup - QAQ
    )
)
%servercommand%
if errorlevel 9059 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 开服时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - 错误!
    echo [%date:~3,10% %time:~0,8% ERROR] 开服时检测到错误！报错码：%errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] 服务端启动失败！请检查配置文件！报错码：%errorlevel%
    goto pause
)
if %restart% == true (
    color cf
    title AutoBackup - 重启中...
    echo [%date:~3,10% %time:~0,8% INFO] 自重启了服务器>>backup.log
    echo [%time:~0,8% WARN]: 检测到服务器关闭 将于%restarttimer%s后重启 否则请直接关闭此窗口
    timeout /t %restarttimer% >nul
    goto serverstart
)

:pause
color cf
echo [%date:~3,10% %time:~0,8% INFO] AutoBackup被关闭了>>backup.log
echo [%time:~0,8% WARN] 按任何键退出...
pause >nul
