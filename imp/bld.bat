if %ARCH% == "64" (
  set EXTRA_CXX_FLAGS=/bigobj
) else (
  set EXTRA_CXX_FLAGS=
)

::# Find packages in Anaconda locations
set CMAKE_PREFIX_PATH=%LIBRARY%

:: Fix cmake paths to use / rather than \
patch -p1 < %RECIPE_DIR%\cmake-path.patch
if errorlevel 1 exit 1

:: Quiet warnings from newer cmake about policy changes
patch -p1 < %RECIPE_DIR%\cmake-policy.patch
if errorlevel 1 exit 1

:: tools/dev_tools is a symlink, but this doesn't work on Windows, so copy the
:: original contents
copy modules\rmf\dependency\RMF\tools\dev_tools\* tools\dev_tools\
if errorlevel 1 exit 1
mkdir tools\dev_tools\python_tools
copy modules\rmf\dependency\RMF\tools\dev_tools\python_tools\* tools\dev_tools\python_tools\
if errorlevel 1 exit 1

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch -DCMAKE_INSTALL_PREFIX="%LIBRARY%" -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR%" -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DWIN32 /DGSL_DLL %EXTRA_CXX_FLAGS%" -G "NMake Makefiles" ..
if errorlevel 1 exit 1
nmake
if errorlevel 1 exit 1
nmake install

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
