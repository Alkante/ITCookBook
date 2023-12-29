# Opération

### Afficher et faire une opération
	<script>
	document.getElementById("demo").innerHTML = (11/5)+3;
	</script>

### Concaténer
	<script>
	document.getElementById("demo").innerHTML = "John" + " "  + "Doe";
	</script>

### Utilisation de variable
	<p id="demo"></p>

	<script>
	var carName = "Volvo";
	document.getElementById("demo").innerHTML = carName;
	</script>

or

	var person = "John Doe", carName = "Volvo", price = 200;

or

	var person = "John Doe",
	carName = "Volvo",
	price = 200;

A savoir
* Retourn "undefined" si elle est non définie
* Une redéclaration de variable est possible mais elle garde ca valeur (comme si de rien n'étatait)
* Lors d'une concaténation str + int, le résultat sera "str".


### Liste des opérateurs Mathématiques
Operator 	Description
```
+ 	Addition
- 	Subtraction
* 	Multiplication
/ 	Division
% 	Modulus
++ 	Increment
-- 	Decrement
```

### Liste de priorité des opérateur
Operator  Precedence
```
( )       Expression grouping
++ --     Increment and decrement
* / %     Multiplication, division, and modulo division
+ -       Addition and subtraction
```


### Liste des opérateurs d'assignements
Operator Example    Same As
```
=        x = y      x = y
+=       x += y     x = x + y
-=       x -= y     x = x - y
*=       x *= y     x = x * y
/=       x /= y     x = x / y
%=       x %= y     x = x % y
```

### Liste des opérateurs logiques et de comparaison
Operator 	Description
```
== 	equal to
=== 	equal value and equal type
!= 	not equal
!== 	not equal value or not equal type
> 	greater than
< 	less than
>= 	greater than or equal to
<= 	less than or equal to
```
