if "%ARCH%" == "64" (
  set EXTRA_CXX_FLAGS=/bigobj
) else (
  set EXTRA_CXX_FLAGS=
)

:: tools/dev_tools is a symlink, but this doesn't work on Windows, so copy the
:: original contents
copy modules\rmf\dependency\RMF\tools\dev_tools\* tools\dev_tools\
if errorlevel 1 exit 1
mkdir tools\dev_tools\python_tools
copy modules\rmf\dependency\RMF\tools\dev_tools\python_tools\* tools\dev_tools\python_tools\
if errorlevel 1 exit 1

:: build app wrapper
copy "%RECIPE_DIR%\app_wrapper.c" .
cl app_wrapper.c shell32.lib
if errorlevel 1 exit 1

:: figure out path to Python .lib
for /f %%i in ('echo %PY_VER% ^| sed "s/\.//"') do set PY_VER_NO_DOT=%%i

mkdir build
cd build
cmake -DPYTHON_LIBRARY="%PREFIX%\libs\python%PY_VER_NO_DOT%.lib" -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch -DHDF5_C_LIBRARY="%LIBRARY_LIB%\hdf5.lib" -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR%" -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DWIN32 /DGSL_DLL %EXTRA_CXX_FLAGS%" -DOPENCV22_LIBRARIES="%LIBRARY_LIB%\opencv_core249.lib;%LIBRARY_LIB%\opencv_imgproc249.lib;%LIBRARY_LIB%\opencv_highgui249.lib;%LIBRARY_LIB%\opencv_contrib249.lib" -G "NMake Makefiles" ..
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

:: Since we built with MSVC 2012, and Anaconda only ships with the 2010 runtime,
:: copy over the runtime (should really put this in its own package)
if "%ARCH%" == "64" (
  copy C:\Windows\system32\msvc*110.dll "%PREFIX%"
)

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
