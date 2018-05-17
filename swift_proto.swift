// -------------------------------------------------------------------------------------------------
// Imports
import Foundation


// -------------------------------------------------------------------------------------------------
// Variables, Types and Aliases

var myVariable = 12;
var myVariable: Int = 13;
var myVariable = String(42)  // works
// var myVariable: String = 42  // does not work
var myNullable: String? = "I can be nil"  // optionals

let myConstant = "ima const"

static let myStaticConstant = 42;

typealias myAlias = ([Int]) -> Void

// methods optionals followed by ?. are not executed if the optional is nil
var myNullableInt: Int? = nil
myNullableInt?.hashValue  // will NOT executed
myNullableInt = 23
myNullableInt?.hashValue  // will be executed


?.hashValue
let radius = optionalCircle?.radius


// -------------------------------------------------------------------------------------------------
// if let guards for nullables / optionals

if let myObject = valueFromSomewhere {  // if valueFromSomewhere is not nil, do something with it
    myObject.isEnabled = enabled
}


var optionalName: String? = "John Appleseed"  // or: nil
var greeting = "Hello :)"
if let name = optionalName {
    greeting = "Yo, \(name) :)"
}
print(greeting)


let name: String? = nil
let defaultName: String = "John Appleseed"
let myString = "Hi \(name ?? defaultName)"  // ?? default
let myString2 = "Hi \(name ?? "also a default :)")"  // ?? default


var myOptional: Int? = "hahahaha"
myOptional!.negate()  // forced unwrapping: myOptional! gives the Int value if it exists, runtime error if it is nil


// -------------------------------------------------------------------------------------------------
// Arrays and Dictionaries

var peopleDictionary = [
    "Anna": 67,
    "Benni": 8,
]
peopleDictionary["Dario"] = 29

let explicitPeopleDictionary: [String: Int] = [
    "Anna": 64,
    "Benni": 7,
]

let emptyArray = [String]()
let emptyArray: String = []
let emptyDictionary = [String: Float]()
let emptyDictionary: [String: Float] = [:]


// -------------------------------------------------------------------------------------------------
// Strings and Printing

print( "Hello " + 42) // does not work
print( "Hello " + String(42)) // variables are not converted implicitly
print( "Hello \(myVariable)")  // variables or values can be evaluated in strings with \(myvar)
print( "Hello \(12+13.3)")  // prints "Hello 25.3"

// multi line strings start with """
let quote = """
   I am a "multiline String"
   Indentation is not taken 'into account' as long as consistent, also With the ending \"""
  """


// -------------------------------------------------------------------------------------------------
// if

if 51 > 50 {
    print("yeah")
} else {
    print("nooo")
}

// if 51 { }  // does not work, the argument to the if must be a Boolean expression
// if nil { }  // does not work, the argument to the if must be a Boolean expression

// Parentheses around the condition or loop variable are optional


// -------------------------------------------------------------------------------------------------
// switch

switch myEnumInstance {
case .mauz:
    print("MauZ")
    // I dont need no 'break' statement :)))
caus .miep:
    break  // 'case' label in a 'switch' should have at least one executable statement!, so, if no other statement is there
case .wau:
    // I also don't need to specify the whole EnumType.enumValue
    // but just the enumValue :)
default:
    // default case is mandatory
}


let vegetable = "red pepper"
switch vegetable {
case "celery":
    // print("all case types are good")
case "cucumber", "watercress":
    // print("Several cases at once")
case let x where x.hasSuffix("pepper"):
    // print("More complex checks")
default:
    // print("Everything tastes good in soup.")
}


// -------------------------------------------------------------------------------------------------
// for loops

for f in fruits{
    print("\(f) ", terminator: "")
}


for (name, age) in peopleDictionary {
    print("\(name) is \(age) years old.")
}


for i in 0..<4 {  // sic!  i in { 0,1,2,3 }
    print(i)
}

for i in 0...4 {  // sic!  i in { 0,1,2,3,4 }
    print(i)
}


// -------------------------------------------------------------------------------------------------
// while loops

var n = 2
while n < 100 {
    n *= 2
}


var m = 2
repeat {
    m *= 2
} while m < 100


// -------------------------------------------------------------------------------------------------
// Functions

func foo( xCoord: Float, yCoord: Float, radius: Int) -> String {
    print(" \(xCoord), \(yCoord) and \(radius)")
    return "Joooooo";
}
foo( xCoord: 1.1, yCoord: 2.2, radius: 12)


// Use underscores _ to omit variable names on method invocation
func foo2(_ myParamName: Int, _ alsoNotNeededParamName: Float) -> Void {
    print(" \(myParamName) and \(alsoNotNeededParamName)")
}
foo2(3, 5.8)
// foo2(myParamName: 3, alsoNotNeededParamName: 5.8)  // doesn't work


func returnATuple() -> (min: Int, max: Int, sum: Int) {
    return (-3, 5, 2)
}
let myTuple = returnATuple()
print(myTuple.max)
print(myTuple.1) // "5"



func outerFun() -> Int {
    var x = 10

    func nestedFun() -> Void {
        x += 5
    }

    nestedFun()
    return x
}


func functionReturnsFunction() -> ((Int) -> Int) {
    func returnedFunction(number: Int) -> Int {
        return 1 + number
    }
    return returnedFunction
}
var myFun = functionReturnsFunction()
myFun(7)


func functionAsArgument(list: [Int], condition: (Int) -> Bool) -> Void {
    // ...
}

// -------------------------------------------------------------------------------------------------
// Closures

let numbers = [ 1, 2, 4, 8]
let mapResult = numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})


// When a closure’s type is already known, such as the callback for a delegate,
// you can omit the type of its parameters, its return type, or both.
//
// Single statement closures implicitly return the value of their only statement.

let shortMapResult = numbers.map({ number in 4 * number })



// You can refer to closure parameters by number instead of by name — useful in very short closures.
// A closure passed as the last argument to a function can appear immediately after the parentheses. (counterexample missing here, yet).
// When a closure is the only argument to a function, you can omit the functionparentheses entirely.

let sortedAscending = numbers.sorted { $0 < $1 }

// -------------------------------------------------------------------------------------------------
// Classes

class MyClass {
    let myConst = 42
    var myVar = 12.3

    /**
     * @brief [brief description]
     * @details [long description]
     * @return [description]
     */
    func foo() -> String {
        return "MyClass's instance with myVar=\(myVar)."
    }
}
var myInstance = MyClass()
myInstance.myVar = 8


class MyClassWithInit {
    var myVar: Double // not having a std valeu forces you to init the value in an init function

    init(v: Double) {
        print("Addin an init function disables the standard init function")
        self.myVar = v
    }
}
//var myInstance = MyClassWithInit() // does not work
var myInstance = MyClassWithInit(v:8) // works


public class MyClassWithVisibilitySpecifiers {
    /* Visibility
     *
     * open - publicly visible AND subclassable / overrrideable within own scope and any scope that imports the defining module
     * public - publicly visible and usable within own scope and any scope that imports the defining module
     * internal - visible within any source file of the defining module
     * private - visible only within the defining file
    */
    open var MyOpenVar: Int?
    public var MyPublicVar: Int?
    internal var MyInternalVar: Int?
    private var MyPrivateVar: Int?
}


open class OpenChargerProvider: NSObject, AMSRouteChargingStationProviderProtocol {

    /**
     * Doc
     */
    open class func fpp(param: ParamType) -> ReturnType
}

public enum MyEnum : Int {
    case mauz
    case wau
    case yocat
}

func funcThatTakesEnum(myInput: MyEnum) {
    print(myInput);
}
funcThatTakesEnum(myInput: .mauz)


public enum MyTypedEnum String {
    case day = "Its daytime!"
    case night = "Time to sleep :)"
    var text: String { return self.rawValue } // returns the according string
}


// -------------------------------------------------------------------------------------------------
// defer statement

public static func helloWorldMethod(inputString: String) -> String? {
    defer {
        // will be executed before going out of the block, as second
    }
    defer {
        // will be executed before going out of the block, as first
    }
    if let some_var = String("hello") {
        // defer statements will be executed here
        return 42
    }

    // defer statements will be executed here
    return nil
}

// -------------------------------------------------------------------------------------------------
// Protocols, Classes and Extensions

public protocol MyProtocol: class {
    // ...
}

open class MyClass: MyProtocol {
    // ...
}

extension MyClass {
    // extends MyClass about functions that might be declared in a protocol
    // ...
}

// -------------------------------------------------------------------------------------------------
// Protocols getters and setters

class ClassWithAttributesThatHaveGettersAndSetters {



public protocol MyProtocol: class {
    var myAttribute: String { get set }
}


open class MyClass: MyProtocol {

    public var displayPois: Bool {
        set {
            myAttribute = newValue
        }
        get { return myAttribute }
    }
}

// -------------------------------------------------------------------------------------------------
// escaping

class DeinitListener : EmptyListener {
    let deinitCallback: () -> Void
    init(callOnDeinit: @escaping () -> Void) {        // escaping lets you call things from inside the closure outside the closure
        self.deinitCallback = callOnDeinit
    }
    deinit {
        deinitCallback()
    }
}

// -------------------------------------------------------------------------------------------------
// class extensions

extension Collection where Element: Collection, Element.Element == UInt8  {
    public func c_conversion()-> (c_type: arrayCollection_UInt8Array, cleanup: () ->Void) {
        // ...
    }
}


// -------------------------------------------------------------------------------------------------
// an inner type cannot be named Type, since it would collide with foo.Type

class C { enum Type : UInt32 { case DAY ; case NIGHT } } // doesn't work




// -------------------------------------------------------------------------------------------------
// subscripts

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// Prints "six times three is 18"


// subscripts can work not only on ints but also on arbitrary data types, e.g. Strings


// -------------------------------------------------------------------------------------------------

