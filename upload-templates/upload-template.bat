setlocal ENABLEDELAYEDEXPANSION
REM Upload all files in a directory to a widget template

REM CHANGE CONFIG BEFORE RUNNING

REM Your local directory on your development windows machine
SET DISTDIR=J:\code\my-new-widget-template\
REM The destination server to upload to
SET DAVRASERVER=blah.davra.com
REM The Widget Template UUID. Eg appears in the url bar when editing the code in the web IDE for a template
SET MYTEMPLATE=8804b90bb5e790bc0b9bbb1a334ac4af
REM Server credentials for pushing/posting the files to the server
SET MYUSERNAME=myusername
SET MYPASSWORD=mypassword

REM End config


echo Uploading contents of %DISTDIR% to %DAVRASERVER%
dir /ad /on /b /s %DISTDIR%
REM Recurse through the local directory. Files first then subdirectories
@echo off
for %%f in (%DISTDIR%*.*) do (
	SET FILEONDISK=%%f
	SET FILENAME=%%f
	CALL :SUB_UPLOAD_FILE
)
for /F "delims=" %%i in ('dir /ad /on /b /s %DISTDIR%') do (
    pushd %%i
    dir | find /i "Directory of"
    for %%f in (*.*) do (
		SET FILEONDISK=%%i\%%f
		SET FILENAME=%%f
		CALL :SUB_UPLOAD_FILE
    )
    popd
)
@echo on

GOTO :EOF


:SUB_UPLOAD_FILE
	echo Start upload of: !FILEONDISK!
	REM Must deliberately set the content type for uploads
	SET "MYEXT=application/octet-stream"
	echo !FILENAME! | FIND /I ".PNG">Nul && ( SET "MYEXT=image/png" )
	echo !FILENAME! | FIND /I ".JPG">Nul && ( SET "MYEXT=image/jpg" )
	echo !FILENAME! | FIND /I ".GIF">Nul && ( SET "MYEXT=image/gif" )
	echo !FILENAME! | FIND /I ".HTM">Nul && ( SET "MYEXT=text/html" )
	echo !FILENAME! | FIND /I ".JS">Nul && ( SET "MYEXT=application/javascript" )
	echo !FILENAME! | FIND /I ".JSON">Nul && ( SET "MYEXT=application/json" )
	echo !FILENAME! | FIND /I ".CSS">Nul && ( SET "MYEXT=text/css" )
	echo !FILENAME! | FIND /I ".ICO">Nul && ( SET "MYEXT=image/x-icon" )
	echo !FILENAME! | FIND /I ".TXT">Nul && ( SET "MYEXT=text/plain" )
	echo !FILENAME! | FIND /I ".ZIP">Nul && ( SET "MYEXT=application/zip" )
	echo !FILENAME! | FIND /I ".XML">Nul && ( SET "MYEXT=application/xml" )
	echo !FILENAME! | FIND /I ".WOFF">Nul && ( SET "MYEXT=application/x-font-woff" )
	echo !FILENAME! | FIND /I ".TTF">Nul && ( SET "MYEXT=application/x-font-ttf" )
	echo !FILENAME! | FIND /I ".MP4">Nul && ( SET "MYEXT=video/mp4" )
	REM Only upload to the relative path of the directory so replace C:\etc to nothing
	call SET RELATIVEPATH=%%FILEONDISK:%DISTDIR%=%%%
	REM Convert backslashes to forward slashes
	call SET DESTPATH=%%RELATIVEPATH:\=/%%
	echo Uploading Extension: !MYEXT! . For file: !DESTPATH!
	echo curl -i -u %MYUSERNAME%:%MYPASSWORD% -X POST --data-binary "@!FILEONDISK!" -H "content-type:!MYEXT!" %DAVRASERVER%/api/v1/widgettemplates/%MYTEMPLATE%/attachments/!DESTPATH!
	curl -i -u %MYUSERNAME%:%MYPASSWORD% -X POST --data-binary "@!FILEONDISK!" -H "content-type:!MYEXT!" %DAVRASERVER%/api/v1/widgettemplates/%MYTEMPLATE%/attachments/!DESTPATH!
	echo File finished
EXIT /B
