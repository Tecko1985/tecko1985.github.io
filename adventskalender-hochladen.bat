@echo off
chcp 65001 >nul
title Adventskalender hochladen
cd /d "%~dp0"

echo.
echo === Adventskalender hochladen ===
echo.

rem --- 1. Stimmt dieser Ordner mit GitHub ueberein? -------------------------
rem Ein alter Klon (Geschichte von vor dem Bereinigen am 01.11.) darf NICHT
rem hochladen: sonst kaemen entfernte alte Fassungen zurueck auf GitHub.
git fetch origin || goto fehler
for /f %%n in ('git rev-list --count @{u}..HEAD') do set EIGENE=%%n
if not "%EIGENE%"=="0" (
  echo.
  echo *** ACHTUNG: Dieser Ordner hat %EIGENE% Commit^(s^), die es auf GitHub nicht gibt. ***
  echo Das ist meist ein alter Klon mit der Geschichte von vor dem Bereinigen.
  echo NICHT hochladen. Ordner beiseitelegen und neu klonen:
  echo   git clone https://github.com/Tecko1985/tecko1985.github.io.git
  echo.
  pause
  exit /b 1
)
rem Nur vorspulen, nie mischen oder umschreiben.
git merge --ff-only @{u} || goto fehler

rem --- 2. Gibt es im Ordner adventskalender etwas Neues? ---------------------
git status --short -- adventskalender
git diff --quiet HEAD -- adventskalender
set GEAENDERT=%errorlevel%
git ls-files --others --exclude-standard -- adventskalender | findstr . >nul && set GEAENDERT=1

if "%GEAENDERT%"=="0" (
  echo Keine Aenderungen im Ordner adventskalender - nichts zu tun.
  echo.
  pause
  exit /b 0
)

echo.
set "NACHRICHT="
set /p "NACHRICHT=Was hast du geaendert? (Enter = Standardtext): "
if "%NACHRICHT%"=="" set "NACHRICHT=Adventskalender aktualisiert"

rem --- 3. Nur den Ordner adventskalender committen -------------------------
rem "-- adventskalender" am commit: anderes, schon Vorgemerktes (z. B. Quiz)
rem bleibt draussen.
git add -- adventskalender || goto fehler
git commit -m "%NACHRICHT%" -- adventskalender || goto fehler
git push || goto fehler

echo.
echo Fertig! In 1-2 Minuten live unter:
echo https://tecko1985.github.io/adventskalender/
echo (Falls noch alt: Seite mit Strg+F5 neu laden.)
echo.
pause
exit /b 0

:fehler
echo.
echo *** Da ist etwas schiefgegangen - Meldung oben lesen. ***
echo.
pause
exit /b 1
