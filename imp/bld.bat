echo on

echo "Resolve symlinks"

:: tools/dev_tools is a symlink, but many Windows variants don't support
:: links, so copy the original contents if necessary
IF NOT EXIST "tools\dev_tools\README.md" (
  dir tools
  rename tools\dev_tools dev_tools.old
  if errorlevel 1 exit 1
  mkdir tools\dev_tools
  if errorlevel 1 exit 1
  copy modules\rmf\dependency\RMF\tools\dev_tools\* tools\dev_tools\
  if errorlevel 1 exit 1
  mkdir tools\dev_tools\python_tools
  if errorlevel 1 exit 1
  copy modules\rmf\dependency\RMF\tools\dev_tools\python_tools\* tools\dev_tools\python_tools\
  if errorlevel 1 exit 1
)

echo "Build app wrapper"

:: build app wrapper
copy "%RECIPE_DIR%\app_wrapper.c" .
cl app_wrapper.c shell32.lib
if errorlevel 1 exit 1

mkdir build
cd build

:: Help CMake to find CGAL
set CGAL_DIR=%PREFIX%\Library\lib\cmake\CGAL

:: Help CMake to find OpenCV
python "%RECIPE_DIR%\find_opencv_libs.py" "%PREFIX%"
if errorlevel 1 exit 1

:: Avoid running out of memory (particularly on 32-bit) by splitting up IMP.cgal
set PERCPPCOMP="-DIMP_PER_CPP_COMPILATION=cgal"

:: Don't build the scratch module
set DISABLED="scratch"

:: We use the conda boost package, which includes
:: zlib support, but defining BOOST_ALL_DYN_LINK (below) makes boost try to
:: link against boost_zlib*.lib, which doesn't exist. Override this by
:: explicitly naming the boost library to link against - since there isn't
:: one, link against kernel32 instead (which pretty much everything links
:: against, so this doesn't introduce an extra dependency)

cmake -DCMAKE_PREFIX_PATH="%PREFIX:\=/%;%PREFIX:\=/%\Library" ^
      -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=%DISABLED% ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX:\=/%" ^
      -DCMAKE_INSTALL_LIBDIR=bin ^
      -DCMAKE_INSTALL_CMAKEDIR="lib/cmake/IMP" ^
      -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR:\=/%" ^
      -DIMP_USE_SYSTEM_RMF=on -DIMP_USE_SYSTEM_IHM=on ^
      -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DH5_BUILT_AS_DYNAMIC_LIB /DPROTOBUF_USE_DLLS /DWIN32 /DGSL_DLL /DMSMPI_NO_DEPRECATE_20 /bigobj /DBOOST_ZLIB_BINARY=kernel32" ^
      %PERCPPCOMP% -G Ninja ..
if errorlevel 1 exit 1

:: Make sure all modules we asked for were found (this is tested for
:: in the final package, but quicker to abort here if they're missing)
python "%RECIPE_DIR%\check_disabled_modules.py" %DISABLED%
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

:: Add wrappers to path for each Python command line tool
:: (all files without an extension)
cd bin
for /f %%f in ('dir /b *.') do copy "%SRC_DIR%\app_wrapper.exe" "%PREFIX%\Library\bin\%%f.exe"
if errorlevel 1 exit 1

:: Don't distribute example application
del "%LIBRARY_PREFIX%\bin\imp_example_app.exe"
