@echo off
chcp 65001>nul
title AutoBackup
color 3f
title AutoBackup - Starting...
:allrestart
dir backup.ini>nul
if errorlevel 1 (
    (
        echo [backup]>>backup.ini
        echo # backup.ini  Config of AutoBackup >>backup.ini
        echo. >>backup.ini
        echo startbackup=true>>backup.ini
        echo # Sets the backup before server start >>backup.ini
        echo # Allowed values: "true" or "false" >>backup.ini
        echo. >>backup.ini
        echo delaybackup=true>>backup.ini
        echo # Sets the backup when server working >>backup.ini
        echo # Allowed values: "true" or "false" >>backup.ini
        echo. >>backup.ini
        echo servercommand=bedrock_server.exe>>backup.ini
        echo # Sets the start command >>backup.ini
        echo # Allowed values: Any string >>backup.ini
        echo. >>backup.ini
        echo independent=false>>backup.ini
        echo # Sets independent mode >>backup.ini
        echo # "servercommand","startbackup","delaybackup","backuptype"will be disabled >>backup.ini
        echo # Allowed values: "true" or "false" >>backup.ini
        echo. >>backup.ini
        echo backuptype=hot>>backup.ini
        echo # Sets backup mode >>backup.ini
        echo # Allowed values: "cold", "javacold" or "hot" >>backup.ini
        echo. >>backup.ini
        echo worlds=worlds>>backup.ini
        echo # The location that needs to be backup >>backup.ini
        echo # Allowed values: Any string >>backup.ini
        echo. >>backup.ini
        echo delay=1800>>backup.ini
        echo # Interval of timing backup >>backup.ini
        echo # Unit: second Scope: 0~99999 >>backup.ini
        echo. >>backup.ini
        echo backupcommand=7z.exe a>>backup.ini
        echo # The beginning of the backup command >>backup.ini
        echo # Allowed values: Any string >>backup.ini
        echo. >>backup.ini
        echo restart=true>>backup.ini
        echo # Sets restart when server close（Only available when "delaybackup" is "false"） >>backup.ini
        echo # Allowed values: "true" or "false" >>backup.ini
        echo. >>backup.ini
        echo restarttimer=3 >>backup.ini
        echo # Self-restart interval of the server collapse >>backup.ini
        echo # Effective when the self-restart of the server collapse is valid >>backup.ini
        echo # Unit: second Scope: -1~99999（-1 means waiting for the user to press any key to restart）>>backup.ini
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
    echo [%date:~3,10% %time:~0,8% WARN] Save folder has been generated>>backup.log
    echo [%time:~0,8% WARN] Save folder has been generated
)
if not "%inisummon%" == "" (
    echo [%date:~3,10% %time:~0,8% WARN] Config file has been generated>>backup.log
    echo [%time:~0,8% WARN] Config file has been generated
)
if /i not "%startbackup%" == "true" (
    if /i not "%startbackup%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] Find startbackup error! It has been replenished automatically>>backup.log
        echo startbackup=true>>backup.ini
        goto allrestart
    )
)
if /i not "%delaybackup%" == "true" (
    if /i not "%delaybackup%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] Find delaybackup error! It has been replenished automatically>>backup.log
        echo delaybackup=true>>backup.ini
        goto allrestart
    )
)
if /i not "%independent%" == "true" (
    if /i not "%independent%" == "false" (
        echo [%date:~3,10% %time:~0,8% WARN] Find independent error! It has been replenished automatically>>backup.log
        echo independent=false>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if /i not "%backuptype%" == "cold" (
        if /i not "%backuptype%" == "hot" (
            if /i not "%backuptype%" == "javacold" (
                echo [%date:~3,10% %time:~0,8% WARN] Find backuptype error! It has been replenished automatically>>backup.log
                echo backuptype=hot>>backup.ini
                goto allrestart
            )
        )
    )
)
if /i "%independent%" == "false" (
    if "%servercommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find servercommand error! It has been replenished automatically>>backup.log
        echo servercommand=bedrock_server.exe>>backup.ini
        goto allrestart
    )
)
if /i "%startbackup%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find worlds error! It has been replenished automatically>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find worlds error! It has been replenished automatically>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%independent%" == "true" (
    if "%worlds%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find worlds error! It has been replenished automatically>>backup.log
        echo worlds=worlds>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%delay%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find worlds error! It has been replenished automatically>>backup.log
        echo delay=1800>>backup.ini
        goto allrestart
    )
)
if /i "%startbackup%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find backupcommand error! It has been replenished automatically>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find backupcommand error! It has been replenished automatically>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%independent%" == "true" (
    if "%backupcommand%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find backupcommand error! It has been replenished automatically>>backup.log
        echo backupcommand=7z.exe a>>backup.ini
        goto allrestart
    )
)
if /i "%delaybackup%" == "false" (
    if /i not "%restart%" == "true" (
        if /i not "%restart%" == "false" (
            echo [%date:~3,10% %time:~0,8% WARN] Find restart error! It has been replenished automatically>>backup.log
            echo restart=true>>backup.ini
            goto allrestart
        )
    )
)
if /i "%restart%" == "true" (
    if "%restarttimer%" == "" (
        echo [%date:~3,10% %time:~0,8% WARN] Find restarttimer error! It has been replenished automatically>>backup.log
        echo restarttimer=3 >>backup.ini
        goto allrestart
    )
)

title AutoBackup
echo [%date:~3,10% %time:~0,8% INFO] AutoBackup started>>backup.log
if /i %independent% == true (
    goto independent
)
if /i %startbackup% == false (
    goto delaybackupstart
)

title AutoBackup - Working...
echo [%time:~0,8% INFO] Starting backup archive（open server backup）...
color af
if "%time:~0,1%" == " " (
    %backupcommand% backup\%date:~8,2%%date:~11,2%0%time:~1,1%%time:~3,2%%time:~6,2%.7z "%worlds%"
) else (
    %backupcommand% backup\%date:~8,2%%date:~11,2%%time:~0,2%%time:~3,2%%time:~6,2%.7z "%worlds%"
)
if errorlevel 9009 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 7 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else (
    title AutoBackup
    echo [%date:~3,10% %time:~0,8% INFO] An open server backup was complete>>backup.log
    echo [%time:~0,8% INFO] The backup is complete! Starting the server before 3s（press any key to skip）...
    color 3f
    timeout /t 3 >nul
    cls
)

:delaybackupstart
if /i %delaybackup% == false (
    goto serverstart
)
title AutoBackup - Opening...
start %servercommand%
if errorlevel 9059 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Start Server failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Start failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Start Server failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Start failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else (
    title AutoBackup - Waiting...
    echo [%date:~3,10% %time:~0,8% INFO] Server started>>backup.log
    echo [%time:~0,8% INFO] The server started successfully! Automatic backup is running（Press any key to skip）...
)
:delaybackup
timeout /t %delay% >nul

:independent
title AutoBackup - Working...
echo [%time:~0,8% INFO] Starting backup archive（timing backup）...
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
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 7 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 1 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Backup failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Backup failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else (
    title AutoBackup - Waiting
    echo [%date:~3,10% %time:~0,8% INFO] A delayed backup was complete>>backup.log
    echo [%time:~0,8% INFO] The backup is complete! %delay%s until the next backup（Press any key to skip）
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
title AutoBackup - Server
if /i %startbackup% == false (
    if /i %delaybackup% == false (
        echo [%time:~0,8% WARN] The backup function has been completely closed! Please check the configuration file!
        title AutoBackup - QAQ
    )
)
%servercommand%
if errorlevel 9059 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Start Server failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Start Server failed! Please check the config file! Error code: %errorlevel%
    goto pause
) else if errorlevel 5 (
    cls
    title AutoBackup - ERROR!
    echo [%date:~3,10% %time:~0,8% ERROR] Start Server failed! Error code: %errorlevel%>>backup.log
    echo [%time:~0,8% ERROR] Start Server failed! Please check the config file! Error code: %errorlevel%
    goto pause
)
if %restart% == true (
    color cf
    title AutoBackup - Restarting...
    echo [%date:~3,10% %time:~0,8% INFO] Restart server>>backup.log
    echo [%time:~0,8% WARN]: The server is detected to be shut down（Press any kay to skip）, it will restart after %restarttimer%s, otherwise please close this window directly
    timeout /t %restarttimer% >nul
    goto serverstart
)

:pause
color cf
echo [%date:~3,10% %time:~0,8% INFO] AutoBackup closed>>backup.log
echo [%time:~0,8% WARN] Press any key to exit...
pause >nul
