@echo off
title Administrador de Proyectos Git
:menu
cls
echo ========================================
echo    ADMINISTRADOR DE PROYECTOS GIT
echo ========================================
echo.
echo 1. Actualizar proyectos (Git Pull)
echo 2. Grabar y subir cambios (Git Push)
echo 3. Ver estado de proyectos
echo 4. Salir
echo.
set /p choice=Selecciona una opcion (1-4): 

if "%choice%"=="1" goto pull
if "%choice%"=="2" goto push
if "%choice%"=="3" goto status
if "%choice%"=="4" goto exit
goto menu

:pull
echo.
echo Actualizando proyectos...
wsl bash /mnt/c/DISCO\ DURO/proyectos/update_projects.sh
echo.
pause
goto menu

:push
echo.
echo Grabando y subiendo cambios...
wsl bash /mnt/c/DISCO\ DURO/proyectos/push_projects.sh
echo.
pause
goto menu

:status
echo.
echo Estado de los proyectos:
wsl bash -c "cd '/mnt/c/DISCO DURO/proyectos/Publicador/Publicador' && echo '=== Publicador ===' && git status --short && echo 'Rama:' $(git branch --show-current) && echo '---'"
wsl bash -c "cd '/mnt/c/DISCO DURO/proyectos/subocasoft/subocasoft' && echo '=== Subocasoft ===' && git status --short && echo 'Rama:' $(git branch --show-current) && echo '---'"<<<<<<< HEAD
wsl bash -c "cd '/mnt/c/DISCO DURO/proyectos/factuzam/Factuzam' && echo '=== Factuzam ===' && git status --short && echo 'Rama:' $(git branch --show-current) && echo '---'"
wsl bash -c "cd '/mnt/c/DISCO DURO/proyectos/OdaVeriFactu/OdaVeriFactu' && echo '=== OdaVeriFactu ===' && git status --short && echo 'Rama:' $(git branch --show-current) && echo '---'"
echo.
pause
goto menu

:exit
exit
