if %ARCH% == "64" (
  set TAU_LIB="Windows.x86_64"
) else (
  set TAU_LIB="Windows.i386"
)

mkdir %LIBRARY_INC%\libTAU
copy lib\%TAU_LIB%\*.dll %LIBRARY_LIB%
copy lib\%TAU_LIB%\*.lib %LIBRARY_LIB%
copy include\*.h %LIBRARY_INC%\libTAU

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
