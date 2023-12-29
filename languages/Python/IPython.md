# IPython
<!-- TOC -->

- [IPython](#ipython)
    - [Installation](#installation)
    - [Run](#run)
    - [Librairies utile pour data science](#librairies-utile-pour-data-science)

<!-- /TOC -->
Jupyter l'utilise comme kernel.


## Installation
En root
```bash
apt-get install virtualenv
```
En user
```bash
virtualenv -p /usr/bin/python3 venv3
```
Activation
```bash
source venv3/bin/activate
pip install jupyter 
jupyter notebook
```

exit
```bash
<CTRL-C>
deactivate
```

## Run
```bash
jupyter notebook
```

Se connecter via l'url donnée avec le token donné

## Librairies utile pour data science
```bash
pip3 install pandas numpy matplotlib sklearn scipy
```