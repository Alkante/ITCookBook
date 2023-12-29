# Angular


## Context
Le mot Angular par opposition à AngularJS concerne les versions 2,4,5 et +
Il n'y a pas de version 3 pour évité tout amalgame avec un programme node




## Installer Angular

## Installer typescript
```bash
npm install -g typescript
```


## Transpiler ES6->ES5
- Traveur ()
- Badel
- TypeScript transpiler

Génération des fichiers .js et .map

## Mise à jour npm
```bash
npm install -g npm
npm install
```
## Initialisation
```bash
npm install -g @angular/cli
```

yarn
```bash

```

```bash
ng new my_new_project
cd dash
ng build
ng serve
```

Conectez vous à l'interface :
[http://127.0.0.1:4200/](http://127.0.0.1:4200/)


## Compilation for porduction

ng build --target=production --base-href '/'
ls dist

## Ajouer un component

```bash
ng generate
ng generate component mycomponent
```

## Tools : 
npm install -g tsun

-- Cours pages : N°80 ( *ngFor )



numder (always float)

any contient **number, strind ... et void**
**nothing** is any
Just one constructor par class
var greeting = `Hello ${firstName} ${lastName}`;


Fontion anonyme : 
  function(line) { console.log(line); }
ou (en plus, on plus utiliser le this de la classe actuelle)
  (line) => console.log(line)

.sort((a:Article, b:Article) => b.votes - a.votes)
.forEach(function(line) { console.log(line); })
.map(v => v + 1)


.toUpperCase()