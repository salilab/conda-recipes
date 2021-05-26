:: We use Anaconda's build of boost 1.60, which includes
:: zlib support, but defining BOOST_ALL_DYN_LINK (below) makes boost try to
:: link against boost_zlib*.lib, which doesn't exist. Override this by
:: explicitly naming the boost library to link against - since there isn't
:: one, link against kernel32 instead (which pretty much everything links
:: against, so this doesn't introduce an extra dependency)
set EXTRA_CXX_FLAGS=/bigobj -DBOOST_ZLIB_BINARY=kernel32

:: tools/dev_tools is a symlink, but this doesn't always work on Windows,
:: so copy the original contents
rd /q /s tools\dev_tools
if errorlevel 1 exit 1
mkdir tools\dev_tools
if errorlevel 1 exit 1
copy modules\rmf\dependency\RMF\tools\dev_tools\* tools\dev_tools\
if errorlevel 1 exit 1
mkdir tools\dev_tools\python_tools
copy modules\rmf\dependency\RMF\tools\dev_tools\python_tools\* tools\dev_tools\python_tools\
if errorlevel 1 exit 1

:: add Python script to fix npctransport protobuf headers
copy "%RECIPE_DIR%\patch_protoc.py" modules\npctransport\patch_protoc.py
if errorlevel 1 exit 1

:: build app wrapper
copy "%RECIPE_DIR%\app_wrapper.c" .
cl app_wrapper.c shell32.lib
if errorlevel 1 exit 1

:: add path to Python .lib for Python 2.7 builds to help build python-ihm
if "%PY3K%" == "0" (
  set OLDPYTHON="-DPYTHON_LIBRARIES=%PREFIX:\=/%/libs/python27.lib"
)

mkdir build
cd build

:: Help cmake to find CGAL
set CGAL_DIR=%PREFIX%\Library\lib\cmake\CGAL

:: Help cmake to find OpenCV
python "%RECIPE_DIR%\find_opencv_libs.py" "%PREFIX%"
if errorlevel 1 exit 1

:: Avoid running out of memory (particularly on 32-bit) by splitting up IMP.cgal
set PERCPPCOMP="-DIMP_PER_CPP_COMPILATION=cgal"

:: VS2008 throws an internal compiler error trying to compile isd_all, so
:: split into separate files
if "%CONDA_PY%" == "27" (
  set PERCPPCOMP="-DIMP_PER_CPP_COMPILATION=isd:cgal"
)

:: Don't waste time looking for a Python major version we know isn't right
set USE_PYTHON2=on
if "%PY3K%" == "1" (
  set USE_PYTHON2=off
)

set SYS_IHM_RMF=on
if "%CONDA_PY%" == "27" (
  :: ihm and RMF aren't built for Python 2, so use those bundled with
  :: IMP instead
  set SYS_IHM_RMF=off
)

cmake -DUSE_PYTHON2=%USE_PYTHON2% %OLDPYTHON% ^
      -DCMAKE_PREFIX_PATH="%PREFIX:\=/%;%PREFIX:\=/%\Library" ^
      -DCMAKE_BUILD_TYPE=Release -DIMP_DISABLED_MODULES=scratch ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR:\=/%" ^
      -DIMP_USE_SYSTEM_RMF=%SYS_IHM_RMF% ^
      -DIMP_USE_SYSTEM_IHM=%SYS_IHM_RMF% ^
      -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DH5_BUILT_AS_DYNAMIC_LIB /DPROTOBUF_USE_DLLS /DWIN32 /DGSL_DLL /DMSMPI_NO_DEPRECATE_20 %EXTRA_CXX_FLAGS%" ^
      %PERCPPCOMP% -G Ninja ..
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

:: Patch IMP Python module to add paths containing Anaconda DLLs to search path
python "%RECIPE_DIR%\add_dll_search_path.py" "%SP_DIR%\IMP" "%PREFIX%\Library\bin" "%PREFIX%\Library\lib" "%SP_DIR%\IMP\__init__.py"
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
