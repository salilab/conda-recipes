set MODTOP=%LIBRARY_PREFIX%\modeller
if "%ARCH%" == "64" (
  set EXETYPE=x86_64-w64
) else (
  set EXETYPE=i386-w32
)

move lib\%EXETYPE%\python%PY_VER%\_modeller.pyd "%SP_DIR%\"
if errorlevel 1 exit 1

move lib\%EXETYPE%\libmodeller*.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\libsaxs.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\libifcoremd.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\libmmd.dll "%PREFIX%\"
if errorlevel 1 exit 1

:: iconv, hdf5_hl, hdf5, intl, libglib-2.0-0, zlib1 copy but need to rename
:: so we don't conflict with other DLLs (e.g. the conda hdf5 package)

if "%ARCH%" == "32" (
  move lib\%EXETYPE%\iconv.dll "%PREFIX%\"
  if errorlevel 1 exit 1
  move lib\%EXETYPE%\intl.dll "%PREFIX%\"
  if errorlevel 1 exit 1
) else (
  move lib\%EXETYPE%\libintl-8.dll "%PREFIX%\"
  if errorlevel 1 exit 1
)
move lib\%EXETYPE%\hdf5.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\hdf5_hl.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\libglib-2.0-0.dll "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\zlib1.dll "%PREFIX%\"
if errorlevel 1 exit 1

move lib\%EXETYPE%\mod*.exe "%PREFIX%\"
if errorlevel 1 exit 1
move lib\%EXETYPE%\python23.dll "%PREFIX%\"
if errorlevel 1 exit 1

:: 64-bit uses msvcr110, so must pull that in (not in Anaconda)
if "%ARCH%" == "64" (
  move lib\%EXETYPE%\msvcr110.dll "%PREFIX%\"
  if errorlevel 1 exit 1
)

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

:: Make config.py (note; path is wrong in Modeller error message if license
:: is incorrect)
echo install_dir = r'%MODTOP%' > "%MODTOP%\modlib\modeller\config.py"
echo license = r'XXXX' >> "%MODTOP%\modlib\modeller\config.py"
