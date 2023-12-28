
# Inno Setup (version 5.6.1)

## Overview
Inno Setup est un logiciel libre permettant de créer des installateurs pour Windows. (Compatible avec toutes les versions Windows sortie après 2000)

## Aide officiel
http://www.jrsoftware.org/ishelp/


## Création du script
Quand on commence un nouveau script sur Inno Setup, il est possible de partir de rien (*Create new empty script file*)
ou alors utiliser l'assistant (*Create a new script file using Script Wizard*).

Pour cette documentation j'utilise l'assistant.
On clique donc sur "*Next*" pour commencer a créé l'installateur.

--

### 1 - Application Information
**Application name :** Nom de l'application

**Application version :** La version de l'application

Le reste est secondaire pour une utilisation personnelle et recommandé si l'installateur est dédié au public.

**Application publisher :** Nom de l'entreprise

**Application website :** Lien internet vers le site de l'entreprise

--

### 2 - Application folder
**Application destination base folder :**

***- Program Files folder :*** L'installation se fera dans le dossier par défaut des logiciels de Windows

***- Custom :*** On choisit un dossier custom pour l'installation

**Application folder name :** Le nom par défaut que va prendre le dossier d'installation

La première case à cocher donne le droit à l'utilisateur de changer le répertoire d'installation (cochée par défaut)

La deuxième case est si le logiciel n'a pas besoin de dossier (décoché par défaut et utile dans le cas d'un patch sur un logiciel déjà présent).

--

### 3 - Application Files
**Application main executable file :** Il faut choisir l'exécutable principale de notre logiciel.

**Other application files :** Il faut ajouter tout les autres fichiers (dll, dossier, etc.) Avec les boutons *ADD file(s)* et *Add folder*.

La première case à cocher autorise à démarrer directement l'application après l'installation.

Et l'autre case est à cocher si le logiciel n'a pas d'exécutable principale.

--

### 4 - Application Shortcuts
***Create a Shortcut to the main executable in the common Start Menu Programs folder :***

***- Coché :*** Créez un raccourci vers l'exécutable principal dans le dossier Programmes du menu Démarrer

***- Décoché :*** Permet de personnaliser le nom du dossier du logiciel pour le menu Démarrer;

Il est possible de donner le droit à l'utilisateur de changer le nom de dossier, ou bien de ne pas l'activer;

On peut aussi créer un raccourci vers Internet et un raccourci vers le désinstallateur dans le menu Démarrer.

***Other Shortcuts to the main executable :***
La première case donne le droit à l'utilisateur de créer un raccourci vers le bureau et la deuxième case permet de créer un démarrage rapide sur les anciennes versions Windows compatibles

--

### 5 - Application Documentation
Cette partie permet de montrer la licence lors de l'installation ainsi que des fiches d'information.

**Licence files :** La licence du logiciel

**Information file shown before installation :** Une page d'information à afficher avant l'installation

**Information file show after installation** Une page d'information à afficher après l'installation

--

### 6 - Setup Languages
Il faut sélectionner la langue de l'installateur. (Anglais par défaut).

--
### 7 - Compiler Settings
**Custom compiler output folder :** Le dossier où va être placé l'installateur après la compilation (Dans le dossier Document par défaut)

**Compiler output base file name :** Le nom de l'installateur après compilation

**Custom Setup icon file :** Permet de mettre une icône sur l'installateur

**Setup password :** Empêche l'installation si l'utilisateur ne connais pas le mot de passe

Normalement on arrive à la fin de l'assistant. Il est proposé de compiler directement mais il est possible de dire non pour modifier manuellement ou vérifier que tout est bon dans le script avant compilation. 

--

### 8 - Fin
Si les informations rentrées sont correctes et que la compilation c'est bien terminé alors félicitation vous avez votre premier installateur!

Pour configurer de manière plus avancée il existe une application nommée ISTools.
