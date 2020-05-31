:: Cache les lignes de commandes executées dans le fichier
:: -------------------------------------------------------
@echo off

:: Vide (nettoie) l'écran de la console
:: ------------------------------------
cls

:: Titre de la console
:: -------------------
title Programme de sauvegarde des maps survival de Scrap Mechanic

:: Stockage de la date et de l'heure au moment où le script est exécuté
:: Est utilisé pour attribuer une date et une heure aux sauvegardes
:: --------------------------------------------------------------------
for /F "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set dateTime=%%a
set yr=%dateTime:~0,4%
set mon=%dateTime:~4,2%
set day=%dateTime:~6,2%
set hr=%dateTime:~8,2%
set min=%dateTime:~10,2%
set sec=%dateTime:~12,2%

cd /D C:

:: On récupère l'ID du joueur qui est différente selon les clients (PC)
:: --------------------------------------------------------------------
cd /D %APPDATA%\Axolot Games\Scrap Mechanic\User
for /D %%d in (*) do (
  set scrapUserID=%cd%\%%d
)

:: On vérifie si le dossier Backup existe déjà ou non
:: --------------------------------------------------
cd %scrapUserID%\Save
if not exist Backup (
  mkdir Backup
)

:: On récupère le chemin courant "%~dp0" où s'execute le batch, afin de pointer
:: sur l'executable "7za.exe" qui créera l'archive au format .zip
:: ----------------------------------------------------------------------------
set currentBatchPath=%~dp0
set zipApp=%currentBatchPath%7za.exe

cd Survival
%zipApp% a -tzip ..\Backup\Maps_%day%-%mon%-%yr%_%hr%-%min%-%sec%.zip -r *.* -mx5

:: Supprime une ou des sauvegardes vieilles de plusieurs jours
:: Vous pouvez changer la valeur de "daysNumber" à votre convenance
:: ----------------------------------------------------------------
cd ..\Backup
set daysNumber=7
forfiles /s /d -%daysNumber% /c "cmd /c del @file"

:: Met l'affichage en pause et cache le texte " Appuyez sur une touche pour continuer... "
:: ---------------------------------------------------------------------------------------
:: pause > nul