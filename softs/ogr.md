# OGR2OGR
```bash
ogr2ogr  -f "ESRI Shapefile" /home/user/workspace_eclipse/APP_Parser_client/SHP/ /home/user/workspace_eclipse/APP_Parser_client/GML/all_wirma.gml
```

## from postgis to other formats:
```bash
ogr2ogr -f "ESRI Shapefile" mydata.shp PG:"host=myhost user=myloginname dbname=mydbname password=mypassword" "mytable"
```
with select
```bash
ogr2ogr -f "ESRI Shapefile" "$table.shp" PG:"${PG_CONN}" -sql "select * from public.$table where site like '83%'"
```
## to postgis
```bash
ogr2ogr  -f "PostgreSQL" PG:"host=postgis.exemple.com user=user_postgis dbname=bdd_pnrbsn2 password=XXXXXX" file_name.dgn
```

## to postgis avec changement de projection de 4326 vers 27582
```bash
ogr2ogr  -s_srs EPSG:4326 -t_srs EPSG:27582 -a_srs EPSG:27582 -overwrite -f "PostgreSQL" PG:"host=vm1.exemple.com user=user_admin dbname=database_name password=XXXXXX" z_wwwroot/cartoweb_data/grille1km_region.shp -nln grid1km
ogr2ogr    -f "PostgreSQL" PG:"host=postgis.exemple.com user=user_postgis dbname=bdd_pnrbsn password=XXXXXX" ../z_wwwroot/mapserver//upload/sig/themes/couche_27/fichiers_dgn/enq2115.dgn -nln 112
```

## Conversion Lambert 2 vers Lambert 93 shp en shp
```bash
ogr2ogr -t_srs "+init=IGNF:LAMB93" -s_srs "+init=IGNF:LAMBE +wktext" polygones_L93.shp polygones_L2E.shp
```
ex en ligne sur vm1:
```bash
ogr2ogr  -s_srs EPSG:27582 -t_srs EPSG:2154 /home/user/cartoweb_data/zone_viti_93.shp /home/user/cartoweb_data/zone_viti.shp
```

## pour copier le contenu ou dump.sql d'une table vers une autre table
ex. apres avoir fait la transformation postgis dans une bd pour l'importer dans une autre bd
```bash
psql -h vm1.exemple.com -U user_admin -d database_name < /home/user/Desktop/dump.sql
```
rq si dump(4).sql pas oublier les \
```bash
psql -h vm1.exemple.com -U user_admin -d database_name < /home/user/Desktop/dump\(4\).sql
```

## pour copier une shp en postgis(parfois pb de contrainte de geometry)
```bash
ogr2ogr    -f "PostgreSQL" PG:"host=vm1.exemple.com user=user_admin dbname=bdd_app2 password=XXXXXX" /mnt/share1/user/cartoweb_data/app2/communes_parc.shp -nln pnrlat.matable
```

## pour transformer shp2pgsql
```bash
shp2pgsql -c app1 app1 bdd_app2 | psql -d bdd_app2 -h vm1.exemple.com -u user_admin
shp2pgsql -c fichier_shape schema.table_destination nom_base_de_donnees | psql -d nom_base_de_donnees -h url hote -U nom_utilisateur
shp2pgsql -c /home/www/app1.exemple.com/upload/sig/themes/couche_12/ public.lyr32 bdd_app1| psql -d bdd_app1 -h localhost -U user_app1
```

## GDALTINDEX : index des dalles ortho ou scan25
```bash
gdaltindex /home/user/app2/cartoweb_data/app2/ortho.shp /home/user/app2/cartoweb_data/app2/ORTHO/*.ecw
gdaltindex /home/www/app2/cartoweb_data/app2/ortho.shp /home/www/app2/cartoweb_data/app2/ORTHO/*.ecw
gdaltindex /home/user/app2/cartoweb_data/app2/scan25.shp /home/user/app2/cartoweb_data/app2/SCAN25/*.TIF
```

## Pour récupérer l'extent de l'ortho ou scan25 faire sur le fichier index :
```bash
ogrinfo -al scan25.shp | more
```

## Pour transformer la projection d'un POSTGIS2POSTGIS
si contrainte sur the_geom il faut l'enlever puis procedure :
```mysql
"alter table commune drop constraint enforce_srid_the_geom;"
```
MAJ (utiliser la commande transforme pour les anciennes version de Postgis)
```mysql
"update commune set the_geom = st_transform(the_geom, 2154);"
```
si besoin de contrainte :
```mysql
"alter table commune add constraint enforce_srid_the_geom check(srid(the_geom) = 2154);"
```

## construction de grilles puis envoie sous postgis
En vue de construire une grille recouvrant l'armorique :
utilisation de gridmaker sous Mapinfo:
- prendre la carte des département FRance et recuperer les coordonnées en degrés
- faire la grille avec ces coordonnées et une maille de 1000m
- prendre la projetcion wgs1984 (lat long)
- la convertir en shp (convertisseur universel)
- sous arcgis : definri la projetcion : arctoolbox->projection et transformation-> definir une projection : choisir WGS1984
Rq, pour vérifier le calage automatique, ouvrir un shape avec la carte  des depts par ex.
(d'autre moyen existe directement avec postgis cf ci dessus)

import en postgis : de facon à obtenir une projection de wgs84 (srid = 4326) en lambert2 (27582)
```bash
ogr2ogr  -overwrite -f "PostgreSQL" PG:"host=vm1.exemple.com user=user_app2 dbname=bdd_app2 password=password" /home/www/app2/cartoweb_data/app2/Export_Output.shp -nln pnrlat.grid1km -s_srs EPSG:4326 -t_srs EPSG:27582
```

Du coup on a une table postgis avec un srid en 27582
Or par la suite il ya une constrcution d'une vue avec cette grille et d'autres table postgis qui ont un srid =-1 et donc y a 2 projection differentes.
D'ou  nécessité de transformer le srid en-1

procédure :
1: ALTER TABLE grid1km drop CONSTRAINT enforce_srid_the_geom;// on vire temporairement la contrainte du srid
2: UPDATE grid1km SET the_geom=setsrid(the_geom,-1);
3: ALTER TABLE grid1km add CONSTRAINT enforce_srid_the_geom  CHECK (srid(the_geom) = -1);
4: on met à jour la table geometry_column

## Transformation ; indication site IGN
http://lambert93.ign.fr/index.php?id=29

### Reprojection d'une liste de coordonnées décrites dans un fichier (ala Circé)
Etant donné un fichier liste_coords.txt décrivant sur chaque ligne deux coordonnées X, Y en Lambert 2 téndu. Pour convertir ce fichier en Lambert 93, faire:
```bash
cs2cs +init=IGNF:LAMBE +to +init=IGNF:LAMB93 < liste_coords.txt > list_coords_L93.txt
```
### Reprojection d'un fichier vecteur
La commande permettant de réaliser des changements de systèmes de coordonnées dans des fichiers vecteur est ogr2ogr. Etant donné un fichier Shp par exemple, contenant des coordonnées en Lambert 2 étendu, que l'on souhaite convertir en Lambert 93, écrire:
```bash
ogr2ogr -t_srs "+init=IGNF:LAMB93" -s_srs "+init=IGNF:LAMBE +wktext" polygones_L93.shp polygones_L2E.shp
```
```bash
ogr2ogr  -s_srs EPSG:27582 -t_srs EPSG:2154 /home/user/cartoweb_data/app2/communes_93.shp /home/user/cartoweb_data/app2/communes.shp
```

### Reprojection de fichiers raster
L'outil principal permettant de reprojeter des fichiers raster est gdalwarp. Il permet de convertir des dalles d'ortho-images par exemple dalle par dalle, ou un ensemble de dalles selon un nouveau découpage.
Conversion dalle par dalle:
La conversion dalle par dalle consiste à reprojeter chaque dalle initiale indépendamment de celles qui l'entourent. L'inconvénient est que des "bordures" sans information vont apparaitre sur chaque dalle, du fait du changement de système de coordonnées. Cela pose problème lorsque l'on souhaite visualiser l'assemblage des dalles reprojetées, puisque ces bordures vont apparaitre. Afin de minimiser ce problème, gdalwarp offre la possibilité de rendre ces zones transparentes, en utilisant un canal alpha. Selon le SIG ou logiciel utilisé, ces zones pourront ne pas être visibles, et conduire à un affichage de l'assemblage apparemment sans problème.
La commande à utiliser est la suivante:
```bash
gdalwarp -s_srs "+init=IGNF:LAMBE +wktext" -t_srs "+init=IGNF:LAMB93" -rc -tr 0.5 0.5 -co "INTERLEAVE=PIXEL" -dstnodata 255 -dstalpha image_L2E.tif image_L93.tif
```
On peut remplacer "+init=IGNF:LAMB93" par "EPSG:2154" si l'on souhaite que le geotiff résultat contienne le code EPSG du Lambert 93.
"+wktext" est INDISPENSABLE afin que la grille de conversion NTF/RGF93 soit bien prise en compte dans la définition du Lambert 2 étendu.
```
-rc correspond à un rééchantillonnage bicubique.
-tr 0.5 0.5 correspond à un pixel de 50 cm en E et N.
-dstnodata 255 indique que les bordures sans information doivent être en blanc
-dstalpha crée une couche alpha indiquant les zones sans information. Le fichier est donc plus gros puisqu'il contient un canal supplémentaire alpha.
```

### Conversion d'un ensemble de dalles selon un nouveau découpage:
La solution précédente n'est pas toujours satisfaisante: le souhait de nombreux utilisateurs est d'obtenir de nouvelles dalles complètes, sans bordures, selon un découpage régulier dans le nouveau système de coordonnées.
Le principe général est le suivant:
1) Définition d'un fichier virtuel (fichier .vrt) décrivant l'assemblage de l'ensemble des images et pointant sur chacune des dalles initiales, en utilisant l'outil de GDAL, gdal_vrtmerge.py.
2) Utilisation de gdalwarp afin d'obtenir à partir de ce fichier les dalles nécessaires sur une zone donnée et de les reprojeter.

Nous mettons à disposition un exemple de script (ou batch), tile_orthos, qui met en oeuvre ces principes. Ce script n'est qu'un exemple, qui doit être modifié en fonction des besoins de chacun.

Ce script utilise les arguments suivants:
arguments: tile_orthos -i input_dir -o output_dir -e EastingMinimum -f EastingMaximum -n NorthingMinimum -m NorthingMaximum [-s NorthingStep] [-t EastingStep]

```
-i: répertoire contenant les dalles à reprojeter
-o: répertoire qui contiendra les dalles reprojetées
-e, -f, -n, -m: emprise de la zone à reprojeter
-s, -t: pas des nouvelles dalles en mètres. Valeur par défaut = 1000 (dalles kilométriques)
```
