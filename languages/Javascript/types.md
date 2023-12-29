# Types JavaScript


	var length = 16;                               // Number
	var lastName = "Johnson";                      // String
	var cars = ["Saab", "Volvo", "BMW"];           // Array
	var x = {firstName:"John", lastName:"Doe"};    // Object


	typeof "John"                // Returns string
	typeof 3.14                  // Returns number
	typeof false                 // Returns boolean
	typeof [1,2,3,4]             // Returns object
	typeof {name:'John', age:34} // Returns object

	varperson = null;
	typeof person;      // Value is null, but type is still an object

	varperson = null;
	var person = undefined;     // Value is undefined, type is undefined


	typeof undefined             // undefined
	typeof null                  // object
	null === undefined           // false
	null == undefined            // true


## Class ######################
### Instentiation
	var person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};

ou

	var person = {
	    firstName:"John",
	    lastName:"Doe",
	    age:50,
	    eyeColor:"blue"
	};

### Propriété de l'objet
	person.lastName;

### Méthode de l'objet
	name = person.fullName();

### Objet inclue dans JavaScript
	var x = new String();        // Declares x as a String object
	var y = new Number();        // Declares y as a Number object
	var z = new Boolean();       // Declares z as a Boolean object

### Informations
Les variables peuvent être déclaré en global et utilisable dans tout le code Javascript

Si une variable est utilisé alors quel n'a pas été instancier, elle est automatiquement instancier en temps que variable globale.



### Constante
```
const MACHAINE
```
N'existe que dans le scope, même en dessous

Scope -> function ou global

Block scope -> if, for, ...


Avant ES5  (a banir) : remonte le scope block
```
var mavariable
```

Après ES6 (Bonne pratique) : ne remonte pas le scope block
```
let mavariable
```
