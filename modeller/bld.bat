set MODTOP=%LIBRARY_PREFIX%\modeller
if "%ARCH%" == "64" (
  set EXETYPE=x86_64-w64
) else (
  set EXETYPE=i386-w32
)

set SOVERSION=11

:: temporarily rename to avoid conflict with python%PY_VER%\_modeller.pyd
move lib\%EXETYPE%\python2.3\_modeller.pyd lib\%EXETYPE%\python2.3\_modeller23.pyd
if errorlevel 1 exit 1

:: Install bundled DLLs but rename them to avoid potential conflicts with
:: other Anaconda packages (e.g. the conda hdf5 package). We do this because
:: DLLs either need to be in the PATH or in the same directory as the binary
:: that uses them. We can't do the latter because the modXXX binary, the
:: libmodeller DLL, and the two identically named _modeller.pyd extensions
:: cannot all be in the same directory, and if we put the DLLs in the PATH, they
:: are visible globally and could conflict.
if "%ARCH%" == "32" (
  :: 32-bit uses msvcr100, which is provided by the conda vs2010_runtime package
  python "%RECIPE_DIR%\install_bins.py" lib\%EXETYPE% "%PREFIX%" iconv.dll intl.dll hdf5.dll hdf5_hl.dll libglib-2.0-0.dll zlib1.dll libifcoremd.dll libmmd.dll --norename libmodeller%SOVERSION%.dll libsaxs.dll mod%PKG_VERSION%.exe python%PY_VER%\_modeller.pyd python2.3\_modeller23.pyd
  if errorlevel 1 exit 1
) else (
  :: 64-bit uses msvcr110, so must pull that in (not in Anaconda)
  python "%RECIPE_DIR%\install_bins.py" lib\%EXETYPE% "%PREFIX%" libintl-8.dll hdf5.dll hdf5_hl.dll libglib-2.0-0.dll zlib1.dll libifcoremd.dll libmmd.dll --norename msvcr110.dll libmodeller%SOVERSION%.dll libsaxs.dll mod%PKG_VERSION%.exe python%PY_VER%\_modeller.pyd python2.3\_modeller23.pyd
  if errorlevel 1 exit 1
)

:: Put _modeller.pyd in correct location
move "%PREFIX%\_modeller.pyd" "%SP_DIR%\"
if errorlevel 1 exit 1

mkdir "%MODTOP%"
if errorlevel 1 exit 1

move ChangeLog "%MODTOP%\ChangeLog.txt"
if errorlevel 1 exit 1
move README.txt "%MODTOP%\"
if errorlevel 1 exit 1
move modlib "%MODTOP%\"
if errorlevel 1 exit 1
move src "%MODTOP%\"
if errorlevel 1 exit 1
move bin "%MODTOP%\"
if errorlevel 1 exit 1
move doc "%MODTOP%\"
if errorlevel 1 exit 1
move examples "%MODTOP%\"
if errorlevel 1 exit 1

:: add Modeller Python directory to Python path
echo %MODTOP%\modlib > "%SP_DIR%\modeller.pth"
if errorlevel 1 exit 1

:: add missing util\__init__.py
echo "# do nothing" > "%MODTOP%\modlib\modeller\util\__init__.py"

:: Make config.py
echo install_dir = r'%MODTOP%' > "%MODTOP%\modlib\modeller\config.py"
echo license = r'XXXX' >> "%MODTOP%\modlib\modeller\config.py"

:: make mini Python 2.3 environment so modXXX binary works
move "%PREFIX%\mod%PKG_VERSION%.exe" "%MODTOP%\modlib\mod%PKG_VERSION%-orig.exe"
if errorlevel 1 exit 1
move lib\%EXETYPE%\python23.dll "%MODTOP%\modlib\"
if errorlevel 1 exit 1
mkdir "%MODTOP%\modlib\lib"
move "%PREFIX%\_modeller23.pyd" "%MODTOP%\modlib\lib\_modeller.pyd"
if errorlevel 1 exit 1

:: make modXXX wrapper that sets MODINSTALLXXX and PYTHONHOME then calls
:: real modXXX binary
copy "%RECIPE_DIR%\mod_wrapper.c" .
cl mod_wrapper.c shell32.lib
if errorlevel 1 exit 1

copy mod_wrapper.exe "%PREFIX%\mod%PKG_VERSION%.exe"
if errorlevel 1 exit 1
