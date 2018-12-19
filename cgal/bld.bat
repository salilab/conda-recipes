:: Find packages in Anaconda locations
set CMAKE_PREFIX_PATH=%BUILD_PREFIX%\Library

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="%PREFIX%\Library" -DBOOST_ROOT="%BUILD_PREFIX%\Library" -DBOOST_INCLUDE_DIR="%BUILD_PREFIX%\Library\include" -DZLIB_LIBRARY="%BUILD_PREFIX%\Library\lib\zlib.lib" -DZLIB_INCLUDE_DIR="%BUILD_PREFIX%\Library\include" -G"NMake Makefiles" .
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1
nmake install

if errorlevel 1 exit 1

:: Remove build path from cmake files
python "%RECIPE_DIR%\remove-cmake-build-path.py" "%PREFIX%" "%BUILD_PREFIX%\Library"
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
