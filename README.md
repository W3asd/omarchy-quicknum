# Omarchy QuickNum ⚡🔢

[![Omarchy Plugin](https://img.shields.io/badge/Omarchy-Quattro%20Plugin-blue?style=flat-square)](https://omarchy.org)
[![Platform](https://img.shields.io/badge/Arch%20Linux-Hyprland-brightgreen?style=flat-square)](https://hyprland.org)
[![Quickshell](https://img.shields.io/badge/Powered%20by-Quickshell-orange?style=flat-square)](https://quickshell.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

**Omarchy QuickNum** ist ein minimalistisches Open-Source-Plugin für [Omarchy](https://omarchy.org/) (Arch Linux & Hyprland). Es erweitert das native Anwendungs- und Befehlsmenü um eine latenzfreie Ziffern-Direktsteuerung (1 bis 9) mit exakt rechtsbündigen Indikatoren für kompromisslose tastaturbasierte Workflows.

---

## 🚀 Highlights & Funktionsweise

### 1. ⚡ Natives Overlay
* Vollständig in die bestehende Quickshell- und IPC-Architektur von Omarchy integriert.
* Startet latenzfrei beim Betätigen des Standard-Shortcuts **`SUPER + SPACE`** (oder über die Top-Bar).
* Da es als `clonedFrom: "omarchy.menu"` deklariert ist, ersetzt es das Standardmenü nahtlos, ohne dass bestehende Hyprland-Bindings manuell umkonfiguriert werden müssen.

### 2. 🎯 Rechtsbündige Indikatoren (1 bis 9)
* An jedem der ersten 9 Listeneinträge wird ein dezenter, typografisch optimierter Indikator platziert.
* **Absolut saubere Ausrichtung:** Die Zahlenbadges sind fest am rechten Rand des Menüs verankert und bilden eine exakte vertikale Linie – unabhängig davon, wie lang der jeweilige Titel oder die Beschreibung ist.
* Lange Texte werden automatisch mit Auslassungspunkten (`...`) trunkiert, sodass der Zahlenindikator niemals verdeckt oder verschoben wird.
* Untermenü-Pfeile (`›`) und Badges fügen sich harmonisch in das Omarchy-Designsystem ein.

### 3. ⌨️ Direktsteuerung per Tastatur & Numpad
* **Einzeltasten-Ausführung:** Ein einfacher Druck auf eine Zifferntaste (`1`–`9`) oder das Ziffernpad (**Numpad**) wählt den entsprechenden Eintrag sofort aus und führt ihn unverzüglich aus – ganz ohne Maus oder zeitraubendes Navigieren mit den Pfeiltasten.
* **Baum-Navigation im Schnellgang:** Durch das Drücken von Ziffernfolgen (z. B. `3` für *Power* ➔ `1` für *Lock Screen*) navigieren Sie in Millisekunden durch verschachtelte Menüstrukturen.
* **Intelligente Suche:** Beim Tippen von Buchstaben filtert das Menü wie gewohnt. Die Ziffern 1–9 passen sich dynamisch den gefilterten Suchtreffern an.

---

## 📦 Repository-Struktur

```
omarchy-quicknum/
├── manifest.json            # Omarchy Plugin-Manifest (Schema v1, clonedFrom: omarchy.menu)
├── Menu.qml                 # Haupt-Overlay mit QuickNum Key-Handling & Layout
├── QuickNumIndicator.qml    # Rechtsbündige Zahlen-Badges im Omarchy-Farbschema
├── MenuModel.js             # High-Performance JSONC Parser & Search Engine
├── BarWidget.qml            # Optionales Bar-Widget für die Omarchy-Leiste
├── bin/
│   ├── omarchy-quicknum     # CLI-Controller (toggle, summon, refresh, ping)
│   └── install.sh           # Lokales Installations- & Aktivierungs-Skript
├── hypr/
│   └── quicknum.lua         # Hyprland-Konfigurationsvorlage für Custom Bindings
├── tests/
│   └── validate.sh          # Test- & Validierungs-Suite für CI/CD
├── LICENSE                  # MIT-Lizenz
└── README.md                # Dokumentation
```

---

## 📥 Installation

### Methode 1: Über den Omarchy Plugin-Manager (Empfohlen)

```bash
omarchy plugin add https://github.com/W3asd/omarchy-quicknum.git --enable --yes
```

### Methode 2: Manuelle Installation / Lokale Entwicklung

Klonen oder kopieren Sie dieses Repository nach `~/.config/omarchy/plugins/quicknum`:

```bash
# Repository klonen
git clone https://github.com/W3asd/omarchy-quicknum.git ~/.config/omarchy/plugins/quicknum

# Plugin in der Shell neu einlesen und aktivieren
omarchy-shell shell rescanPlugins
omarchy plugin enable quicknum
```

Alternativ führen Sie einfach das mitgelieferte Installationsskript aus:
```bash
./bin/install.sh
```

---

## 🎮 Tastatursteuerung & Shortcuts

| Taste / Shortcut | Aktion |
| :--- | :--- |
| **`SUPER + SPACE`** | Öffnet / schließt das QuickNum Menü (Standard-Binding) |
| **`1` bis `9`** | Führt den jeweiligen Listeneintrag (1–9) sofort aus |
| **Numpad `1` bis `9`** | Führt den Eintrag (1–9) auch während der aktiven Textsuche direkt aus |
| **`A`–`Z`** | Filtert die Liste per Volltextsuche |
| **`Enter` / `Return`** | Führt den aktuell markierten Eintrag aus |
| **`Backspace` / `Links`** | Geht eine Menüebene zurück (wenn Suchfeld leer ist) |
| **`Esc`** | Leert das Suchfeld oder schließt das Menü |
| **`Pfeil Oben` / `Unten`** | Schrittweise Navigation in der Liste |

---

## ⚙️ Anpassungsmöglichkeiten

In `Menu.qml` stehen folgende Eigenschaften zur Feineinstellung bereit:

* `quickNumEnabled` (Standard: `true`): Schaltet die Ziffernsteuerung ein oder aus.
* `quickNumInSearch` (Standard: `true`): Ziffern 1–9 lösen auch bei gefilterten Treffern sofort die Aktion aus.
* `quickNumBadgeStyle` (Standard: `"badge"`): Wählbar zwischen `"badge"` (dezente Box mit Rand) und `"minimal"` (reine Ziffer ohne Rahmen).

---

## 🧪 Validierung & Tests

Das Repository enthält automatisierte Tests zur Verifizierung der Konformität mit dem Omarchy Plugin-Standard:

```bash
./tests/validate.sh
```

Prüft:
* Manifest-Schema über `omarchy plugin validate`
* Existenz aller geforderten EntryPoints
* Validität von JSON und JavaScript-Syntax

---

## 📄 Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.
Open-Source für die Omarchy-, Hyprland- und Arch Linux-Community.

