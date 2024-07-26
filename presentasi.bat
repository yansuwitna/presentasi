
@echo off
setlocal enabledelayedexpansion

rem Inisialisasi variabel kosong untuk menyimpan alamat IP
set ip_address=

rem Jalankan ipconfig dan cari baris yang mengandung "IPv4 Address" atau "Alamat IPv4"
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "IPv4 Address"') do (
    set ip_address=%%i
    rem Menghapus spasi di awal
    set ip_address=!ip_address:~1!
)

rem Tampilkan alamat IP yang telah disimpan di variabel
cls
echo Untuk Siswa: %ip_address%:3000
echo Untuk Guru: %ip_address%:3000/guru

echo ========================================================
echo Aktivitas Server : 
npm start

