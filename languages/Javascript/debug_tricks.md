# Débuger du Java script



### Commentaire ligne
	// Commentaire

### Commentaire block
	/*
	Commentaire
	Commentaire
	*/

### Ouverture d'un fenêtre affichant un résultat
	window.alert("5+6")
ou

	alert(5+6)
ou

	alert("Toto")

### Écrire une variable dans la page ###
	document.write(5+6);
ou

	document.write("Toto");

### Écrire une variable via un bouton après avoir effacé toute la page
	<button type="button" onclick="document.write(5 + 6)">Affiche valeur</button>

### Écrire dans une balise HTMl
	<p id="demo"></p>

	<script>
	document.getElementById("demo").innerHTML = 5 + 6;
	</script>


### Afficher dans la console ###
	<script>
	console.log(5 + 6);
	</script>
