:: We use Anaconda's build of boost 1.60, which includes
:: zlib support, but defining BOOST_ALL_DYN_LINK (below) makes boost try to
:: link against boost_zlib*.lib, which doesn't exist. Override this by
:: explicitly naming the boost library to link against - since there isn't
:: one, link against kernel32 instead (which pretty much everything links
:: against, so this doesn't introduce an extra dependency)
set EXTRA_CXX_FLAGS=/bigobj -DBOOST_ZLIB_BINARY=kernel32

mkdir build
cd build

:: Don't waste time looking for a Python major version we know isn't right
set USE_PYTHON2=off
:: Help cmake to find NumPy in Anaconda location
set NUMPY_INC="-DPython3_NumPy_INCLUDE_DIR=%BUILD_PREFIX%\lib\site-packages\numpy\core\include"

cmake -DUSE_PYTHON2=%USE_PYTHON2% %NUMPY_INC% -DCMAKE_PREFIX_PATH="%BUILD_PREFIX:\=/%;%BUILD_PREFIX:\=/%\Library" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" -DCMAKE_INSTALL_PYTHONDIR="%SP_DIR%" -DCMAKE_CXX_FLAGS="/DBOOST_ALL_DYN_LINK /EHsc /D_HDF5USEDLL_ /DH5_BUILT_AS_DYNAMIC_LIB /DWIN32 %EXTRA_CXX_FLAGS%" -DHDF5_LIBRARIES="%BUILD_PREFIX:\=/%/Library/lib/hdf5.lib" -DHDF5_FOUND=TRUE -DHDF5_INCLUDE_DIRS="%BUILD_PREFIX:\=/%/Library/include" -DHDF5_INCLUDE_DIR="%BUILD_PREFIX:\=/%/Library/include" -G "NMake Makefiles" ..
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
