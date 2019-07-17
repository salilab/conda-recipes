copy /y bin\*.dll %LIBRARY_PREFIX%\bin\
copy /y bin\cmake.exe %LIBRARY_PREFIX%\bin\
xcopy share %LIBRARY_PREFIX%\share /E /I

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
