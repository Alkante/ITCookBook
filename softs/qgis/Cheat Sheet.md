# Cheat Sheet



<!-- TOC -->

- [Cheat Sheet](#cheat-sheet)
  - [Fichier extention](#fichier-extention)
  - [Import de données](#import-de-données)
    - [asc](#asc)

<!-- /TOC -->

## Fichier extention
| Extention | Full name | CSR | Description |
|---- |--- |--- |--- |
| .tiff | Tagged Image File Format | Oui | image bimap raster (volumineux, sans perte). Supporte différent système de couleur. A afficher avec **gimp** |
| .geotiff | geo tiff | Oui |Image time avec coordonnée de projection. full compatible tiff 6.0 |
| .asc | ASCII | Non |Fichier texte représentant une matrice de point avec leur dimention, c'est du ERSI ASCII|
| .shp | ERSI Shapefiel | ? | Couche vectoriel de point, ligne, polygone |

TODO:
.sdc Smart Data Compression
## Import de données

| Type | Action |
|--- |---- |
| .csv | [Menu]Couche->Ajouter une couche->Ajouter une couche de texte délimité |

Vocabulaire
| Accronyme | Nom complet | Description |
|--- |--- |---- |
| SCR |Système de Coordonnées de Référence | Qgis à nativemment 2700 SCR dans ca base SQlite. Nativement, les EPSG contiennent des SCR. pour un shapefile (.shp)
, le SCR peut etre préciser dans un **.prj** ayant le meme nom que le shape |



Vocabulaire :
- PCT : Pseudo-color Table (8Bits)
- RVB/RGB: Rouge Vert Bleu/Red Green Blue  (24 Bits)
- RGBA: Red Green Blue Alpha(Transparence)

### asc

Contient :
- Metadonnées
  - Nombre de ligne et de colonne
  - Position du coin supérieur gauche
  - Dimention des pixel (carré) en mètre
  - Définition des valeur no data
- Donnée
  - Int ou float ou ...

exemple :
```ascii
ncols 144
nrows 138
xllcorner 312487.6891250734
yllcorner 2397321.4964859663
cellsize 10.0
NODATA_value -1
0 0 0 0 0 0 0
0 0 0 1 1 0 0
0 0 1 1 1 1 0
0 0 0 1 1 0 0
0 0 0 0 0 0 0
```
