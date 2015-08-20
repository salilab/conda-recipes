:: extract zlib source for iostreams filter
pushd %RECIPE_DIR%
if errorlevel 1 exit 1
tar -xvf zlib-1.2.8.tar
if errorlevel 1 exit 1
popd

REM Start with boost.build bootstrap
echo This requires to have Visual Studio C++ compiler installed because
echo Boost build system (bjam) can't be compiled with MinGW at
echo the moment
call bootstrap.bat
if errorlevel 1 exit 1

if "%ARCH%" == "64" (
  set EXTRA_FLAGS=address-model=64
) else (
  set EXTRA_FLAGS=
)

REM Build step
bjam %EXTRA_FLAGS% --build-dir=buildboost variant=release threading=multi link=shared --prefix=%LIBRARY_PREFIX% -sNO_ZLIB=0 -sZLIB_SOURCE=%RECIPE_DIR%\zlib-1.2.8 install
if errorlevel 1 exit 1

rmdir /S /Q %RECIPE_DIR%\zlib-1.2.8
if errorlevel 1 exit 1

REM Install fix-up for a non version-specific boost include
move %LIBRARY_INC%\boost-1_57\boost %LIBRARY_INC%
