:: Find packages in Anaconda locations
set CMAKE_PREFIX_PATH=%LIBRARY_PREFIX%:%TEMP%

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

:: put libs and binaries in right location
cd "%LIBRARY_PREFIX%"
mkdir bin
mkdir lib
move x86\vc10\bin\* bin\
if errorlevel 1 exit 1
move x86\vc10\lib\* lib\
if errorlevel 1 exit 1
rd x86\vc10\lib
rd x86\vc10\bin
rd x86\vc10
rd x86
if errorlevel 1 exit 1
