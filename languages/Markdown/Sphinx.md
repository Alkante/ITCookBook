# Sphinx



## Contexte
Génération de docuemntation HTML et PDF automatique à partir de markdown


## Installation


### Paquet Debian
Installer python3
```bash
apt-get install python3-setuptools python3-pip virtualenv
apt-get install texlive-full
```


### Environnement virtuel python
Création de l'environement avec python3 version 3.5 avec virtualenv
```bash
virtualenv -p /usr/bin/python3.5 Venv_Python3.5
```
Activation de l'environnement
```bash
source Venv_Python3.5/bin/activate
```

Mises à jour de pip puis installation des paquets python
```bash
pip install pip
pip install sphinx==1.4.8
pip install sphinx_rtd_theme
pip install recommonmark
easy_install blockdiag
easy_install sphinxcontrib-blockdiag
easy_install sphinxcontrib-images
```



Déplacer vous dans le dossier du projet ou est présent votre documentation pusi créer le patron de configuration
```bash
sphinx-quickstart
```

```term
.
├── build/
├── make.bat
├── Makefile
└── source/
    ├── conf.py
    ├── index.rst
    ├── _static
    └── _templates
```




Remarque :
Les tableaux markdown ne sont pas supporté par recommonmark

Utiliser pandoc pour convertir les fichiers Markdown en reStructuredText
```bash
apt-get install pandoc
```


```bash
pandoc --from=markdown --to=rst --output=README.rst README.md
```



### Latex et PDF

Installer Latex

```
apt-get install texlive
apt-get install texlive-lang-french
apt-getinstall texlive-formats-extra
```


### Générer la docuementation

```bash
make latexpdf
```
