// -------------------------------------------------------------------------------------------------
// Imports

import Foundation

// -------------------------------------------------------------------------------------------------
// Types and aliases

var myVariable = 12;

let allFieldsOfConstantsCanBeSet = AMSDataTagBuilder.tag(identifier: .recent)
tag.useFrequency = 1

static let myStaticConstant = 42;

let stringConstant: String = "Hello"
let optionalStringConstant: String? = "World!"

let peopleDictionary = ["Anna": 67, "Julia": 8, "Hans": 33, "Peter": 25]
let otherPeopleDictionary: [String: Int] = ["Hanna": 64, "Jule": 7, "Franz": 32, "Dieter": 23]


typealias OpenChargerCompletion = ([AMSRouteChargingStation]) -> Void


// -------------------------------------------------------------------------------------------------
// Classes and functions

func foo( coordinates: coords, radius: Int) -> String {
    return "Joooooo";
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

/* Visibility
 *
 * open - publicly visible AND subclassable / overrrideable within own scope and any scope that imports the defining module
 * public - publicly visible and usable within own scope and any scope that imports the defining module
 * internal - visible within any source file of the defining module
 * private - visible only within the defining file
*/


// -------------------------------------------------------------------------------------------------
// Decisions

switch myEnumInstance {
case .mauz:
    // from the looks of it, I dont need no 'break' statement!
case .wau:
    // I also don't need to specify the whole EnumType.enumValue
    // but just the enumValue :)
case .yocat:
    // ...
default:
    // ...
}


// -------------------------------------------------------------------------------------------------
// Loops

for f in fruits{
    print("\(f) ", terminator: "")
}


for (name, age) in peopleDictionary {
    print("\(name) is \(age) years old.")
}


// -------------------------------------------------------------------------------------------------
// stuff

print("The value of myStaticConstant is \(myStaticConstant) and nothing else.")
print("The value of myStaticConstant + 1 is = \(myStaticConstant+1).")

// -------------------------------------------------------------------------------------------------
// Use underscores to omit variable names on method invocation


func myFunction(_ myParamName: MyParamType) -> String {
    // ...
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
// getters and setters

public protocol MyProtocol {
    var myAttribute: String { get set }
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