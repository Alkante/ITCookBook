### Taille ###
	var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var sln = txt.length;

### Protection des caractères
Code   Outputs
```
\'     single quote
\"     double quote
\\     backslash
\n     new line
\r     carriage return
\t     tab
\b     backspace
\f     form feed
```

### Briser une ligne

	document.getElementById("demo").innerHTML = "Hello \
	Dolly!";

ou

	document.getElementById("demo").innerHTML = \
	"Hello Dolly!";

ou

	document.getElementById("demo").innerHTML = "Hello " +
	"Dolly!";


### Différence de type
	var x = "John";
	var y = new String("John");

	// typeof x will return string
	// typeof y will return object

### Compraison
	var x = "John";
	var y = new String("John");

	// (x == y) is true because x and y have equal values
	// (x === y) is false because x and y have different types

	var x = new String("John");             
	var y = new String("John");

	// (x == y) is false because objects cannot be compared


String Properties
```
Property     Description
constructor     Returns the function that created the String object's prototype
length     Returns the length of a string
prototype     Allows you to add properties and methods to an object
```

String Methods
```
Method               Description
charAt()             Returns the character at the specified index (position)
charCodeAt()         Returns the Unicode of the character at the specified index
concat()             Joins two or more strings, and returns a copy of the joined strings
fromCharCode()       Converts Unicode values to characters
indexOf()            Returns the position of the first found occurrence of a specified value in a string
lastIndexOf()        Returns the position of the last found occurrence of a specified value in a string
localeCompare()      Compares two strings in the current locale
match()              Searches a string for a match against a regular expression, and returns the matches
replace()            Searches a string for a value and returns a new string with the value replaced
search()             Searches a string for a value and returns the position of the match
slice()              Extracts a part of a string and returns a new string
split()              Splits a string into an array of substrings
substr()             Extracts a part of a string from a start position through a number of characters
substring()          Extracts a part of a string between two specified positions
toLocaleLowerCase()  Converts a string to lowercase letters, according to the host's locale
toLocaleUpperCase()  Converts a string to uppercase letters, according to the host's locale
toLowerCase()        Converts a string to lowercase letters
toString()           Returns the value of a String object
toUpperCase()        Converts a string to uppercase letters
trim()               Removes whitespace from both ends of a string
valueOf()            Returns the primitive value of a String object
```


## Méthode #######################
### Indexe de la première occurance
Info : 0 is the first position in a string

	var str = "Please locate where 'locate' occurs!";
	var pos = str.indexOf("locate");

### indexe de la dernière accurance
	var str = "Please locate where 'locate' occurs!";
	var pos = str.lastIndexOf("locate");

### Recherche la première occurence
comme index mais peux être plus puissant et plus paramétrable
	var str = "Please locate where 'locate' occurs!";
	var pos = str.search("locate");

### Séparer des chaines
	var str = "Apple, Banana, Kiwi";
	var res = str.slice(7,13);

ou

	var str = "apple, banana, kiwi";
	var res = str.slice(7);

ou sauf IE 8

	var str = "apple, banana, kiwi";
	var res = str.slice(-12);

ou similaire (le 2ème paramètre donne la longueur)

	var str = "Apple, Banana, Kiwi";
	var res = str.substr(7,6);

### Remplacer
	str = "Please visit Microsoft!";
	var n = str.replace("Microsoft","W3Schools");

### Transformer en majuscule
	var text1 = "Hello World!";       // String
	var text2 = text1.toUpperCase();  // text2 is text1 converted to upper
### Transformer en minuscule
	var text1 = "Hello World!";       // String
	var text2 = text1.toLowerCase();  // text2 is text1 converted to lower

### Concaténation
	var text1 = "Hello";
	var text2 = "World";
	text3 = text1.concat(" ",text2);

### Retourne un charactère
	var str = "HELLO WORLD";
	str.charAt(0);            // returns H

### Returne l'unicode d'un caractère
	var str = "HELLO WORLD";
	str.charCodeAt(0);         // returns 72


### Convertir un string en tableau
	var txt = "a,b,c,d,e";   // String
	txt.split(",");          // Split on commas
	txt.split(" ");          // Split on spaces
	txt.split("|");          // Split on pipe
	txt.split("");           // Split in characters
