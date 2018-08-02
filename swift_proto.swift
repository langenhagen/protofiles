// -------------------------------------------------------------------------------------------------
// Imports
import Foundation

// -------------------------------------------------------------------------------------------------
// Types

Bool

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
let myString = "Hi \(name ?? defaultName)"  // ?? choses name, and defaultName, if name is nil
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


// use outer argument labels to use a label different from the inside of the variable name
func foo2(myLabel myParamName: Int) -> Void {
    print(" \(myParamName) with myLabel")
}
foo2(myLabel: 3)


// Use underscores _ to omit variable names on method invocation
func foo3(_ myParamName: Int, _ alsoNotNeededParamName: Float) -> Void {
    print(" \(myParamName) and \(alsoNotNeededParamName) with underscore")
}
foo3(3, 5.8)
// foo3(myParamName: 3, alsoNotNeededParamName: 5.8)  // doesn't work


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
        print("Adding an init function disables the standard init function")
        self.myVar = v
        // super.init() // you have to call super.init() manually
    }

    deinit {
        print("Use optional deinit to create a deinitializer if you need to perform cleanup before the object is deallocated.")
    }
}
//var myInstance = MyClassWithInit() // does not work
var myInstance = MyClassWithInit(v:8) // works

class MySuperClass {
    // ...
    func myFunc() {
        // ...
    }
}

class MySubclass: MySuperClass {
    // ...
    override func myFunc() {
        // ...
    }
}


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
    open class func foo(param: ParamType) -> ReturnType {
        // ...
    }
}

// -------------------------------------------------------------------------------------------------
// enumerations

enum MyEnum : Int {
    case mauz
    case wau
    case yocat
}
let myEnumObject = MyEnum.mauz // = .mauz
let myEnumObjectRawValue = MyEnum.mauz.rawValue // = 0 rawValue behave like C++ enum values, if int or not specified
let anotherEnumObjectFromRawValue = MyEnum(rawValue: 2) // = yocat


func funcThatTakesEnum(myInput: MyEnum) {
    print(myInput);
}
funcThatTakesEnum(myInput: .mauz)


// Also strings and floats are possible raw values
enum MyTypedEnum String {
    case day = "Its daytime!"
    case night = "Time to sleep :)"
    var text: String { return self.rawValue } // returns the according string
}


enum EnumWithMethod: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceDescription = ace.simpleDescription()



enum MyEnumWithMixedRawTypes {
    case sunriseAndSunset(String, String)  // raw values can be multiple values
    case failure(String)         // raw value types can differ from case to case
}
let failure = MyEnumWithMixedRawTypes.failure("Out of cheese.")
let success = MyEnumWithMixedRawTypes.sunriseAndSunset("6:00 am", "8:09 pm")

switch success {
case let .sunriseAndSunset(sunrise, sunset):  // getting raw values out of the enum ojects
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure...  \(message)")
}


// -------------------------------------------------------------------------------------------------
// willSet and didSet

class ClassWithWillSetAndDidSet {
    var varWithWillSet: Int {
        willSet {
            print("Called before setting the variable")
        }
    }
    var varWithWillSetAndDidSet: Int {
        willSet {
            print("Called before setting the variable")
        }
        didSet {
            print("Called after setting the variable")
        }
    }
}



// -------------------------------------------------------------------------------------------------
// defer statement

public static func helloWorldMethod(inputString: String) -> String? {
    defer {
        // will be executed before going out of the block, as second

        // defer statements will also be executed if the function would throw an error
        // and thus can be used for cleanup
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
// errors, throws, throw, do catch try

// error enums
enum PrinterError: Error {  // adopts the error protocol
    case outOfPaper
    case noToner
    case onFire
}

func canThrowAnError(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner  // throws an error here
    }
    return "Job sent"
}

do {
    let result = try canThrowAnError(job: 1040, toPrinter: "MyPrinter")  // try things
    print(result)
} catch {
    print(error)  // errors are implicitly automatically called 'error' unless we call them otherwise
}


// multiple catch blocks to handle different errors and error types
do {
    let result = try send(job: 1440, toPrinter: "Gutenberg")
    print(result)
} catch PrinterError.onFire {
    print("catch blocks are then like switch/case blocks")
} catch let myPrinterError as PrinterError {
    print("Printer error: \(PrinterError).")
} catch {
    print("Any other error type: \(error)")
}


// if canThrowAnError() throws, the return value will e nil
let optionalResult = try? canThrowAnError(job: 1885, toPrinter: "Never Has Toner")

// if an error was thrown, crash the app
let optionalResult = try! canThrowAnError(job: 1885, toPrinter: "Never Has Toner")



// -------------------------------------------------------------------------------------------------
// escaping

class DeinitListener : EmptyListener {
    let deinitCallback: () -> Void
    init(callOnDeinit: @escaping () -> Void) {  // escaping lets you call things from inside the closure outside the closure
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
    subscript(index: Int) -> Int {      // you must specify return type
        return multiplier * index
    }
    subscript(aNonIntSubscriptParam: String) -> Void {
        return print("Hello from \(aNonIntSubscriptParam)")
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")   // Prints "six times three is 18"
threeTimesTable["Berlin"] // Prints "Hello from Berlin"



// -------------------------------------------------------------------------------------------------
// unsorted

