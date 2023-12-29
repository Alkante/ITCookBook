# Function
### Fonction définition et appel
	function name(parameter1, parameter2, parameter3) {
	    code to be executed
	}

	document.getElementById("demo").innerHTML = name(32,35,64);


## Trick
### Afficher en HTML la définission de la fonction
	document.getElementById("demo").innerHTML = name;


### Event Date
	<p id="demo"></p>

	<button onclick="getElementById('demo').innerHTML=Date()">The time is?</button>
ou afficher dans le bouton
	<button onclick="this.innerHTML=Date()">The time is?</button>
ou plus vite
	<p id="demo"></p>

	<script>
	function displayDate() {
	    document.getElementById("demo").innerHTML = Date();
	}
	</script>


### Évènnement de base

|Event       | Description                                         |
|------------|-----------------------------------------------------|
|onchange    | An HTML element has been changed                    |
|onclick     | The user clicks an HTML element                     |
|onmouseover | The user moves the mouse over an HTML element       |
|onmouseout  | The user moves the mouse away from an HTML element  |
|onkeydown   | The user pushes a keyboard key                      |
|onload      | The browser has finished loading the page           |



### Liste de tout les evènement
HTML DOM Events
```
DOM: Indicates in which DOM Level the property was introduced.
Mouse Events
Event 	Description 	DOM
onclick 	The event occurs when the user clicks on an element 	2
oncontextmenu 	The event occurs when the user right-clicks on an element to open a context menu 	3
ondblclick 	The event occurs when the user double-clicks on an element 	2
onmousedown 	The event occurs when the user presses a mouse button over an element 	2
onmouseenter 	The event occurs when the pointer is moved onto an element 	2
onmouseleave 	The event occurs when the pointer is moved out of an element 	2
onmousemove 	The event occurs when the pointer is moving while it is over an element 	2
onmouseover 	The event occurs when the pointer is moved onto an element, or onto one of its children 	2
onmouseout 	The event occurs when a user moves the mouse pointer out of an element, or out of one of its children 	2
onmouseup 	The event occurs when a user releases a mouse button over an element 	2
Keyboard Events
Event 	Description 	DOM
onkeydown 	The event occurs when the user is pressing a key 	2
onkeypress 	The event occurs when the user presses a key 	2
onkeyup 	The event occurs when the user releases a key 	2
Frame/Object Events
Event 	Description 	DOM
onabort 	The event occurs when the loading of a resource has been aborted 	2
onbeforeunload 	The event occurs before the document is about to be unloaded 	2
onerror 	The event occurs when an error occurs while loading an external file 	2
onhashchange 	The event occurs when there has been changes to the anchor part of a URL 	3
onload 	The event occurs when an object has loaded 	2
onpageshow 	The event occurs when the user navigates to a webpage 	3
onpagehide 	The event occurs when the user navigates away from a webpage 	3
onresize 	The event occurs when the document view is resized 	2
onscroll 	The event occurs when an element's scrollbar is being scrolled 	2
onunload 	The event occurs once a page has unloaded (for <body>) 	2
Form Events
Event 	Description 	DOM
onblur 	The event occurs when an element loses focus 	2
onchange 	The event occurs when the content of a form element, the selection, or the checked state have changed (for <input>, <keygen>, <select>, and <textarea>) 	2
onfocus 	The event occurs when an element gets focus 	2
onfocusin 	The event occurs when an element is about to get focus 	2
onfocusout 	The event occurs when an element is about to lose focus 	2
oninput 	The event occurs when an element gets user input 	3
oninvalid 	The event occurs when an element is invalid 	3
onreset 	The event occurs when a form is reset 	2
onsearch 	The event occurs when the user writes something in a search field (for <input="search">) 	3
onselect 	The event occurs after the user selects some text (for <input> and <textarea>) 	2
onsubmit 	The event occurs when a form is submitted 	2
Drag Events
Event 	Description 	DOM
ondrag 	The event occurs when an element is being dragged 	3
ondragend 	The event occurs when the user has finished dragging an element 	3
ondragenter 	The event occurs when the dragged element enters the drop target 	3
ondragleave 	The event occurs when the dragged element leaves the drop target 	3
ondragover 	The event occurs when the dragged element is over the drop target 	3
ondragstart 	The event occurs when the user starts to drag an element 	3
ondrop 	The event occurs when the dragged element is dropped on the drop target 	3
Clipboard Events
Event 	Description 	DOM
oncopy 	The event occurs when the user copies the content of an element
oncut 	The event occurs when the user cuts the content of an element
onpaste 	The event occurs when the user pastes some content in an element
Print Events
Event 	Description 	DOM
onafterprint 	The event occurs when a page has started printing, or if the print dialogue box has been closed 	3
onbeforeprint 	The event occurs when a page is about to be printed 	3
Media Events
Event 	Description 	DOM
onabort 	The event occurs when the loading of a media is aborted 	3
oncanplay 	The event occurs when the browser can start playing the media (when it has buffered enough to begin) 	3
oncanplaythrough 	The event occurs when the browser can play through the media without stopping for buffering 	3
ondurationchange 	The event occurs when the duration of the media is changed 	3
onemptied 	The event occurs when something bad happens and the media file is suddenly unavailable (like unexpectedly disconnects) 	3
onended 	The event occurs when the media has reach the end (useful for messages like "thanks for listening") 	3
onerror 	The event occurs when an error occurred during the loading of a media file 	3
onloadeddata 	The event occurs when media data is loaded 	3
onloadedmetadata 	The event occurs when meta data (like dimensions and duration) are loaded 	3
onloadstart 	The event occurs when the browser starts looking for the specified media 	3
onpause 	The event occurs when the media is paused either by the user or programmatically 	3
onplay 	The event occurs when the media has been started or is no longer paused 	3
onplaying 	The event occurs when the media is playing after having been paused or stopped for buffering 	3
onprogress 	The event occurs when the browser is in the process of getting the media data (downloading the media) 	3
onratechange 	The event occurs when the playing speed of the media is changed 	3
onseeked 	The event occurs when the user is finished moving/skipping to a new position in the media 	3
onseeking 	The event occurs when the user starts moving/skipping to a new position in the media 	3
onstalled 	The event occurs when the browser is trying to get media data, but data is not available 	3
onsuspend 	The event occurs when the browser is intentionally not getting media data 	3
ontimeupdate 	The event occurs when the playing position has changed (like when the user fast forwards to a different point in the media) 	3
onvolumechange 	The event occurs when the volume of the media has changed (includes setting the volume to "mute") 	3
onwaiting 	The event occurs when the media has paused but is expected to resume (like when the media pauses to buffer more data) 	3
Animation Events
Event 	Description 	DOM
animationend 	The event occurs when a CSS animation has completed 	3
animationiteration 	The event occurs when a CSS animation is repeated 	3
animationstart 	The event occurs when a CSS animation has started 	3
Transition Events
Event 	Description 	DOM
transitionend 	The event occurs when a CSS transition has completed 	3
Server-Sent Events
Event 	Description 	DOM
onerror 	The event occurs when an error occurs with the event source
onmessage 	The event occurs when a message is received through the event source
onopen 	The event occurs when a connection with the event source is opened
Misc Events
Event 	Description 	DOM
onmessage 	The event occurs when a message is received through or from an object (WebSocket, Web Worker, Event Source or a child frame or a parent window) 	3
onmousewheel 	Deprecated. Use the onwheel event instead
ononline 	The event occurs when the browser starts to work online 	3
onoffline 	The event occurs when the browser starts to work offline 	3
onpopstate 	The event occurs when the window's history changes 	3
onshow 	The event occurs when a <menu> element is shown as a context menu 	3
onstorage 	The event occurs when a Web Storage area is updated 	3
ontoggle 	The event occurs when the user opens or closes the <details> element 	3
onwheel 	The event occurs when the mouse wheel rolls up or down over an element 	3
Touch Events
Event 	Description 	DOM
ontouchcancel 	The event occurs when the touch is interrupted
ontouchend 	The event occurs when a finger is removed from a touch screen
ontouchmove 	The event occurs when a finger is dragged across the screen
ontouchstart 	The event occurs when a finger is placed on a touch screen
Event Object
Constants
Constant 	Description 	DOM
CAPTURING_PHASE 	The current event phase is the capture phase (1) 	1
AT_TARGET 	The current event is in the target phase, i.e. it is being evaluated at the event target (2) 	2
BUBBLING_PHASE 	The current event phase is the bubbling phase (3) 	3
Properties
Property 	Description 	DOM
bubbles 	Returns whether or not a specific event is a bubbling event 	2
cancelable 	Returns whether or not an event can have its default action prevented 	2
currentTarget 	Returns the element whose event listeners triggered the event 	2
defaultPrevented 	Returns whether or not the preventDefault() method was called for the event 	3
eventPhase 	Returns which phase of the event flow is currently being evaluated 	2
isTrusted 	Returns whether or not an event is trusted 	3
target 	Returns the element that triggered the event 	2
timeStamp 	Returns the time (in milliseconds relative to the epoch) at which the event was created 	2
type 	Returns the name of the event 	2
view 	Returns a reference to the Window object where the event occured 	2
Methods
Method 	Description 	DOM
preventDefault() 	Cancels the event if it is cancelable, meaning that the default action that belongs to the event will not occur 	2
stopImmediatePropagation() 	Prevents other listeners of the same event from being called 	3
stopPropagation() 	Prevents further propagation of an event during event flow 	2
MouseEvent Object
Property 	Description 	DOM
altKey 	Returns whether the "ALT" key was pressed when the mouse event was triggered 	2
button 	Returns which mouse button was pressed when the mouse event was triggered 	2
buttons 	Returns which mouse buttons were pressed when the mouse event was triggered 	3
clientX 	Returns the horizontal coordinate of the mouse pointer, relative to the current window, when the mouse event was triggered 	2
clientY 	Returns the vertical coordinate of the mouse pointer, relative to the current window, when the mouse event was triggered 	2
ctrlKey 	Returns whether the "CTRL" key was pressed when the mouse event was triggered 	2
detail 	Returns a number that indicates how many times the mouse was clicked 	2
metaKey 	Returns whether the "META" key was pressed when an event was triggered 	2
relatedTarget 	Returns the element related to the element that triggered the mouse event 	2
screenX 	Returns the horizontal coordinate of the mouse pointer, relative to the screen, when an event was triggered 	2
screenY 	Returns the vertical coordinate of the mouse pointer, relative to the screen, when an event was triggered 	2
shiftKey 	Returns whether the "SHIFT" key was pressed when an event was triggered 	2
which 	Returns which mouse button was pressed when the mouse event was triggered 	2
KeyboardEvent Object
Property 	Description 	DOM
altKey 	Returns whether the "ALT" key was pressed when the key event was triggered 	2
ctrlKey 	Returns whether the "CTRL" key was pressed when the key event was triggered 	2
charCode 	Returns the Unicode character code of the key that triggered the onkeypress event 	2
key 	Returns the key value of the key represented by the event 	3
keyCode 	Returns the Unicode character code of the key that triggered the onkeypress event, or the Unicode key code of the key that triggered the onkeydown or onkeyup event 	2
location 	Returns the location of a key on the keyboard or device 	3
metaKey 	Returns whether the "meta" key was pressed when the key event was triggered 	2
shiftKey 	Returns whether the "SHIFT" key was pressed when the key event was triggered 	2
which 	Returns the Unicode character code of the key that triggered the onkeypress event, or the Unicode key code of the key that triggered the onkeydown or onkeyup event 	2
HashChangeEvent Object
Property 	Description 	DOM
newURL 	Returns the URL of the document, after the hash has been changed
oldURL 	Returns the URL of the document, before the hash was changed
PageTransitionEvent Object
Property 	Description 	DOM
persisted 	Returns whether the webpage was cached by the browser
FocusEvent Object
Property 	Description 	DOM
relatedTarget 	Returns the element related to the element that triggered the event 	3
AnimationEvent Object
Property 	Description 	DOM
animationName 	Returns the name of the animation
elapsedTime 	Returns the number of seconds an animation has been running
TransitionEvent Object
Property 	Description 	DOM
propertyName 	Returns the name of the CSS property associated with the transition
elapsedTime 	Returns the number of seconds a transition has been running
WheelEvent Object
Property 	Description 	DOM
deltaX 	Returns the horizontal scroll amount of a mouse wheel (x-axis) 	3
deltaY 	Returns the vertical scroll amount of a mouse wheel (y-axis) 	3
deltaZ 	Returns the scroll amount of a mouse wheel for the z-axis 	3
deltaMode 	Returns a number that represents the unit of measurements for delta values (pixels, lines or pages) 	3
```
