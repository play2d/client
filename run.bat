@ECHO OFF
VER|FINDSTR /i "5\.1\."
IF %ERRORLEVEL% EQU 0 (
	FOR /F "tokens=3*" %%R IN ('REG QUERY "HKEY_CLASSES_ROOT\LOVE\shell\open\command"') DO (SET "output=%%S")
	FOR /F "delims= " %%I IN ("%output%") DO (SET "INSTALLDIR=%%I")
) ELSE (
	FOR /F "usebackq tokens=3,4" %%A IN (`REG QUERY "HKEY_CLASSES_ROOT\LOVE\shell\open\command"`) DO (SET "INSTALLDIR=%%A %%B")
	ECHO.%INSTALLDIR%|FINDSTR /C:"exe ">nul && (FOR /F "usebackq tokens=3" %%A IN (`REG QUERY "HKEY_CLASSES_ROOT\LOVE\shell\open\command"`) DO (SET "INSTALLDIR=%%A"))
)

IF NOT DEFINED INSTALLDIR (
	ECHO Error, couldn't find a LOVE2D installation.
	PAUSE
	EXIT
) ELSE (START "" "%INSTALLDIR%" .)