@echo off
sc create Presentasi binPath= "%SystemDrive%\Program Files\nodejs\node.exe %SystemDrive%\Program Files\Presentasi\server.js" start= auto
