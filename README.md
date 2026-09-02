# ↪️ Umgezogen

Weiterleitung der früheren Vereinsadresse auf das heutige Konto. Dieses Repo enthält keine App mehr — nur zwei gleich aufgebaute Seiten, die pfadgleich auf die neue Adresse springen.

**➡️ [Weiterleitung öffnen](https://tecko1985.github.io/)**

## Seiten

| Seite | Wofür |
|---|---|
| [Weiterleitung](https://tecko1985.github.io/) | Springt auf die neue Adresse |
| [Weiterleitung für Unterseiten](https://tecko1985.github.io/404.html) | Springt pfadgleich auf die neue Adresse |

Beide Dateien haben denselben Inhalt, und das mit Absicht: GitHub Pages liefert
`404.html` für jeden Pfad aus, den es hier nicht gibt — also für alle alten
Werkzeug-Adressen. `/ToolsUebersicht/` landet dadurch wieder auf
`/ToolsUebersicht/` und nicht auf der Startseite; Suchanhang und Sprungmarke
gehen mit. Der Sprung ersetzt den Verlaufseintrag, damit der Zurück-Knopf nicht
in eine Endlosschleife läuft. Zusätzlich steht eine Weiterleitung ohne
JavaScript in der Seite, die nach drei Sekunden greift.

## Nicht alles hier wird weitergeleitet

Dieses Repo bestimmt nur, was unter der **nackten** Adresse und unter
**unbekannten** Pfaden passiert. Das Konto beherbergt daneben weiterhin
Werkzeuge im privaten Bereich, jedes in einem eigenen Repo — zum Beispiel
`/kassenbuch/` und `/beleg-scanner/`. Die werden von ihren eigenen Repos
ausgeliefert und laufen an dieser Weiterleitung vorbei.

> ⚠️ Nicht zu verwechseln mit `sc1911heiligenstadt.github.io`, der Wurzel des
> Vereinsbereichs. Dort liegen Manifest, Symbole und der Service Worker der
> Werkzeug-Flotte.

## Technik

Vanilla JavaScript ohne Build-Schritt — die Dateien werden so ausgeliefert, wie sie im Repo liegen.

---

Gehörte zum 1. SC 1911 Heiligenstadt. Die Werkzeuge stehen heute in der [Tools-Übersicht](https://sc1911heiligenstadt.github.io/ToolsUebersicht/).
