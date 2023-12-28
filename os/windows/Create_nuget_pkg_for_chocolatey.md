
# Création d'un paquet nuget pour chocolatey

## Overview
Chocolatey un manageur de paquet pour Windows. Il permet l'installation simplifié et silencieuse de millier de logiciels.
Pour se faire Chocolatey fonctionne avec des paquets nuget.

## Sources, Documentations
https://chocolatey.org/

https://www.nuget.org/

## Prérequis
- Un ordinateur sous Windows

- Chocolatey installé

## Commandes utiles
**choco new [nom paquet] :** Permet de générer les fichiers de base d'un paquet Chocolatey en une commande

## Structure simple
Si l'installateur pése plus de 100Mo alors il est recommandé de le placer sur un serveur d'hébergement. Mais il est aussi possible de placer l'installateur directement dans le dossier tools du paquet, c'est plus simple et ça permet d'hébergé en local le paquet et l'installateur au même endroit.

```
[nom paquet]
├───tools
│   ├───chocolateybeforemodify.ps1 *1
│   ├───chocolateyinstall.ps1 *2
│   ├───chocolateyuninstall.ps1 *3
│   ├───[Installateur].exe ou .msi
│   ├───LICENSE.txt
│   └───VERIFICATION.txt
└───[nom paquet].nuspec
```

*1 = Permet de faire des actions avant d'installer le logiciel

*2 = Script principal d'installation du logiciel

*3 = Plus utilisé par les dernières versions de chocolatey car la désinstallation est maintenant géré d'origine

PS: la structure peux changer en fonction du besoin

## Exemple de construction
```
ncpa.2.1.6
├───tools
│   ├───chocolateyinstall.ps1
│   └───ncpa-2.1.6.exe
└───ncpa.nuspec
```

## Fichier .nuspec
Il s'agit du fichier qui affiche les informations à propos du logiciel. Chocolatey en a besoin pour fonctionner et construire le paquet.

**Exemple de construction :**

```
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
  <metadata>
    <id>ncpa</id>
    <version>2.1.6</version>
    <title>NCPA</title>
    <authors>NCPA</authors>
    <owners>NCPA</owners>
    <licenseUrl>https://www.nagios.org/ncpa/</licenseUrl>
    <projectUrl>https://www.nagios.org/ncpa/</projectUrl>
    <iconUrl>https://www.nagios.org/ncpa/ncpa.img</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>NCPA</description>
    <tags>ncpa nagios</tags>
    <packageSourceUrl>https://www.nagios.org/ncpa/</packageSourceUrl>
    <dependencies>
      <dependency id="chocolatey-core.extension" version="1.3.3" />
    </dependencies>
  </metadata>
</package>
```

## Fichier chocolateyinstall.ps1
C'est le script qui va télécharger ou exécuter l'installeur.

**Exemple de construction pour une installation avec l'installateur déjà dans le paquet:**

```
$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName            = 'ncpa'
  fileType               = 'exe'
  file64               = "$toolsPath\ncpa-2.1.6.exe"
  checksum64             = '6DAC5B8E71B88D770F0B8C604E716C9F15DB0B1AE2443BDB2C4795B0806D62AB'
  checksumType64         = 'sha256'
  silentArgs             = "/S"
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs


```

## Package avec chocolatey
On démarre une invite de commande (CMD ou Powershell) en admin.

On se rend dans le dossier de notre paquet: ***cd C:\Path\To\Package***

Et on demande à Chocolatey de packager le tout: ***choco pack [nom paquet].nuspec***

Si tout est correct alors Chocolatey à créer un fichier **paquet.version.nupkg**.
Il faut alors le récupérer et le placer sur un serveur nuget puis il suffit de taper ***choco install [nom paquet]*** dans la cmd de la machine où l'on veux installer le logiciel.
