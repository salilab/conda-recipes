mkdir %SCRIPTS%
copy /y bin\*.dll %SCRIPTS%\
copy /y bin\cmake.exe %SCRIPTS%\
xcopy share %PREFIX%\share /E /I

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
