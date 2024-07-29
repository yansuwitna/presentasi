!include LogicLib.nsh
!include x64.nsh
!include FileFunc.nsh
!insertmacro GetParameters

; Tentukan nama aplikasi dan versi
Name "Presentasi"
OutFile "Setup Presentasi PDF-MP4.exe"
InstallDir "C:\Presentasi"
InstallDirRegKey HKLM "Software\Presentasi" "Install_Dir"

; Tentukan halaman
Page directory
Page instfiles

Var ARCHITECTURE
Var NODE_INSTALLED

Function .onInit
    ; Check system architecture
    ${If} ${RunningX64}
        StrCpy $ARCHITECTURE "x64"
    ${Else}
        StrCpy $ARCHITECTURE "x86"
    ${EndIf}
FunctionEnd

; Tentukan pengaturan default
Section "MainSection" SEC01
    CreateDirectory "C:\Presentasi\public"
    CreateDirectory "C:\Presentasi\node_modules"

  ; Tentukan file yang akan disalin
  SetOutPath "C:\Presentasi"
  File "nodejs-setup32.msi"
  File "nodejs-setup64.msi"
  File "server.exe"
  File "server.js"
  File "package.json"
  File "presentasi.bat"
  File "package-lock.json"

    SetOutPath "C:\Presentasi\public"
  File /r "public\*.*"

    SetOutPath "C:\Presentasi\node_modules"
  File /r "node_modules\*.*"
  
  
  ; Instal Node.js
  nsExec::ExecToStack "cmd /C node -v"
    Pop $0
    Pop $1

    ${If} $0 == 0
        StrCpy $NODE_INSTALLED 1
    ${Else}
        StrCpy $NODE_INSTALLED 0
    ${EndIf}

    ${If} $NODE_INSTALLED == 0
        ; Node.js not found, download and install it
        MessageBox MB_OK "Node.js not found. Installing Node.js..."
        
        ; Define Node.js version and URL based on architecture
        ${If} $ARCHITECTURE == "x64"
            ;StrCpy $0 "node-v14.17.0-x64.msi"
            ;StrCpy $1 "https://nodejs.org/dist/v14.17.0/$0"
            StrCpy $0 "C:\Presentasi\nodejs-setup64.msi"
        ${Else}
            ;StrCpy $0 "node-v14.17.0-x86.msi"
            ;StrCpy $1 "https://nodejs.org/dist/v14.17.0/$0"
            StrCpy $0 "C:\Presentasi\nodejs-setup32.msi"
        ${EndIf}
        
        ; Download Node.js installer
        ;nsExec::ExecToLog "powershell -command ""& {Invoke-WebRequest -Uri $1 -OutFile $0}"""
        
        ; Install Node.js
        ;nsExec::ExecToLog "msiexec /i $0 /quiet"
        nsExec::ExecToLog "msiexec /i $0"
    ${Else}
        MessageBox MB_OK "Node.js is already installed."
    ${EndIf}
  
  ; Buat shortcut di desktop
  CreateShortCut "$DESKTOP\Presentasi.lnk" "C:\Presentasi\server.exe"
  CreateShortCut "$DESKTOP\Presentasi Guru.lnk" "http://localhost:3000/guru"

  ; Create shortcut in the Start Menu
    CreateDirectory "$SMPROGRAMS\Presentasi"
    CreateShortcut "$SMPROGRAMS\Presentasi\Server Presentasi PDF.lnk" "C:\Presentasi\server.exe" "" "C:\Presentasi\server.exe" 0
    CreateShortCut "$SMPROGRAMS\Presentasi\Presentasi Guru.lnk" "http://localhost:3000/guru"

    WriteUninstaller "C:\Presentasi\Hapus Presentasi PDF.exe"
    CreateShortcut "$SMPROGRAMS\Presentasi\Hapus Presentasi PDF.lnk" "C:\Presentasi\Hapus Presentasi PDF.exe"

SectionEnd

Section "Uninstall"
    ; Remove shortcuts
    Delete "$DESKTOP\Presentasi.lnk"
    Delete "$DESKTOP\Presentasi Guru.lnk"
    Delete "$SMPROGRAMS\Presentasi\Server Presentasi PDF.lnk"
    Delete "$SMPROGRAMS\Presentasi\Hapus Presentasi PDF.lnk"
    RMDir /r "$SMPROGRAMS\Presentasi"
    RMDir /r "$INSTDIR"
    ; Finish uninstallation
    MessageBox MB_OK "Uninstallation complete."
SectionEnd