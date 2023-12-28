# CMake


Cmake permet de générer les makefiles automatisant la compilation.
Son avantage est d'être multiplate-forme et très paramétrable.


## Installation

### installer cmake
```bash
apt-get update
apt-get install cmake
```

## Standard install linux
Dans les installations manuelles de programme nous retrouvons souvent les lignes de code suivante sous linux :
```bash
./.configure
make
make install
```

CMake permet de générer les fichiers de compilaton (makefile, options, ...) puis d'être utiliser par les lignes de code précedentes par un utilisateur tière.
./configure définit les options.
make compile via les makefile.
make install copie les fichiers et bianire dans les répertoires du système


## Standard programme standalone

Pour ce genre de programme, les fichiers compilés et l'exécutable sont mis dans un dossier générale nommé 'build'.

```bash
mkdir build
cd build
cmake ..
```




