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
rem Ausnahme (Gesamtpruefung 03.11. FR-2): ein eigener Upload, dessen Push beim
rem letzten Lauf gescheitert ist (z. B. kein Netz). Der Commit liegt dann noch
rem hier und wuerde sonst JEDEN weiteren Lauf als "alter Klon" abbrechen.
rem Erkannt wird er am GitHub-Stand von VOR diesem fetch (ALT_U):
rem   - GitHub hat seither nur vorgespult (ALT_U steckt im neuen GitHub-Stand),
rem   - unsere Commits sitzen direkt auf ALT_U, ohne Merge,
rem   - und sie aendern nur Dateien im Ordner adventskalender/.
rem Dann wird nachgeschoben; alles andere bleibt "fremde Geschichte" = Abbruch.
set "ALT_U="
for /f %%h in ('git rev-parse @{u}') do set ALT_U=%%h
git fetch origin || goto fehler
for /f %%n in ('git rev-list --count @{u}..HEAD') do set EIGENE=%%n
if "%EIGENE%"=="0" goto vorspulen

if not defined ALT_U goto fremd
git merge-base --is-ancestor %ALT_U% @{u} || goto fremd
git merge-base --is-ancestor %ALT_U% HEAD || goto fremd
for /f %%n in ('git rev-list --count --merges %ALT_U%..HEAD') do set MERGES=%%n
if not "%MERGES%"=="0" goto fremd
set "FREMDDATEI="
for /f "delims=" %%f in ('git -c core.quotepath^=off log --no-renames --format^= --name-only %ALT_U%..HEAD') do (
  echo %%f| findstr /b /c:"adventskalender/" >nul || set "FREMDDATEI=%%f"
)
if defined FREMDDATEI goto fremd

echo.
echo Der letzte Upload ist nicht bei GitHub angekommen ^(%EIGENE% Commit^(s^), nur
echo im Ordner adventskalender^). Er wird jetzt nachgeschoben.
rem Hat GitHub inzwischen Neues (z. B. Quiz), die eigenen Commits obendrauf
rem setzen. --autostash: noch nicht committete Aenderungen bleiben erhalten.
for /f %%h in ('git rev-parse @{u}') do set NEU_U=%%h
if "%NEU_U%"=="%ALT_U%" goto nachschieben
git rebase --autostash @{u}
if errorlevel 1 (
  git rebase --abort
  echo *** Nachschieben ging nicht ohne Konflikt - nichts hochgeladen. ***
  goto fehler
)
:nachschieben
git push || goto fehler
echo Nachgeschoben.
echo.
goto vorspulen

:fremd
echo.
echo *** ACHTUNG: Dieser Ordner hat %EIGENE% Commit^(s^), die es auf GitHub nicht gibt. ***
echo Das ist meist ein alter Klon mit der Geschichte von vor dem Bereinigen.
echo NICHT hochladen. Ordner beiseitelegen und neu klonen:
echo   git clone https://github.com/Tecko1985/tecko1985.github.io.git
echo.
pause
exit /b 1

:vorspulen
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
