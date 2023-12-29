# Gestion des utilisateurs
## Installation du plugin
Go to : https://jenkins.exemple.com/pluginManager/

Installation du plugin : Role-based Authorization Strategy

## Configuration
Dans "Administrer Jenkins" -> "Gérer et assigner les rôles" https://jenkins.exemple.com/role-strategy/

### Gérer les rôles
Association de rôle : https://jenkins.exemple.com/role-strategy/assign-roles

#### Rôles globaux
Permet d'associer un utilisateurs a un rôle global. On associe un développeur au rôle "developer".

#### Item roles
Permet d'associer un utilisateurs a un projet.

### Assigner les rôles
Création de rôle : https://jenkins.exemple.com/role-strategy/manage-roles

#### Rôles globaux
Permet de définir des accès globaux aux utilisateurs. C'est ici qu'on définit les accès pour un développeur et un admin.

##### Rôles de projets
Permet de définir les accès au projets et on définit aussi une regex qui catch tous les sous projets 'nom du projet git'.*  :
- Rôle à ajouter : 'group du projet git'--'nom du projet'
- Patron : 'group du projet git'--'nom du projet'.*
