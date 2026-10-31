# Omarchy QuickNum

**Deutsch** · [English](README.md)

[![Omarchy Plugin](https://img.shields.io/badge/Omarchy-plugin-blue?style=flat-square)](https://omarchy.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![KI-generiert](https://img.shields.io/badge/code-KI--generiert-lightgrey?style=flat-square)](#ki-generiert)

**QuickNum** ist ein Plugin für [Omarchy](https://omarchy.org/). Es ersetzt das
eingebaute Omarchy-Menü durch eine Fassung, in der du die ersten neun Einträge
direkt mit den Zifferntasten `1`–`9` (oder dem Ziffernblock) auswählst. Rechtsbündige Abzeichen zeigen die Nummern an.

> [!NOTE]
> <a id="ki-generiert"></a>**Dieses Projekt ist komplett KI-generiert.** Die erste Fassung entstand mit
> Google Antigravity. Fehlerbehebungen und Dokumentation entstanden mit Claude Code
> (Anthropic). Jede Änderung wird auf einem echten Omarchy-System getestet, aber
> der Code wurde nicht von Hand geschrieben. Prüfe den Code, bevor du das Plugin
> aktivierst. Plugins laufen ohne Sandbox in `omarchy-shell`.

## Funktionen

- **Zifferntasten und Ziffernblock `1`–`9`** führen den passenden Eintrag sofort
  aus. So kommst du schnell durch verschachtelte Menüs (z. B. `3` → `1`).
- **Rechtsbündige Abzeichen:** Lange Titel werden mit `…` gekürzt, damit die Abzeichen immer in einer Linie stehen.
- **Suche wie gewohnt:** Tippen filtert die Liste, und die Nummern passen sich den Treffern an.
  Sobald die Suche begonnen hat, landen Ziffern in der Suche.
- **Direkter Ersatz:** Das Manifest enthält `clonedFrom: "omarchy.menu"`.
  Bestehende Tastenkürzel (`Super + Leertaste`, `Super + Alt + Leertaste`)
  öffnen QuickNum, ohne dass du die Konfiguration änderst.

## Kompatibilität

| Omarchy | Stand |
|---|---|
| 4.0.6 | getestet (1.2.0) |
| 4.0.x | sollte funktionieren; der Apps-Workaround ist aktiv ([Details](docs/known-issues.md)) |
| ≥ 4.5 | noch nicht getestet; der dortige Fix in Omarchy sollte den Workaround überflüssig machen |

Manche Probleme kommen von Omarchy selbst, nicht von QuickNum: die leere App-Liste unter 4.0.x und ein
Ziffernblock, der nichts tippt, bis Num-Lock einmal aus- und wieder eingeschaltet wird. Die [bekannten Probleme](docs/known-issues.md#overview-omarchy-issues-that-affect-quicknum)
(Englisch) listen sie mit Links zu den Omarchy-Issues auf.

## Installation

```bash
omarchy plugin add https://github.com/W3asd/omarchy-quicknum.git
```

Prüfe den Code und schalte QuickNum dann ein. Dabei wird das eingebaute
`omarchy.menu` automatisch ausgeschaltet, und QuickNum übernimmt seinen Platz in der Leiste (getestet mit Omarchy 4.0.6):

```bash
omarchy plugin enable w3asd.quicknum
```

Manuell: Klone das Repository nach `~/.config/omarchy/plugins/w3asd.quicknum` und
führe dann `omarchy-shell shell rescanPlugins` aus. Alternativ startest du im Repository `./bin/install.sh`.

## Upgrade von 1.x

In Version 2.0 heißt die Plugin-ID nicht mehr `quicknum`, sondern `w3asd.quicknum`. Entferne die alte Installation und installiere neu:

```bash
omarchy plugin disable quicknum
omarchy plugin remove quicknum
omarchy plugin add https://github.com/W3asd/omarchy-quicknum.git
omarchy plugin enable w3asd.quicknum
```

## Deinstallieren / zurück zum eingebauten Menü

```bash
omarchy plugin disable w3asd.quicknum
```

Dabei schaltet sich das eingebaute `omarchy.menu` wieder ein. `omarchy plugin remove w3asd.quicknum` löscht zusätzlich die Dateien.

## Tasten

| Taste | Aktion |
| :--- | :--- |
| `Super + Leertaste` / `Super + Alt + Leertaste` | Menü öffnen / schließen |
| `1`–`9`, Ziffernblock `1`–`9` | Eintrag 1–9 ausführen (solange die Suche leer ist); der Ziffernblock funktioniert auch bei verstelltem Num-Lock ([Details](docs/known-issues.md#numpad-acts-as-if-numlock-were-off-after-hovering-a-window-worked-around)) |
| `A`–`Z`, danach auch `0`–`9` | Suchen |
| `Enter` | Markierten Eintrag ausführen |
| `Rücktaste` / `Links` | Eine Ebene zurück (wenn die Suche leer ist) |
| `Esc` | Suche leeren, danach Menü schließen |
| `Hoch` / `Runter` | Auswahl verschieben |

## Einstellungen

Diese Eigenschaften stehen oben in `Menu.qml`:

- `quickNumEnabled` (Standard `true`): Ziffernauswahl an oder aus.
- `quickNumInSearch` (Standard `false`): Bei `false` wählen die Zifferntasten nur,
  solange die Suche leer ist. Sobald du einen Buchstaben tippst, landen Ziffern
  in der Suche. Bei `true` wählen die Zifferntasten immer aus.
- `quickNumBadgeStyle` (Standard `"badge"`): `"badge"` oder `"minimal"`.
- `quickNumKeypadAlwaysDigits` (Standard `true`): Ziffernblock-Tasten zählen immer
  als Ziffern, auch bei verstelltem Num-Lock. Setze es auf `false`, wenn du den
  Ziffernblock mit ausgeschaltetem Num-Lock als Pfeiltasten im Menü nutzt.

## Aufbau des Repositorys

```
manifest.json          Omarchy-Plugin-Manifest (clonedFrom: omarchy.menu)
Menu.qml               Menü auf Basis des eingebauten Omarchy-Menüs, plus QuickNum
MenuModel.js           Unveränderte Kopie des Omarchy-Menümodells (4.0.6)
QuickNumIndicator.qml  Nummern-Abzeichen
BarWidget.qml          Optionaler Knopf in der Leiste
bin/install.sh         Lokales Installationsskript
bin/omarchy-quicknum   Kommandozeilen-Helfer (toggle, summon, close, refresh, ping); aus dem Repository starten, wird nicht in den PATH installiert
examples/              Optionale Hyprland-Tastenkürzel (nicht nötig)
tests/validate.sh      Prüft Manifest und Syntax
docs/                  Bekannte Probleme und Entwicklungshinweise (Englisch)
```

## Dokumentation (Englisch)

- [Bekannte Probleme](docs/known-issues.md)
- [Entwicklung und Tests](docs/development.md)
- [Änderungsprotokoll](CHANGELOG.md)
- [Mitmachen](CONTRIBUTING.md)

## Lizenz

[MIT](LICENSE). `Menu.qml` und `MenuModel.js` stammen aus
[Omarchy](https://github.com/omacom/omarchy) (MIT, © David Heinemeier Hansson).
