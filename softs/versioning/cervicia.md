# cervicia

Le numéro de version correspond à la version de tout le repositorie

## AVANT conflit

### Serveur
```
file (version10)   ->  file version (12)  -> file version (27)
    |
    !
```
### Client

file (version personnel venant de version 10)



### Etape du conflit
	Demande de numréro de version
	la version personnel devient la version 28 ou plus (versino de tout le repositorie+1)
L'arboressence est la suivante :
	file              (12)
	.#file.10
	.#file.12
	.#file.27
	.#file.28

### Résoudre de conflit en modifant file (12) à l'aide de .#file.28
	vimdiff file .#file.28
