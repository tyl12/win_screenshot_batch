@ECHO OFF
:Loop
timeout /T 10 /NOBREAK
D:\ftp\nircmd-x64\nircmd.exe runinteractivecmd savescreenshot D:\ftp\cfg\scr~$currdate.MM_dd_yyyy$-~$currtime.HH_mm_ss$.png
ftp -s:D:\ftp\config.txt
timeout /T 2 /NOBREAK
::del D:\ftp\cfg\*.png
GOTO Loop