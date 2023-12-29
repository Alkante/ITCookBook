# SITE de référence
http://sql.sh/

### Afficher les bases
## Mysql
```
show databases;
```
## Mongo
```
show dbs;
```


### Select : Afficher les utilisateurs/hosts
```
select user,host from mysql.user;
```
 mysql. n'est pas utile si "use mysql à été utilisé"






## SELECT
SELECT premet d'afficher ou  d'obtenir des information sur la base de donnée sans modifier cette dernière.

### Utilisation simple
	SELECT col1
	FROM table1

### Utilisation multi champ
	SELECT col1, col2
	FROM table1

ou

	SELECT * from table1

### MasterThis SELECT
	SELECT *
	FROM table2
	WHERE condition1
	GROUP BY expression1
	HAVING condition2
	{UNION|INTERSECT|EXCEPT}
	ORDER BY expression2
	LIMIT count
	OFFSET start




## DISTINCT UNIQUE
DISTINCT permet d'évité les doublons.
Sous Oracle, ce mot clef correspond à UNIQUE

### Simple DISTINCT/UNIQUE
	SELECT DISTINCT col1
	FROM table1

### Rendre DISTINCT/UNIQUE un champ existant
	ALTER TABLE table1
	ADD DISTINCT col1


## WHERE

### Utilisation SIMPLE
	SELECT col1
	FROM table1
	WHERE condition

Exemple de condition

	col1 = 'string'

| Opérateur   | Description                                                                     |
|-------------|---------------------------------------------------------------------------------|
| =           | Égale                                                                           |
| <>          | Pas égale                                                                       |
| !=          | Pas égale                                                                       |
| >           | Supérieur à                                                                     |
| <           | Inférieur à                                                                     |
| >=          | Supérieur ou égale à                                                            |
| <=          | Inférieur ou égale à                                                            |
| IN          | Liste de plusieurs valeurs possibles                                            |
| BETWEEN     | Valeur comprise dans un intervalle donnée (utile pour les nombres ou dates)     |
| LIKE        | Recherche en spécifiant le début, milieu ou fin d'un mot.                       |
| IS NULL     | Valeur est nulle                                                                |
| IS NOT NULL | Valeur n'est pas nulle                                                          |


### Changment de la tables (ALTER TABLE)
	ALTER TABLE project_companies
	CHANGE company_code company_code VARCHAR(20) NULL COMMENT 'code organisme';


## AND OR

### AND
	SELECT col1
	FROM table1
	WHERE cond1 AND cond2

### OR
	SELECT col1
	FROM table1
	WHERE cond1 OR cond2

### AND et OR
	SELECT col1
	FROM table1
	WEHE cond1 (cond2 OR cond3)

## IN

### Utilisation simple
IN peux remplacer une multitude de OR

	SELECT col1
	FROM table1
	WHERE col2 IN (valeur1, valeur2)


## BETWEEN

### Utilisation simple
	SELECT *
	FROm table1
	WHERE col1 BETWEEN 'valeur1' AND 'valeur2'

### Inverse
	SELECT *
	FROm table1
	WHERE col1 NOT BETWEEN 'valeur1' AND 'valeur2'


## LIKE

LIKE permet d'utilise des modèles (pseudo expression régulière)

### Utilisation simple
	SELECT *
	FROm table1
	WHERE col1 LIKE 'modèle1'

```
% : carctère joker : 'a%', '%a', '%a%', 'a%b'
_ : N'importe quel caractère unique
```

## IS NULL IS NOT NULL

### Utilisation simple de NULL
	SELECT *
	FROm table1
	WHERE col1 IS NULL

### Utilisation simple de NOT NULL
	SELECT *
	FROm table1
	WHERE col1 IS NOT NULL



## REPLACE
REPLACE permet de remplacer une chaine de caractère dans un texte ou les textes d'une colonne par une autre.

### Remplacer un mot dans un string ()
	SELECT REPLACE ('toto en espagne', 'toto', 'Toto');

### REPLACE dans un SELECT
	SELECT col1, col2, REPLACE (col3, 'ancien text', 'nouveau text')

### REPLACE dans un UPDATE
	UPDATE table
	SET col1 = REPLACE(col1, 'ancien texte', 'nouveau texte');

#### Optimisation avec un second filtrage
	UPDATE table
	SET col = REPLACE(col, 'ancien texte', 'nouveau texte');
	WHERE col LIKE '%ancient texte%''






## UPDATE
Applique un changement sur les données de la table

### Exemple simple avec WHERE
	UPDATE table1
	SET col1 = 'nouvelle valeur'
	WHERE col2 = 1

### Exemple multiple avec WHERE
	UPDATE table1
	SET col1 = 'nouvelle valeur', col2 = 'nouvelle valeur 2'
	WHERE col2 = 1



## OPERATION
	UPDATE Inventory
	SET Quantity = Quantity - 1
	WHERE InventoryID = 2


## ALTER TABLE

### Supprimer une contrainte de clef étrangère
	ALTER TABLE tables1 DROP FOREIGN KEY col1 ;

### Supprimer une colonne
	ALTER TABLE tables1 DROP col1;

### Ajouter une colonene

	ALTER TABLE table1
	ADD col1 VARCHAR(50)

### Changer la nature d'une colonne
	ALTER TABLE table1
	ALTER COLUMN col1 VARCHAR (300)
ou
	ALTER TABLE table1
	ALTER COLUMN col1 VARCHAR (300) NOT NULL
ou en mySQL
	ALTER TABLE table1
	MODIFY COLUMN col1 VARCHAR (300)

## DROP TABLE

### Supprimer une table
	DROP TABLE table1


## ORDER BY

### Ordre ascendant
	SELECT *
	FROm table1
	ORDER BY col1

ou

	SELECT *
	FROm table1
	ORDER BY col1 ASC


### Ordre descendant
	SELECT *
	FROm table1
	ORDER BY col1 DESC



### Ordre ascendant multi colonne
	SELECT *
	FROm table1
	ORDER BY col1, col2



## INSERT

### Insertion simple
	INSERT INTO table1
	VALUES (val1, val2)

ou

	INSERT INTO table1 (col1, col2)
	VALUES (val1, val2)

## UPDATE

### Mis à jour simple
	UPDATE table1
	SET col1=val1, col2=val2
	WHERE col3=val3
