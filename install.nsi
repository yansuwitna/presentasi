!include "MUI2.nsh"
!include "LogicLib.nsh"

; Tentukan nama aplikasi dan versi
Name "Presentasi"
OutFile "Presentasi.exe"
InstallDir "C:\Presentasi"
InstallDirRegKey HKLM "Software\Presentasi" "Install_Dir"

; Tentukan halaman
Page directory
Page instfiles

; Tentukan pengaturan default
Section "MainSection" SEC01
    CreateDirectory "C:\Presentasi\public"
    CreateDirectory "C:\Presentasi\node_modules"

  ; Tentukan file yang akan disalin
  SetOutPath "C:\Presentasi"
  File "nodejs-setup.msi"
  File "server.js"
  File "package.json"
  File "presentasi.bat"
  File "package-lock.json"

    SetOutPath "C:\Presentasi\public"
  File /r "public\*.*"

    SetOutPath "C:\Presentasi\node_modules"
  File /r "node_modules\*.*"
  
  
  ; Instal Node.js
  ExecWait '"C:\Presentasi\nodejs-setup.msi" /silent'
  
  ; Jalankan Node.js untuk memasang modul atau konfigurasi
  ExecWait '"C:\Presentasi\node.exe" "C:\Presentasi\server.js"'
  
  ; Tambahkan layanan Windows
  WriteRegStr HKLM "Software\Presentasi" "Install_Dir" "C:\Presentasi"
  
  ; Buat shortcut di desktop
  CreateShortCut "$DESKTOP\Presentasi.lnk" "C:\Presentasi\presentasi.bat"
SectionEnd

; Hapus file dan registri saat uninstall
Section "Uninstall"
  
  ; Hapus shortcut
  Delete "$DESKTOP\Presentasi.lnk"
  
  ; Hapus registri
  DeleteRegKey HKLM "Software\Presentasi"
  
  ; Hapus folder instalasi
  RMDir /r "C:\Presentasi"

SectionEnd
