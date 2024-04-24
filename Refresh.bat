chcp 65001
CLS
@echo off
echo 請確保此批次檔是在電腦本機執行，以管理員權限開，「SCCM-clr_cache.ps1」也在同一個資料夾中，並確認軟體中心是關閉的（最好從啟後沒開）。
echo Please ensure that this is ran locally, in admin mode, and SCCM-clear_cache.ps1 is in the same directory, and Software Center is closed.
PAUSE
CLS
REM This makes it the current directory
CD /D "%~dp0"
REM 下列會執行清除SCCM緩存的腳本，它只能在PowerShell執行 This invokes PowerShell since I cannot find a better way to clear SCCM cache
powershell.exe -File .\SCCM-clr_cache.ps1
echo 緩存清除完畢！Cache cleared!
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000001}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000002}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000003}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000010}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000021}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000022}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000026}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000027}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000031}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000032}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000113}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000114}" /NOINTERACTIVE
CLS
echo 動作執行完畢！All items ran (I forgot the English name of the commands)!
gpupdate /force
REM Asks if it ran successfully. If it did, it gives it 5 minutes to restart, or runs again if it did not.
CHOICE /T 60 /D Y /M "更新原則成功了嗎？ Y：有（預設，60秒內選） N：沒有"
If %ERRORLEVEL% ==1 goto rst
If %ERRORLEVEL% ==2 goto rerun

:rst
CLS
echo 現在在背景自動更新 SCCM，5分鐘後會自動重啟。如果不要重啟，請在倒數計時完畢前關閉此畫面。
echo Refreshing SCCM, then restarting in 5 minutes. If you do not want to restart, close this box before the countdown ends.
TIMEOUT /T 300
shutdown -r -f -t 00
goto:eof

:rerun
echo 重執行更新原則：Restarting policy update:
gpupdate /force
echo 如果這次還是沒成功，請按任意鍵立刻重啟，再執行本腳本一次。如果不要重啟，請在倒數計時完畢前關閉此畫面。
echo If this still does not work, press any key to restart and run this script again. If you do not want to restart, close this box before the countdown ends.
TIMEOUT /T 300
shutdown -r -f -t 00
goto:eof

exit /b
