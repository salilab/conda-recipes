cd src\gsl\1.8\gsl-1.8\VC8

:: convert ancient .vcproj files to newer .vcxproj format (except for Visual
:: Studio 2008, which fails to upgrade them)
if "%VisualStudioVersion%" == "14.0" (
  devenv /upgrade copy_gsl_headers\copy_gsl_headers.vcproj
  if errorlevel 1 exit 1
  devenv /upgrade libgslcblas\libgslcblas.vcproj
  if errorlevel 1 exit 1
  devenv /upgrade libgsl\libgsl.vcproj
  if errorlevel 1 exit 1
) else if "%VisualStudioVersion%" == "" (
  copy %RECIPE_DIR%\proj_vc9\copy_gsl_headers.vcproj copy_gsl_headers\copy_gsl_headers.vcproj
  if errorlevel 1 exit 1
  copy %RECIPE_DIR%\proj_vc9\libgslcblas.vcproj libgslcblas\libgslcblas.vcproj
  if errorlevel 1 exit 1
  copy %RECIPE_DIR%\proj_vc9\libgsl.vcproj libgsl\libgsl.vcproj
  if errorlevel 1 exit 1
  copy %RECIPE_DIR%\proj_vc9\install_libgsl.vcproj install_libgsl\install_libgsl.vcproj
  if errorlevel 1 exit 1
  copy %RECIPE_DIR%\proj_vc9\libgsl.sln libgsl.sln
  if errorlevel 1 exit 1
) else (
  vcupgrade copy_gsl_headers\copy_gsl_headers.vcproj
  if errorlevel 1 exit 1
  vcupgrade libgslcblas\libgslcblas.vcproj
  if errorlevel 1 exit 1
  vcupgrade libgsl\libgsl.vcproj
  if errorlevel 1 exit 1
)

:: vcupgrade doesn't work on .sln files, and misses adding ProjectReferences
:: to the .vcxproj files, so hack them
if "%VisualStudioVersion%" == "" (
  set PROJEXT=vcproj
) else (
  set PROJEXT=vcxproj
  python %RECIPE_DIR%\add_proj_ref.py libgsl\libgsl.%PROJEXT%
  if errorlevel 1 exit 1
  python %RECIPE_DIR%\add_proj_ref.py libgslcblas\libgslcblas.%PROJEXT%
  if errorlevel 1 exit 1
)

if "%ARCH%" == "64" (
  :: seems to be required otherwise it tries to build for Win32
  set platform=x64
  :: hack the project files for 64-bit (replace "Win32" with "x64")
  python %RECIPE_DIR%\make_proj_64bit.py copy_gsl_headers\copy_gsl_headers.%PROJEXT%
  if errorlevel 1 exit 1
  python %RECIPE_DIR%\make_proj_64bit.py libgslcblas\libgslcblas.%PROJEXT%
  if errorlevel 1 exit 1
  python %RECIPE_DIR%\make_proj_64bit.py libgsl\libgsl.%PROJEXT%
  if errorlevel 1 exit 1
  if "%VisualStudioVersion%" == "" (
    python %RECIPE_DIR%\make_proj_64bit.py install_libgsl\install_libgsl.%PROJEXT%
    if errorlevel 1 exit 1
    python %RECIPE_DIR%\make_proj_64bit.py libgsl.sln
    if errorlevel 1 exit 1
  )
)

if "%VisualStudioVersion%" == "" (
  msbuild libgsl.sln /property:Configuration=Release-DLL
) else (
  msbuild libgsl\libgsl.%PROJEXT% /property:Configuration=Release-DLL
)

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
