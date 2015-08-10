:: make MSVC .lib files from .def
lib /def:libfftw3-3.def
lib /def:libfftw3f-3.def
lib /def:libfftw3l-3.def

copy libfftw3-3.dll %LIBRARY_LIB%
copy libfftw3f-3.dll %LIBRARY_LIB%
copy libfftw3l-3.dll %LIBRARY_LIB%

copy libfftw3-3.lib %LIBRARY_LIB%
copy libfftw3f-3.lib %LIBRARY_LIB%
copy libfftw3l-3.lib %LIBRARY_LIB%

copy *.h %LIBRARY_INC%

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
