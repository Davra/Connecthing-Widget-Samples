# Creating an Angular app within a widget
A single widget template could be an Angular app. As a developer, write the code locally on one's development machine, 
run the compilation commands to create the production distribution assets and 
use a script to upload those files into the widget template.


# Sample app process
The following describes how to retrieve a demonstration Angular app from github, assemble it into the distribution 
assets and upload those assets into a new widget template. From that template a user may add a widget of that type 
to their Applications.


### Install NodeJs and AngularCLI
- Download and install Node 10 from http://nodejs.org/
- Download and install Angular CLI from https://github.com/angular/angular-cli using the command:
```npm install -g @angular/cli@7.0.6```


### Download sample Angular code
```
git clone https://github.com/mraible/ng-demo.git
cd ng-demo
npm install
```
You can confirm it is downloaded and ready by running ```ng serve``` and opening a browser at http://localhost:4200


### Edit the Angular code to sit within iframes
By default, widgets exist within iframes and contain URL parameters but Angular would prefer these to not exist upon load, 
so alter the following lines within index.html:
- Set ```<base href="./">```
- Add the following snippet to the beginning of the body section:
```
    <script>
      console.log('URL of angular app is ', window.location.href);
      if(window.location.href.indexOf('context=connecthing') > -1) {
        window.location.href = window.location.href.replace(window.location.search, '');
      }
    </script>
```

After editing, the index.html will appear as:
![New Index page](http://help.davra.com/pics/angular-sample1.png)


### Assemble the Angular distribution
```
ng build --prod
```
This builds a "dist" directory and a subdirectory called "ng-demo". That directory contains the assets 
which should be uploaded to the widgetTemplate.


### Create a new Widget Template
Within the Davra platform, navigate to Custom Components in the left menu and click the Add button. A default template is created.
Note the widget template Id which is in the URL bar as it is required in the configuration below.


### Upload the Angular app
We wish to upload all the contents of the dist/ng-demo" directory to the new widget template. In this demonstration there are 18 files 
files and some are in subdrectories so it is best to upload them using a script. Larger Angular apps will have many more assets.

Save the following contents as "upload-to-widget.bat" and edit the confiuration section:
```
setlocal ENABLEDELAYEDEXPANSION
REM Upload all files in a directory to a widget template

REM CHANGE CONFIG BEFORE RUNNING

SET DISTDIR=C:\Users\Jason\demo1\ng-demo\dist\ng-demo\
SET DAVRASERVER=46.4.132.178:58000
SET MYTEMPLATE=6109e5aa214360f1b67e1f0c4627db49
SET MYUSERNAME=demo
SET MYPASSWORD=demoPassword

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
```

Run the batch file (windows) using `upload-to-widget.bat` and it will upload each of the files to the new widget template.
Publish the widget
Add a widget to a page, using the new template
The Angular app will now run inside a widget within a page in an App.

