:: Find packages in Anaconda locations
set CMAKE_PREFIX_PATH=%LIBRARY_PREFIX%

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" -DBOOST_ROOT="%LIBRARY_PREFIX%" -DBOOST_INCLUDE_DIR="%LIBRARY_INC%" -DZLIB_LIBRARY="%LIBRARY_LIB%\zlib.lib" -DZLIB_INCLUDE_DIR="%LIBRARY_INC%" -G"NMake Makefiles" .
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1
nmake install

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
