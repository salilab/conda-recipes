if %ARCH% == "64" (
  set EXTRA_CXX_FLAGS=/bigobj
) else (
  set EXTRA_CXX_FLAGS=
)

:: Fix cmake paths to use / rather than \
patch -p1 < %RECIPE_DIR%\cmake-path.patch
if errorlevel 1 exit 1

:: Quiet warnings from newer cmake about policy changes
patch -p1 < %RECIPE_DIR%\cmake-policy.patch
if errorlevel 1 exit 1

:: Don't try to use os.setsid(), which isn't supported on Windows
patch -p1 < %RECIPE_DIR%\imp-session.patch
if errorlevel 1 exit 1

:: Fix compilation of RMF VMD plugin
patch -p1 < %RECIPE_DIR%\rmf-vmdplugin.patch
if errorlevel 1 exit 1

:: Don't generate module setup files containing unescaped backslashes
patch -p1 < %RECIPE_DIR%\imp-setup-module.patch
if errorlevel 1 exit 1

:: Don't fall over if we encounter paths containing spaces
patch -p1 < %RECIPE_DIR%\rmf-decorators.patch
if errorlevel 1 exit 1

:: Avoid confusion between RMF::hash_value and stdext::hash_value
patch -p1 < %RECIPE_DIR%\rmf-hash-value.patch
if errorlevel 1 exit 1

:: tools/dev_tools is a symlink, but this doesn't work on Windows, so copy the
:: original contents
copy modules\rmf\dependency\RMF\tools\dev_tools\* tools\dev_tools\
if errorlevel 1 exit 1
mkdir tools\dev_tools\python_tools
copy modules\rmf\dependency\RMF\tools\dev_tools\python_tools\* tools\dev_tools\python_tools\
if errorlevel 1 exit 1

:: build app wrapper
copy "%RECIPE_DIR%/app_wrapper.c" .
cl app_wrapper.c shell32.lib
if errorlevel 1 exit 1

mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch -DHDF5_C_LIBRARY="%LIBRARY_LIB%\hdf5.lib" -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR%" -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DWIN32 /DGSL_DLL %EXTRA_CXX_FLAGS%" -DOPENCV22_LIBRARIES="%LIBRARY_LIB%\opencv_core249.lib;%LIBRARY_LIB%\opencv_imgproc249.lib;%LIBRARY_LIB%\opencv_highgui249.lib;%LIBRARY_LIB%\opencv_contrib249.lib" -G "NMake Makefiles" ..
if errorlevel 1 exit 1
nmake
if errorlevel 1 exit 1
nmake install

if errorlevel 1 exit 1

:: Patch IMP Python module to add paths containing Anaconda DLLs to search path
python "%RECIPE_DIR%\add_dll_search_path.py" "%SP_DIR%\IMP" "%LIBRARY_BIN%" "%LIBRARY_LIB%" "%SP_DIR%\IMP\__init__.py"
if errorlevel 1 exit 1

:: Add wrappers to path for each command line tool
cd bin
:: Handle Python tools (all files without an extension)
for /f %%f in ('dir /b *.') do copy "%SRC_DIR%\app_wrapper.exe" "%PREFIX%\%%f.exe"
if errorlevel 1 exit 1

:: Handle C++ tools (all files with .exe extension)
for /f %%f in ('dir /b *.exe') do copy "%SRC_DIR%\app_wrapper.exe" "%PREFIX%\%%f"
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
