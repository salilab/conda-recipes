cd src\gsl\1.8\gsl-1.8\VC8

:: convert ancient .vcproj files to newer .vcxproj format
vcupgrade copy_gsl_headers\copy_gsl_headers.vcproj
if errorlevel 1 exit 1
vcupgrade libgslcblas\libgslcblas.vcproj
if errorlevel 1 exit 1
vcupgrade libgsl\libgsl.vcproj
if errorlevel 1 exit 1

:: vcupgrade doesn't work on .sln files, and misses adding ProjectReferences
:: to the .vcxproj files, so hack them
python %RECIPE_DIR%\add_proj_ref.py libgsl\libgsl.vcxproj
python %RECIPE_DIR%\add_proj_ref.py libgslcblas\libgslcblas.vcxproj
if errorlevel 1 exit 1

msbuild libgsl\libgsl.vcxproj /property:Configuration=Release-DLL

if errorlevel 1 exit 1

mkdir "%LIBRARY_INC%\gsl"
copy ..\gsl\gsl*.h "%LIBRARY_INC%\gsl\"
copy libgslcblas\Release-DLL\libgslcblas.dll "%LIBRARY_LIB%\"
copy libgslcblas\Release-DLL\libgslcblas_dll.lib "%LIBRARY_LIB%\gslcblas.lib"
copy libgsl\Release-DLL\libgsl.dll "%LIBRARY_LIB%\"
copy libgsl\Release-DLL\libgsl_dll.lib "%LIBRARY_LIB%\gsl.lib"
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.