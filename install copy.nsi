!include "MUI2.nsh"
!include "LogicLib.nsh"

; Tentukan nama aplikasi dan versi
Name "Presentasi"
OutFile "Presentasi.exe"
InstallDir "$PROGRAMFILES\Presentasi"
InstallDirRegKey HKLM "Software\Presentasi" "Install_Dir"

; Tentukan halaman
Page directory
Page instfiles

; Tentukan pengaturan default
Section "MainSection" SEC01
  ; Tentukan file yang akan disalin
  SetOutPath "$INSTDIR"
  File "nodejs-setup.msi"
  File "server.js"
  File "package.json"
  file "create-service.bat"
  file "remove-service.bat"
  File /r "public\*.*"
  File /r "node_modules\*.*"
  
  ; Instal Node.js
  ExecWait '"$INSTDIR\nodejs-setup.msi" /silent'
  
  ; Jalankan Node.js untuk memasang modul atau konfigurasi
  ExecWait '"$INSTDIR\node.exe" "$INSTDIR\server.js"'
  
  ; Tambahkan layanan Windows
  WriteRegStr HKLM "Software\Presentasi" "Install_Dir" "$INSTDIR"
  ; Ganti path berikut dengan path ke skrip atau executable yang membuat layanan
  Exec '"$INSTDIR\create-service.bat"'
  
  ; Buat shortcut di desktop
  ; CreateShortCut "$DESKTOP\Presentasi.lnk" "$INSTDIR\Presentasi.exe"
SectionEnd

; Hapus file dan registri saat uninstall
Section "Uninstall"
  ; Hapus file
  ;Delete "$INSTDIR\nodejs-setup.exe"
  ;Delete "$INSTDIR\server.js"
  ;Delete "$INSTDIR\presentasi.exe"
  ;Delete "$INSTDIR\public\*.*"
  
  ; Hapus shortcut
  Delete "$DESKTOP\Presentasi.lnk"
  
  ; Hapus registri
  DeleteRegKey HKLM "Software\Presentasi"
  

  ; Hapus layanan Windows jika ada
  ExecWait '"$INSTDIR\remove-service.bat"'

  ; Hapus folder instalasi
  RMDir /r "$INSTDIR"

SectionEnd
