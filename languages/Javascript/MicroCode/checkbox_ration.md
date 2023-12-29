# Check box : Bouton

## Definition
Fonctionnement :

Les checkbox et les rations sont des boutons respectivement carré et rond.
Les checkbox peuvent être coché et décoché indépendament les un des autres.
Les radions ne permet la validation que d'un bouton.

Balise reconue
```
	<input>
```
Options reconnue
```
	<input type="checkbox">

	<input type="radio">
```

Exemple type
```
	<form action="demo_form.asp">
	  <input type="checkbox" name="vehicle" value="Bike"> I have a bike<br>
	  <input type="checkbox" name="vehicle" value="Car" checked> I have a car<br>
	  <input type="submit" value="Submit">
	</form>
```


### Connaitre celui checké

#### Coté HTML
```
<input class="messageCheckbox" type="checkbox" value="0" name="mailId[]">
<input class="messageCheckbox" type="checkbox" value="1" name="mailId[]">
```

#### |1 Explorateur moderne
```
	var checkedValue = document.querySelector('.messageCheckbox:checked').value;
```

#### |2 jQuery
```
	var checkedValue = $('.messageCheckbox:checked').val();
```

#### |3 Pure JavaScript
```
	var checkedValue = null;
	var inputElements = document.getElementsByClassName('messageCheckbox');
	for(var i=0; inputElements[i]; ++i){
		if(inputElements[i].checked){
		checkedValue = inputElements[i].value;
		break;
	}
}
```
