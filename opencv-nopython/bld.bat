:: Find packages in Anaconda locations
set CMAKE_PREFIX_PATH=%LIBRARY_PREFIX%:%TEMP%

:: Visual Studio 2009 doesn't set the version variable
if "%VisualStudioVersion%" == "" (
  set VisualStudioVersion=9
)

:: cmake looks in <incdir>/libpng, not <incdir>/libpng16, so make a temporary
:: copy
mkdir %TEMP%\include
mkdir %TEMP%\include\libpng
copy "%LIBRARY_INC%\libpng16\*" %TEMP%\include\libpng\
if errorlevel 1 exit 1


mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_opencv_python=OFF -DBUILD_JPEG=OFF -DBUILD_PNG=OFF -DBUILD_TIFF=OFF -DBUILD_ZLIB=OFF -DWITH_JASPER=OFF -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" -DWITH_CUDA=OFF -DWITH_AVFOUNDATION=OFF -DWITH_FFMPEG=OFF -DJPEG_INCLUDE_DIR:PATH="%LIBRARY_INC%" -DJPEG_LIBRARY:FILEPATH="%LIBRARY_LIB%\libjpeg.lib" -DPNG_PNG_INCLUDE_DIR="%TEMP%\include" -DPNG_LIBRARY:FILEPATH="%LIBRARY_LIB%\libpng.lib" -DZLIB_INCLUDE_DIR:PATH="%LIBRARY_INC%" -DZLIB_LIBRARY:FILEPATH="%LIBRARY_LIB%\zlib.lib" -G"NMake Makefiles" ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

if "%ARCH%" == "64" (
  set SUBDIR=x64\vc%VisualStudioVersion%
  set TOPDIR=x64
) else (
  set SUBDIR=x86\vc%VisualStudioVersion%
  set TOPDIR=x86
)
if not "%VisualStudioVersion%" == "14.0" (
  :: put libs and binaries in right location
  cd "%LIBRARY_PREFIX%"
  mkdir bin
  mkdir lib
  move %SUBDIR%\bin\* bin\
  if errorlevel 1 exit 1
  move %SUBDIR%\lib\* lib\
  if errorlevel 1 exit 1
  rd %SUBDIR%\lib
  rd %SUBDIR%\bin
  rd %SUBDIR%
  rd %TOPDIR%
  if errorlevel 1 exit 1
)
