# Extraire une archive .7z en cli

```apt install p7zip```

## Lister une archive
Option l = lister le contenu de l'archive

```7zr l archive.7z```

    7-Zip (a) [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
    p7zip Version 16.02 (locale=fr_FR.UTF-8,Utf16=on,HugeFiles=on,64 bits,8 CPUs Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz (50657),ASM,AES-NI)

    Scanning the drive for archives:
    1 file, 389566991 bytes (6094 MiB)

    Listing archive: archive.7z

    --
    Path = archive.7z
    Type = 7z
    Physical Size = 6389566991
    Headers Size = 347
    Method = LZMA:24
    Solid = +
    Blocks = 2

    Date      Time    Attr         Size   Compressed  Name
    ------------------- ----- ------------ ------------  ------------------------
    2022-09-17 15:17:16 ....A  40960890328   6389553279  1_DONNEES/fichier1.sql
    2022-09-17 15:03:13 ....A        89639        13365  1_DONNEES/fichier2.sql
    2022-09-17 15:17:16 ....A         7350               4_METADONNEES/metadatas.HTML
    2022-09-17 15:17:16 D....            0            0  4_METADONNEES
    2022-09-17 15:03:17 D....            0            0  1_DONNEES
    ------------------- ----- ------------ ------------  ------------------------
    2022-09-17 15:17:16        40960987317   6389566644  3 files, 3 folders

## Décompresser une archive
option x = décompresser. 7zr permet de suivre l'avancée en pourcentage

```7zr x archive.7z```

    7-Zip (a) [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
    p7zip Version 16.02 (locale=fr_FR.UTF-8,Utf16=on,HugeFiles=on,64 bits,8 CPUs Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz (50657),ASM,AES-NI)

    Scanning the drive for archives:
    1 file, 6389566991 bytes (6094 MiB)

    Extracting archive: archive.7z
    --
    Path = archive.7z
    Type = 7z
    Physical Size = 6389566991
    Headers Size = 347
    Method = LZMA:24
    Solid = +
    Blocks = 2

    47% - 1_DONNEES_LIVRAISON/dvf_departements.sql

## Ouvrir une archive multi-fichiers (.001/.002/.0xx)
L'option -tsplit permet d'ouvrir une archive multifile.

L'option x (décompression) fusionne les différents fichiers (archive_part.7z.00x) en un seul (archive_part.7z)

```7zr x archive_part.7z.001 -tsplit```

    7-Zip (a) [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
    p7zip Version 16.02 (locale=fr_FR.UTF-8,Utf16=on,HugeFiles=on,64 bits,8 CPUs Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz (50657),ASM,AES-NI)

    Scanning the drive for archives:
    1 file, 838860800 bytes (800 MiB)

    Extracting archive: archive_part.7z.001
    --         
    Path = archive_part.7z.001
    Type = Split
    Physical Size = 838860800
    Volumes = 8
    Total Physical Size = 6475844362

    Everything is Ok                                     

    Size:       6475844362
    Compressed: 6475844362
