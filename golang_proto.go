// author: andreasl

// -------------------------------------------------------------------------------------------------
// Strings

// Raw string literals use backticks and do not interpret escapes.
myRawString := `I don't need to escape "quotation marks" or backslashes \.`

myMultiLineString := `I am a
	very long
	multiline string`

// Interpreted string literals use double quotes and support escapes.
myEscapedString := "line 1\nline 2\t(tab)"

// -------------------------------------------------------------------------------------------------
// Variable Declarations

// Short declaration inside functions.
count := 42

// Explicit type declaration.
var mystring string = "Go"

// Let the compiler infer the type.
var enabled = true
