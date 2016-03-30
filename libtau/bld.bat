if "%ARCH%" == "64" (
  if "%VisualStudioVersion%" == "14.0" (
    set TAU_LIB="Windows.x86_64.vc14"
  ) else (
    set TAU_LIB="Windows.x86_64.vc9"
  )
) else (
  if "%VisualStudioVersion%" == "14.0" (
    set TAU_LIB="Windows.i386.vc14"
  ) else (
    set TAU_LIB="Windows.i386.vc9"
  )
)

mkdir "%LIBRARY_INC%\libTAU"
if errorlevel 1 exit 1
copy lib\%TAU_LIB%\*.dll "%LIBRARY_LIB%\"
if errorlevel 1 exit 1
copy lib\%TAU_LIB%\libTAU.lib "%LIBRARY_LIB%\TAU.lib"
if errorlevel 1 exit 1
copy include\*.h "%LIBRARY_INC%\libTAU\"
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
