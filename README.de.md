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
- **Suche wie gewohnt:** Buchstaben filtern die Liste, und die Nummern passen sich den Treffern an.
- **Direkter Ersatz:** Das Manifest enthält `clonedFrom: "omarchy.menu"`.
  Bestehende Tastenkürzel (`Super + Leertaste`, `Super + Alt + Leertaste`)
  öffnen QuickNum, ohne dass du die Konfiguration änderst.

## Kompatibilität

| Omarchy | Stand |
|---|---|
| 4.0.6 | getestet |
| 4.0.x | sollte funktionieren; der Apps-Workaround ist aktiv ([Details](docs/known-issues.md)) |
| ≥ 4.5 | noch nicht getestet; der dortige Fix in Omarchy sollte den Workaround überflüssig machen |

## Installation

```bash
omarchy plugin add https://github.com/W3asd/omarchy-quicknum.git
```

Prüfe den Code. Danach wechselst du vom eingebauten Menü zu QuickNum. Es sollte nur ein Menü-Plugin aktiv sein:

```bash
omarchy plugin disable omarchy.menu
omarchy plugin enable quicknum
```

Manuell: Klone das Repository nach `~/.config/omarchy/plugins/quicknum` und
führe dann `omarchy-shell shell rescanPlugins` aus. Alternativ startest du im Repository `./bin/install.sh`.

## Deinstallieren / zurück zum eingebauten Menü

```bash
omarchy plugin disable quicknum
omarchy plugin enable omarchy.menu
```

`omarchy plugin remove quicknum` löscht zusätzlich die Dateien.

## Tasten

| Taste | Aktion |
| :--- | :--- |
| `Super + Leertaste` / `Super + Alt + Leertaste` | Menü öffnen / schließen |
| `1`–`9`, Ziffernblock `1`–`9` | Eintrag 1–9 ausführen |
| `A`–`Z` | Suchen |
| `Enter` | Markierten Eintrag ausführen |
| `Rücktaste` / `Links` | Eine Ebene zurück (wenn die Suche leer ist) |
| `Esc` | Suche leeren, danach Menü schließen |
| `Hoch` / `Runter` | Auswahl verschieben |

## Einstellungen

Diese Eigenschaften stehen oben in `Menu.qml`:

- `quickNumEnabled` (Standard `true`): Ziffernauswahl an oder aus.
- `quickNumInSearch` (Standard `true`): Die Zifferntasten wählen auch während
  einer Suche aus. Mit `false` kannst du Ziffern in die Suche tippen ([Grund](docs/known-issues.md#digits-cannot-be-typed-into-the-search-open)).
- `quickNumBadgeStyle` (Standard `"badge"`): `"badge"` oder `"minimal"`.

## Aufbau des Repositorys

```
manifest.json          Omarchy-Plugin-Manifest (clonedFrom: omarchy.menu)
Menu.qml               Menü auf Basis des eingebauten Omarchy-Menüs, plus QuickNum
MenuModel.js           Unveränderte Kopie des Omarchy-Menümodells (4.0.6)
QuickNumIndicator.qml  Nummern-Abzeichen
BarWidget.qml          Optionaler Knopf in der Leiste
bin/install.sh         Lokales Installationsskript
bin/omarchy-quicknum   Kommandozeilen-Helfer (toggle, summon, close, refresh, ping); wird nicht in den PATH installiert
hypr/quicknum.lua      Beispiel-Tastenkürzel (nur Vorlage, tut selbst nichts)
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
