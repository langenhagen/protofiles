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