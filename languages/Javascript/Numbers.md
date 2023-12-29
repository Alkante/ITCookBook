# Les nombres

### sous type
	var x = 34.00;    // A number with decimals
	var y = 34;       // A number without decimals
	var x = 123e5;    // 12300000
	var y = 123e-5;   // 0.00123


Value (aka Fraction/Mantissa) 	Exponent 	Sign
```
52 bits (0 - 51)  	11 bits (52 - 62) 	1 bit (63)
```

	var x = 0xFF;             // x will be 255

	var myNumber = 128;
	myNumber.toString(16);     // returns 80
	myNumber.toString(8);      // returns 200
	myNumber.toString(2);      // returns 10000000

### Infini
	var myNumber = 2;
	while (myNumber != Infinity) {          // Execute until Infinity
	    myNumber = myNumber * myNumber;
	}

	var x =  2 / 0;          // x will be Infinity
	var y = -2 / 0;          // y will be -Infinity
	typeof Infinity;        // returns "number"

### Not a number
	var x = 100 / "Apple";  // x will be NaN (Not a Number)
	var x = 100 / "10";     // x will be 10

	var x = 100 / "Apple";
	isNaN(x);               // returns true because x is Not a Number

	var x = NaN;
	var y = 5;
	var z = x + y;         // z will be NaN

	var x = NaN;
	var y = "5";
	var z = x + y;         // z will be NaN5

	typeof NaN;             // returns "number"

### Number and object
	var x = 123;
	var y = new Number(123);

	// typeof x returns number
	// typeof y returns object

	var x = 500;
	var y = new Number(500);

	// (x == y) is true because x and y have equal values

	var x = 500;
	var y = new Number(500);

	// (x === y) is false because x and y have different types

	var x = new Number(500);
	var y = new Number(500);

	// (x == y) is false because objects cannot be compared

```
Number Properties
Property 	Description
MAX_VALUE 	Returns the largest number possible in JavaScript
MIN_VALUE 	Returns the smallest number possible in JavaScript
NEGATIVE_INFINITY 	Represents negative infinity (returned on overflow)
NaN 	Represents a "Not-a-Number" value
POSITIVE_INFINITY 	Represents infinity (returned on overflow)
```

### Valeur maximale
	var x = Number.MAX_VALUE;

	var x = 6;
	var y = x.MAX_VALUE;    // y becomes undefined
