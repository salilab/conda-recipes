copy include\*.h "%LIBRARY_INC%\"
if errorlevel 1 exit 1

copy lib\*.dll "%LIBRARY_BIN%\"
if errorlevel 1 exit 1

copy lib\*.lib "%LIBRARY_LIB%\"
if errorlevel 1 exit 1
