// author: andreasl

// -------------------------------------------------------------------------------------------------
// misc

"use strict"; // enables strict mode, i.e. disallows usage of non-declared variables and more

; // semicolons are not necessarily necessary. If not decided otherwise, I recommend them

triple === equals operator is stricter than the double == equals operator

// -------------------------------------------------------------------------------------------------
// vars and consts

const myConst = 42.0;
let myBlockScopedVariable = "Hello";
var myGlobalScopedVariable = "World";


// -------------------------------------------------------------------------------------------------
// logging

console.log("logs to console");
window.alert("opens a message box");
alert("same as window.alert");


// -------------------------------------------------------------------------------------------------
// object orientation

// use maps judiciously to bundle stuff:
const myAggregate = {
    program: shaderProgram,
    innerValue: 12.3,
    innerValue2: "my string",
    myFoo: function(myInput) {
        alert("Caution: " + myInput);
    }
}


funcion foo(myInput) {

    // You can use maps to move around complex objects, even functions.
    let myVar = myInput.innerValue;
    myInput.myFoo(42.0);

    // You can use maps to return complex objects
    return {
        someVal: 4,
        isEqualToSomeVal: function(input) {
            return input == this.someVal;
        }
    }
}
foo(myAggregate);


// -------------------------------------------------------------------------------------------------
// null vs. undefined

typeof null  == object; // is true

var myVar
typeof myvar == undefined; // is true

Boolean(null) == false; // = true
Boolean(undefined) == false; // = true
undefined == null; // = thrue, but gives warning
undefined === null; // = false, gives no warning


// -------------------------------------------------------------------------------------------------
// Array destructuring - take values from an array into variables

const arr = ['ignore', 'keepme'];
const [, token] = arr; // skips first, token = 'keepme'


// -------------------------------------------------------------------------------------------------
// Object destructuring

// call the function, await its result, then take only the `myfield` property from that returned object
const { myfield } = await openAPIHandler.handle(...);
/*
Equivalent to:

const result = await openAPIHandler.handle(...);
const myfield = result.myfield;
*/


// -------------------------------------------------------------------------------------------------
// Nullish coalescing operator  `?? []`
//
// ?? (nullish coalescing) only falls back if the left side is null or undefined.
// || (logical OR) falls back if the left side is falsy (null, undefined, 0, false, '', NaN).

const maybeNull = null
const value = maybeNull ?? 'fallback';


// -------------------------------------------------------------------------------------------------
// !!   converts any value to a strict boolean; it's shorthand for "is this truthy?"

!!'abc'   // true
!!0       // false
!!null    // false


// -------------------------------------------------------------------------------------------------
// optional chaining

const store = stores.stores?.find((s) => s.name === "mystore");


// -------------------------------------------------------------------------------------------------
// async sleep

await new Promise((resolve) => setTimeout(resolve, 2345));  // in ms; resolve is just a dummy var
