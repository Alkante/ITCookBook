# Virtual environement

L'OS ne supporte qu'une version de python par défaut.
Pour que certain projet puisse supporter d'autres version, il faut utiliser virtualenv




Trois façons:

pyenv – A Python version manager. Installs different versions and flavors of Python interpreters.

pyvenv – A tool to create isolated virtual environments from a Python interpreter. Ships with Python from 3.4.

virtualenv – Creates virtual environments, available in PyPi.


## Installer virtualenv
```bash
pip install virtualenv
```

## Création de l'environement viruel
Création de l'environement avec python3 version 3.5
```bash
virtualenv -p /usr/bin/python3.5 Venv_Python3.5
```

## Activation de l'environnement
```bash
source Venv_Python3.5/bin/activate
```

## Modules

### Installation des Modules
```bash
pip install mymodule
```
### Désintallation des Modules
```bash
pip uninstall mymodule
```

### List des Modules
```bash
pip freeze
```

### Backup de la lists des Modules
```bash
pip freeze > requirements.txt
```
### Restore de la liste des modules
```bash
pip install -r requirements.txt
```

## MAJ
```bash
pip install --upgrade pip
```
## Exit
```bash
deactivate
```
