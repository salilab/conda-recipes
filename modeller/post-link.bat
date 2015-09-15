@echo off
set MODTOP=%PREFIX%\Library\modeller
set CONFIG=%MODTOP%\modlib\modeller\config.py

if "%KEY_MODELLER%" == "" (
  echo(
  echo Edit %CONFIG%
  echo and replace XXXX with your Modeller license key,
  echo or set the KEY_MODELLER environment variable before running 'conda install'.
  echo(
) else (
  echo install_dir = r'%MODTOP%' > "%CONFIG%"
  echo license = r'%KEY_MODELLER%' >> "%CONFIG%"
)
