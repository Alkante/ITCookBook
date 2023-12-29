# JQuery

## Selectors
### Hide click
#### Général
	<script>
	$(document).ready(function(){
	    $("p").click(function(){
	    $(this).hide();
	    });
	});
	</script>

#### Pour une balise existante
	$("p").hide()

#### Pour un id
	$("#test").hide()

#### Pour une classe
	$(".test").hide()

#### Pour l'objet courent
	$(this).hide()


## Events
### $(XXX).EVENTS

| Events          | Description      |
|+----------------|+-----------------|
| click           | click on & off   |
| dblclick        | double click     |
| mouseenter      | touch in         |
| mouseleave      | touch out        |
| mousedown       | click of         |
| mouseup         | clik on          |
| hover           | touch in & out   |
| focus and blur  | Select, unselect |


| Actions         | Description      | Options
|+----------------|+-----------------|+-----------|
| hide            | cache            | ()|"slow"|int  |
| show            | affiche          |
| toggle          | inverse          |
| fadeIn          | affiche          |
| fadeOut         | efface           |
| fadeToggle      | affiche/efface   |
| fateTo          | transparence     |
| slideDown       | affiche en slide |
| slideUp         | efface en slide  |
| slideToggle     | aff/eff en slide |
| animate         | move             | {left: '250px'}
| stop            | stop animation   |
| text            | set text         | "test"|function(){   }
| html            | set html         | "<b>text<b>"|function(){   }
|                 |                  |
| val             | set valeur       | "toto"i
| attr            | Change un attrib.| "href", "http://www.w3schools.com/jquery" ETOU callback
|                 |                  |
| append          | ajou. début html |
| prepend         | ajou. fin html   |
| after           | ajou. après      |
| before          | ajou. avant      |
|                 |                  |
| remove          | sup html         |
| empty           | remove et child  |
|                 |                  |
| addClass        | ajou. classe CSS |
| removeClass     | sup. classe CSS  |
| toggleClass     | aj/su classe CSS |
|                 |                  |
| css             | get/set CSS      |
|                 |                  |
| width           | set/get width    |
| height          | set/get height   |
| outerWidth      | outerWidth       | ()|true
| outerHeight     | outHeigt         |
|                 |                  |
| parent          | pointer parent   |
| parents         | poi. all parents |
| parentsUntil    | poi. parents stop|
|                 |                  |
| children        | poi. enfants     |
| find            | poi. enf. select |
| sibling         | poi. save level  |
|                 |                  |
| next            | poi. next in same level|
| nextAll         | poi. all next in same level|
| nexUntil        | poi. next with stop |
| first           | poi. first in same level|
| last            | poi. last in same level|
| eq              | poi. le Nieme in same level|
| filter          | poi. with filter in same level |
| not             | inverse off filter|
|                 |                  |
| load            | AJAX get         |
| get             | URL GET          |
| post            | URL POST         |
|                 |                  |
