// -------------------------------------------------------------------------------------------------
// main function

fun main(args: Array<String>) {
    println("Hello, world!")
}


// -------------------------------------------------------------------------------------------------
// vars var and consts val

val myConst = "Ima const"
var myVar = "Ima var"

var myInt: Int = 3
var myNUllableInt: Int? = 3


// -------------------------------------------------------------------------------------------------
// println and printing variables and constants:

val myDirectlyAccessedVal = 42
println( "The var is is $myDirectlyAccessedVal")

val myIndirectlyAccessedVal = User()
println( "The var is is ${myIndirectlyAccessedVal.name}")


// -------------------------------------------------------------------------------------------------
// function

fun myFunction(i: Int): Int {
    return 42
}

fun myNamedInlineFunctiom(a: String, b: String): Boolean = a.length < b.length


// -------------------------------------------------------------------------------------------------
// classes

class Empty

class ClassWithVolatile() {
    @Volatile private var mapInitialized = false
}

class ClassWithPublicVar() {
    public var i = 42
}

// -------------------------------------------------------------------------------------------------
// visibility modifiers

private // only visible within class
protected // same as private, but also visible in subclasses
internal  // package internal visible, if declaring class is visible
public  // everywhere visible, if declaring class is visible; default


// -------------------------------------------------------------------------------------------------
// data class
// data classes work like c++ structs

data class MyDataClass(val age: Int)

data class PersonData(val name: String, val age: Int)
val theToni: PersonData = PersonData("Toni", 23)
println(theToni.name + "'s age is " + theToni.age)


// -------------------------------------------------------------------------------------------------
// enum class

enum class Direction {
    NORTH, SOUTH, WEST, EAST
}


enum class Color(val rgb: Int) {
        RED(0xFF0000),
        GREEN(0x00FF00),
        BLUE(0x0000FF)
}

val myColor: Color = Color.RED
println(myColor.toString() + " value is " + myColor.rgb)  // prints RED value is 16711680


// -------------------------------------------------------------------------------------------------
// safe and asserted calls

var myNotNullable: Int = 13
var myNullable: String? = null  // only safe ?. or asserted calls !!. are allowed on nullables
myNullable!!.length  // asserted call; will throw an exception, if myNullable is null
myNullable?.length  // safe call; will not try to access the member if myNullable is null


if( myNullable?.length == 23 /*resolves to false if myNullable is null*/) {
    println( "Will never happen when myNullable is null" )
}

// -------------------------------------------------------------------------------------------------
// null check / else case, aka elvis operator

val l: Int = if (b != null) b.length else -1
val m = b?.length ?: -1                         // if b not null, choose b.length, else choose -1
val n = b ?: anotherBThatIsNotNull              // if b not null, choose b, else choose anotherBThatIsNotNull


val unwrappedString = wrappedString?.let { it } ?: return

// -------------------------------------------------------------------------------------------------
// when-is idiom

when (value) {
    is String? -> edit({ it.putString(key, value) })
    is Int -> edit({ it.putInt(key, value) })
    is Boolean -> edit({ it.putBoolean(key, value) })
    is Float -> edit({ it.putFloat(key, value) })
    is Long -> edit({ it.putLong(key, value) })
    else -> throw UnsupportedOperationException("Not yet implemented")
}


// -------------------------------------------------------------------------------------------------
// in kotlin, you can import functions Oo

import com.here.ivi.reference.common.extensions.myFavoriteFunction  // imports a function
myFavoriteFunction("inputparam-1",2)


// -------------------------------------------------------------------------------------------------
// companion objects

class MyClassWithCompanion {
    companion object {
        fun similarToAStaticMethod() {
            println("This is similar to static in Java, but its not interoperable with Java in a static way")
        }

        @JvmStatic // works only in companion object or object scope
        fun moreSimilarToAStaticMethod() {
            println("Is interoperable with Java in a static way")
        }

        fun create() : MyClassWithCompanion {
            println( "companion object methods can be used for factory methods")
        }
    }
}

var myCreatedObject = MyClassWithCompanion.create()
MyClassWithCompanion.similarToAStaticMethod()


// -------------------------------------------------------------------------------------------------
// KOTLIN I DON'T YET REALLY UNDERSTAND


reified


synchronized(this@MapView) {
    // ...
}


Thread {
    if ( /*...*/ ) {
        return@Thread
    }
    // ...
}.start()



return (0 until event.pointerCount).map {
    TouchPoint(
        event.getX(it), event.getY(it), 0.0f, 0.0f, timestamp,
        event.getPointerId(it).toLong()
    )
}



override fun newArray(size: Int): Array<SavedState?> {
    return arrayOfNulls<SavedState?>(size)  // arrayOfNulls<SavedState>
}


class ClassWithShortFunctions {
    fun getMyName(): String = "myClassName"
}


myObject.property1 = 42        # this
myObject.property2 = 12.3      # ...
myObject.property3 = ":)"      # ...
// ...

myObject.apply {               # can be accumulated with .apply { ... }
    property1 = 42
    property2 = 12.3
    property3 = ":)"
    // ...
}