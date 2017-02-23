@echo off
set MODTOP=%PREFIX%\Library\modeller
set CONFIG=%MODTOP%\modlib\modeller\config.py
set OUT=%PREFIX%\.messages.txt

if "%KEY_MODELLER%" == "" (
  echo( >> "%OUT%"
  echo Edit %CONFIG% >> "%OUT%"
  echo and replace XXXX with your Modeller license key, >> "%OUT%"
  echo or set the KEY_MODELLER environment variable before running 'conda install'. >> "%OUT%"
  echo( >> "%OUT%"
) else (
  echo install_dir = r'%MODTOP%' > "%CONFIG%"
  echo license = r'%KEY_MODELLER%' >> "%CONFIG%"
)
