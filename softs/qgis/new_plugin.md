# New plugin

<!-- TOC -->

- [New plugin](#new-plugin)
    - [Création avec Plugin Builder](#création-avec-plugin-builder)
        - [Activer l'extension](#activer-lextension)
    - [Créé les ressources](#créé-les-ressources)

<!-- /TOC -->
## Création avec Plugin Builder


Intaller l'extension **Plugin Builder**
Utilisé le : Extension -> Plugin Builder -> Plugin Builder

Class name : Example    # Nom de la Classe (classe au sens python, ne pas l'appeler test, help ou doc)
Plugin name : Example   # Nom du dossier : Ex: .qgis/python/plugin/Test
Description : Plugin d'Example     #  Metadata
Module name :example   # Nom du dossier (module au sens python)
Version number: 0.1  # Metadata
Minimum QGIS version: 2.0  # Metadata
Author/Company : Prénom NOM  # Metadata
Email address : contact@exemple.com  # Metadata

->Next

About : Plugin d'example pour tester   # Metadata


->Next


Template: (Choisir l'un des choix suivant)
- 1: Tool button with dialog
- 2: Tool button with dock widget
- 3: Processing Provider


Si 1:
Test for the menu item: Test
Menu: Plugin

->Next

Internationalization : On
Help : On
Unit tests : On
Makefile : On
pb_tool : On

-> Next

Bug tracker : ..... # Metadata
Repository  : ..... # Metadata
Home page : ..... # Metadata
Tages : ..... # Metadata
Flag the plugin as experimental : On # Metadata


-> Next
Nomalement, lerépertoire par défaut est ~/.qgis/python/plugins

### Activer l'extension

Extension -> Activer/Gérer les extentions

## Créé les ressources

pyrcc4 -o resources.py resources.qrc
