# --------------------------------------------------------------------------------------------------
# Directories, Scripts and Modules

Directories that contain CMakeLists.txt files are entry points for the build system generator.
            Subprojects s may be added with an add_subdirectory() and they must also contain
            CMakeLists.txt. Subprojects do not have to reside insid subfolders :)

Scripts are <script>.cmake files that can be executed with cmake -P <script>.cmake.
        Does not support all commands.

Modules are <script>.cmake files located in the CMAKE_MODULE_PATH. Modules can be loaded with the
        include() command.

CTest scripts are the right place for CI specific settings.
              Keep these out of the project.

# --------------------------------------------------------------------------------------------------
# True and false values in CMake
TRUE     true    1   !=0    "non-empty-string"                          ON
FALSE    false   0          ""                      "blah-NOTFOUND"     OFF

# --------------------------------------------------------------------------------------------------
# comments

# comments
foo(ARG_A "hallo"
    ARG_B "welt"
    MULTI_VAL_ARG "one"
    MULTI_VAL_ARG "two"            # you can
    MULTI_VAL_ARG "three"          # comment multi-line-function invocations like this
    MULTI_VAL_ARG "four;five;six"  # without problems
    MULTI_VAL_ARG seven eight)



# --------------------------------------------------------------------------------------------------
# Imagine Targets as Objects:
    Ctors:
        add_executable()
        add_library()
    Member Vars:
        Target properties
    Member Funs:
        get_target_property(VAR target property)
        get_target_property()
        set_target_properties()
        get_property(TARGET)
        set_property(TARGET)
        target_compile_definitions()
        target_compile_features()
        target_compile_options()
        target_include_directories()
        target_link_libraries()         # use this to express _direct_ dependencies
        target_sources()


# --------------------------------------------------------------------------------------------------

PRIVATE   Only used for this target.
PUBLIC    Used for this target and all targets that link against it.
INTERFACE Only used for targets that link against this library.

# --------------------------------------------------------------------------------------------------
# invocation and how CWDs are treated

cmake [<options>] <path>
    If the specified path contains a CMakeCache.txt, it is treated as a build directory where the
    build system is reconfigured and regenerated. If the specified path does not contain a
    CMakeCache.txt, the path is treated as the source diretory and the cwd is the build directory.

# --------------------------------------------------------------------------------------------------
# you can run things from command line
#/bin/bash

echo 'message("Hello ${NAME}!")' >> hello.cmake
cmake -DNAME=Andi -P hello.cmake

# --------------------------------------------------------------------------------------------------
# Some Cmake commands

cmake <source directory> -p                 # runs the script but don’t generate a pipeline.
cmake <source directory> -j<n>              # runs the build process on n threads in parallel, if possible.
cmake -DNumber 42                           # defines a variable from command line
cmake -G "Xcode"                            # Specify the desired Generator, i.e. Xcode :)
cmake -L -N .                               # View the cached variables
cmake -DCMAKE_BUILD_TYPE=Debug              # Debug, MinSizeRel, RelWithDebInfo and Release
cmake --build . --target CMakeDemo --config Debug
cmake -P                                    # process script mode... runs the script, configures / builds nothing
cmake -E                                    # command line mode
cmake -E help                               # for a summary of commands
cmake -E <remove_directory>                 # use instead of rm/rmdir (it's portable)
cmake --build <builddir>
cmake -Hmy-source-dir                                       # sets path to set directory with CMakeLists.txt.
cmake -Bmy-release-build-dir -DCMAKE_BUILD_TYPE=Release     # sets path of the build dir and the build type
cmake -H. -Bmy-build-with-feature-on -DFOO_FEATURE=ON       # sets path of the build dir with the activated feature
cmake -H. -Bmy-build-with-feature-off -DFOO_FEATURE=OFF     # sets path of the build dir with the disabled feature
cmake -H. -Bbuild-xcode -G xcode                            # sets path of the build dir with xcode generator
cmake -C <initial-cache-file>
cmake -Wno-dev                              # suppress warnings


cmake . --trace-expand 2>&1 | tee trace-output.txt
    --debug-output
    --trace
    --trace-expand


# --------------------------------------------------------------------------------------------------
# Probably the simplest CMake for a project is

cmake_minimum_required(VERSION 3.5)
project(MyProject)
add_executable(MyProject, main.cpp)         # adds a target

# --------------------------------------------------------------------------------------------------
# project stuff

project(myproject VERSION 0.1 LANGUAGES CXX)

# defines ${CMAKE_C_COMPILER} and ${CMAKE_CXX_COMPILER} and more.
# Place checks after calling project(MyProject)
# also defines  PROJECT_{SOURCE,BINARY}_DIR  and since 3.0  PROJECT_VERSION_{MAJOR,MINOR,PATCH,TWEAK}

# --------------------------------------------------------------------------------------------------
# add targets with

add_executable()
add_library()
add_library(lib src/lib.cpp src/frob.cpp)
add_custom_target()

# --------------------------------------------------------------------------------------------------
# add executable targets and alias them with a namespace


set( SOURCE_FILES scr/main.cpp

add_executable(tool
    main.cpp
    another_file.cpp
    )
add_executable(my::tool ALIAS tool)             # create a read-only alias my::tool

# --------------------------------------------------------------------------------------------------
# set commands

set(abc "123")
set(xyz "321" CACHE STRING "")
set(myvar "786" PARENT_SCOPE)  # changes myvar in parent scope but not in current scope
unset(myvar)  # has no effect on cache vars
unset(X CACHE)

# --------------------------------------------------------------------------------------------------
# get and set properties for targets

get_property()
set_property()

get_property(MYAPP_SOURCES TARGET MyApp PROPERTY SOURCES)    # Get the target's SOURCES property and assign it to MYAPP_SOURCES


# Target Properties include
    # LINK_LIBRARIES
    # INCLUDE_DIRECTORIES
    # TARGET_INCLUDE_DIRECTORIES
    # TARGET_COMPILE_DEFINITIONS

# --------------------------------------------------------------------------------------------------
# A self-explanatory CMakeLists.txt Example

# Set the Minimum CMake version required
cmake_minimum_required(VERSION 2.9)

# Project Name
project(MyProject)

# Project Version
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH} )

set(CMAKE_BUILD_TYPE Release)

# Detect Host Processor
message(STATUS "The host processor is ${CMAKE_HOST_SYSTEM_PROCESSOR}")

# Detect Operating System
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    add_definitions(-DSYSTEM_LINUX)
endif()

# Header files location
include_directories(include)

set(SOURCES
    "src/main.cpp"
    "src/other.cpp")

add_library(MyStaticLib STATIC ${STATICLIB_SOURCES})
add_library(MySharedLib SHARED ${SHAREDLIB_SOURCES})

# Build Executable
add_executable(MyApp ${SOURCES})
target_link_libraries(MyApp libMyStaticLib)
target_link_libraries(MyApp libMySharedLib)


# --------------------------------------------------------------------------------------------------
# Exepmplaric CMake function in a file

if(DEFINED includeguard_MyIncludeGuardNamedExactlyLikeTheFile)
  return()
endif()
set(includeguard_MyIncludeGuardNamedExactlyLikeTheFile ON)

cmake_minimum_required(VERSION 3.5)

#.rst:
# ExactlyTheFileName
# ------------------
#
# This module does ...
# A paragraph containing information about this module and what it does
# and what it depends on :)
#
# .. command:: my_function_name
#
# The general form of the command is::
#
#     my_function_name(my_arguments)
#


function(my_function_name my_arguments)
    # YOUR FUNCTION CODE GOES HERE
endfunction(my_function_name)

# --------------------------------------------------------------------------------------------------
# Messages

message("A normal message")
message(STATUS "A status message, possibly just a normal message")
message(FATAL_ERROR "An error occured! FATAL_ERROR also aborts the configure process.")

here_message(SEND_ERROR "Linker doesn't support neither '--whole-archive' nor '-force_load'")


# --------------------------------------------------------------------------------------------------
# includes & subdirectories

include(MyCMakeFile.cmake)
include(Boost.cmake)

# it seems, you have to specify the file ending, e.g. cmake. I think, HERE macros somehow avoid that

add_subdirectory ( <source subdirectory> )  # creates a new scope and executes the CMakeLists.txt from the subdirectory.
include_directories ( <directoryName> )
link_directories ( <directoryName> )
target_link_libraries( <target> PRIVATE "lib1.a lib2.a")

target_link_libraries(lib boost MyOtherLibrary)  # Depend on a library that we defined in the top-level file

add_executable (MyBinary, MyBinary.cpp)                 # Creates binary named MyBinary
add_library (MySharedLib, SHARED, SharedLibCode.cpp)    # Creates Shared library named MySharedLib.so
add_library (MyStaticLib, STATIC, SharedLibCode.cpp)    # Creates Shared library named MyStaticLib.a

# --------------------------------------------------------------------------------------------------
# CUSTOM TARGETS

add_custom_target(deploy)                                       # will always be built / no output
add_custom_command(TARGET "deploy" POST_BUILD <some command>)   # will be invoked before building deploying


# --------------------------------------------------------------------------------------------------
# Cache Variables

set(a "789" CACHE STRING "")  # sets cache variable a to 789 but deletes original var a
set(A "123" CACHE STRING "" FORCE)  # set cache var although it is already in the cache

CMake cache vars have no scope and are set globally
If variable is not found in the current scope, it will be taken from the cache
Cache Variables will only be set when they are not already in the cache
Do not give same names for cache and regular variables
FORCE usually is an indicator of badly designed CMake code.
Because of the global nature of cache variables  you should prefix them with the project name


# --------------------------------------------------------------------------------------------------
# Set cache variable type -- mostly a hint for the Generator GUI

set(FOO_A "YES" CACHE BOOL "Variable A")
set(FOO_B "boo/info.txt" CACHE FILEPATH "Variable B")
set(FOO_C "boo/" CACHE PATH "Variable C")
set(FOO_D "abc" CACHE STRING "Variable D")

set(FOO_B "456" CACHE INTERNAL "")  # Internal will not be shown in the CMake GUI


# --------------------------------------------------------------------------------------------------
# IF-ELSEIF-ELSE
# if and while both don't need to enclose variables into ${} ... they should also not enclose them

if(${GENERATOR} STREQUAL cpp)
    # ...
elseif(${GENERATOR} MATCHES android)
    # ...
    if(NOT(${ANOTHER_VAR} STREQUAL "in_quotation_marks!"))
      # ...
    endif()
elseif(${GENERATOR} MATCHES swift)
    # ...
else()
    # ...
endif()


# nested ifs are possible
if( "one" STREQUAL "one" )
    if( "two" STREQUAL "two")
        message("second level if")
    endif()
    message("first level if")
endif()

# --------------------------------------------------------------------------------------------------
# Lists

# Lists are nothing but string, elements of lists are separated by semicolons ';'

set(l0 a b c)
set(l1 a;b;c)
set(l2 "a b" "c")
set(l3 "a;b;c")
set(l4 a "b;c")

list(LENGTH mylist mylist_len)
list(GET mylist 2 element_at_second_position)  # 0-indexed

if( "a" IN_LIST l0)
    message("a is in!")
endif()
if( "A" IN_LIST l0)
    message("a is in!")  # should not be
endif()


# --------------------------------------------------------------------------------------------------
# foreach

foreach(input ${apigen_transpile_FRANCA_SOURCES})
    string(CONCAT APIGEN_TRANSPILER_ARGS ${APIGEN_TRANSPILER_ARGS} " -input ${input}" )
endforeach()


foreach(gerrit_change_id IN LISTS gerrit_change_ids)
    # ...
endforeach()


foreach(x RANGE 10)
foreach(x RANGE 3 8)
foreach(x RANGE 10 14 2) # start stop step


# exit loops early
if(done)
    break()
else()
    continue()
endif()


# --------------------------------------------------------------------------------------------------
# while
# if and while both don't need to enclose variables into ${}

while(num LESS 42)
    message("Number is still less than 42.")
endwhile()


# --------------------------------------------------------------------------------------------------
# (SEEMINGLY) Builtin CMAKE functions       //      MICROSNIPPETS

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${apigen_transpile_FRANCA_SOURCES})

set_target_properties(${target} PROPERTIES
            APIGEN_JAVA_JAR ${APIGEN_JAVA_JAR})
get_target_property(MY_NEW_VAR ${target} VAR_AS_NAMED_INSIDE_THE_GIVEN_TARGET)

# globbing for sources is discouraged but works like this:
file(GLOB SOURCES "src/*.cpp")
file(GLOB SHAREDLIB_SOURCES "src_sharedlib/*.cpp")
file(GLOB STATICLIB_SOURCES "src_staticlib/*.cpp")

file(GLOB_RECURSE GENERATED_CPP_SOURCES ${OUTPUT_DIR}/cpp/*.cpp)
source_group("Generated BaseApi\\Source Files" FILES ${GENERATED_CPP_SOURCES})

target_include_directories(${target}
    PRIVATE $<BUILD_INTERFACE:${OUTPUT_DIR}/cpp>
    PRIVATE $<BUILD_INTERFACE:${OUTPUT_DIR}>)

target_sources(${target}
    PRIVATE
        ${GENERATED_CPP_SOURCES}
        ${GENERATED_CPP_HEADERS})

find_package(Java COMPONENTS Development REQUIRED)


set(options VALIDATE_ONLY)                      # these options are available
set(oneValueArgs TARGET GENERATOR VERSION)      # these oneValueArgs are available
set(multiValueArgs FRANCA_SOURCES)              # these multi value args are available
cmake_parse_arguments(apigen_transpile "${options}" "${oneValueArgs}"
                                       "${multiValueArgs}" ${ARGN})

# use later like:
if(${apigen_transpile_VALIDATE_ONLY})
    # ...
endif()



message(STATUS "${operationVerb} '${apigen_transpile_TARGET}' with '${apigen_transpile_GENERATOR}' the rest is my message ... ")

execute_process(COMMAND echo "Hello World!")
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${directory})

execute_process(
    COMMAND ${CMAKE_COMMAND} -E make_directory ${TRANSPILER_OUTPUT_DIR} # otherwise java.io.File won't have permissions to create files at configure time
    COMMAND ${APIGEN_TRANSPILER_GRADLE_WRAPPER} -Pversion=${apigen_transpile_VERSION} run -Dexec.args=${APIGEN_TRANSPILER_ARGS}
    WORKING_DIRECTORY ${APIGEN_TRANSPILER_DIR}
    RESULT_VARIABLE TRANSPILE_RESULT)

add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} ARGS -E make_directory ${APIGEN_JAVA_COMPILE_OUTPUT_DIR}
            COMMAND find ${APIGEN_TRANSPILER_JAVA_SOURCE_DIR} -name *.java | xargs "${Java_JAVAC_EXECUTABLE}" ${CMAKE_JAVA_COMPILE_FLAGS} -d ${APIGEN_JAVA_COMPILE_OUTPUT_DIR}
            COMMENT "Compiling generated Java sources into class files...")


# --------------------------------------------------------------------------------------------------
# Semantic versioning ( found here: http://pusling.com/blog/?p=352)

set(BAR_VERSION_MAJOR 1)
set(BAR_VERSION_MINOR 2)
set(BAR_VERSION_PATCH 3)
set(BAR_VERSION ${BAR_VERSION_MAJOR}.${BAR_VERSION_MINOR}.${BAR_VERSION_PATCH} )


set_target_properties(bar PROPERTIES VERSION ${BAR_VERSION}
                                     SOVERSION ${BAR_VERSION_MAJOR} )


# --------------------------------------------------------------------------------------------------
# Check for variable existence

if (DEFINED myvar)
    #  ...
endif()

# --------------------------------------------------------------------------------------------------
# Check for a file's existence

if(NOT EXISTS "${SDK_ROOT}/platforms/${ANDROID_PLATFORM}/android.jar")
    message(FATAL_ERROR "The file '${SDK_ROOT}/platforms/${ANDROID_PLATFORM}/android.jar' does not exist.")
  endif()

# --------------------------------------------------------------------------------------------------
# You can simulate a data structure using prefixes

set(JOHN_NAME "John Smith")
set(JOHN_ADDRESS "123 Fake St")
set(PERSON "JOHN")
message("${${PERSON}_NAME} lives at ${${PERSON}_ADDRESS}.")

set(${PERSON}_NAME "John Goodman")
message("${JOHN_NAME} is John Goodman, iff PERSON was John :)")

# --------------------------------------------------------------------------------------------------
# Distinguish between host systems

if(WIN32)
    # windows
elseif(TODO)
    # TODO
endif()

# --------------------------------------------------------------------------------------------------
# Invoke CMake commands or any other command

cmake -E <remove_directory>                 # use instead of rm/rmdir (it's portable)



# use within cmake script like this:
execute_process(
    COMMAND "${CMAKE_COMMAND}" -E remove_directory "${CMAKE_CURRENT_BINARY_DIR}/__temp"
    RESULT_VARIABLE result
)

# --------------------------------------------------------------------------------------------------
# mathematical statements

math(EXPR MY_SUM "1 + 1")

# --------------------------------------------------------------------------------------------------
# output return function values to parent scope with PARENT_SCOPE

## CAUTION: argument variable names must differ from parameter names.

function(doubleIt VARNAME VALUE)  # the parameter name must not match the argument's name Oo
    math(EXPR RESULT "${VALUE} * 2")
    set(${VARNAME} "${RESULT}" PARENT_SCOPE)    # Set the named variable in caller's scope
endfunction()

doubleIt(RESULT "4")                    # Tell the function to set the variable named RESULT
message("${RESULT}")                    # Prints: 8

# --------------------------------------------------------------------------------------------------
# Macros

macro(myMacro PARAM1 PARAM2)
    // ...
endmacro()

# --------------------------------------------------------------------------------------------------
# The special ARGN variable for a list of unnamed fuction arguments

function(doubleEach)
    foreach(ARG ${ARGN})                # Iterate over each argument
        math(EXPR N "${ARG} * 2")       # Double ARG's numeric value; store result in N
        message("${N}")                 # Print N
    endforeach()
endfunction()

doubleEach(5 6 7 8)                     # Prints 10, 12, 14, 16 on separate lines


# --------------------------------------------------------------------------------------------------
# useful notes

# lists are just semicolon delimited strings

# if the entire argument is a variable reference without quotes,
# and the variable's value contains semicolons, CMake will split the value at the semicolons
# and pass multiple arguments to the enclosing command., for example
    set(ARGS "EXPR;T;1 + 1")
    math(${ARGS})                                   # Equivalent to calling math(EXPR T "1 + 1")

# if you have to use sed or other shell tricks, put them into a separate shell script
# and invoke this, instead calling sed directly. this improves documentability and testability

# project(<name> VERSION <version> LANGUAGES CXX)
#     call to project() must be direct, not through a function/macro/include. CMake will automatically
#     add a call to project() if not found on the top level.


All projects should be build both as standalone and as subprojects of another project.
Don't modify globile compile/link flags.
Don't make any global changes!
Always add namespaced aliases for libraries.
Don't make libraries STATIC/SHARED unless they cannot be built otherwise.
Leave control of BUILD_SHARED_LIBS to your clients.
Prefer to link against namespaced targets.
Avoid adding options/definitions to CMAKE_CXX_FLAGS
Don't add -std=c++11 CMAKE_CXX_FLAGS, don't pass -std=c++11 to target_compile_options()
-DCMAKE_CXX_FLAGS="-I/path/to/an/additional/include/dir/"
Goal: no custom variables
Goal: no custom functions
Explicit is better than implicit
Create macros to wrap commands that have output parameters. Otherwise, create a function
Variables are so CMake 2.8.12. Modern CMake is about Targets and Properties.
INTERFACE_ properties define the usage requirements of a target.
non INTERFACE_ properties define the build specification of a target
System packages work out of the box.
Prebuilt libraries need to be put into CMAKE_PREFIX_PATH.
Toolchain.cmake is a thing for ... TODO Oo
Don't put logic into toolchain files.
CMAKE_USE_RELATIVE_PATHS  removed since CMake 3.4
Policies can be used to control CMake behavior
Policies can be used to suppress warnings/errors
Nested dereferencing of variables ${...} is possible
Use short laconic lower-case names (a, i, mylist, ...) for local vars used only by current scope.
Use long detailed upper-case names (FOO_FEATURE, BOO_ENABLE_SOMETHING, etc.) for vars used by several scopes.
TRUE FALSE      YES NO      ON OFF
check for features - not platforms

# Avoid:
# link_libraries()
# link_directories()
# add_dependencies()
# include_directories()
# add_definitions()            # it's simply old :)
# add_compile_options()

# Scripting commands change state of command processor
#                    set variables
#                    change behavior of other commands

# Project commands create or modify build targets

# Generator expressions use the $<> syntax. Not evaluated by command interpreter.
#                       Evaluated during system generation.

# If your workflow doesn’t match configure-once approach then it may be a symptom of
# wrongly written CMake code. Especially when you have to run cmake -H. -B_builds twice or when
# cmake --build _builds doesn’t catch updates from CMake code.


# For backward compatibility new features can be protected with if(CMAKE_VERSION ...) directive


# append CMake module path to append own modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/modules")
include(MyModule)


# provide an option that the user can optionally select
option( <option_variable> "help string describing option" [initial value] )


## options - once set - are fix
option( MyOption "my info string" ON )
option( MyOption "my info string" OFF )
# *** option will still be ON here ***
set( MyOption OFF )
# *** now option is off ***


# --------------------------------------------------------------------------------------------------
# Typcial CMAKE Variables

CMAKE_CURRENT_SOURCE_DIR      will hold full path to currently processed node.
CMAKE_SOURCE_DIR              always carries root of the tree (see -H)

CMAKE_SOURCE_DIR
CMAKE_BINARY_DIR
${PROJECT_SOURCE_DIR}  # file where the CMakeLists.txt lies in, the project's root
PROJECT_BINARY_DIR
CMAKE_CURRENT_SOURCE_DIR
${CMAKE_CURRENT_BINARY_DIR}

CMAKE_CURRENT_LIST_FILE
CMAKE_CURRENT_LIST_LINE
CMAKE_CURRENT_LIST_DIR  #  always points to the directory path of the CMakeLists file / or the .cmake file (the latter is a guess with one indication)
CMAKE_PARENT_LIST_FILE

# recommendatiom from CGold: just remember the following variables:
# (https://cgold.readthedocs.io/en/latest/tutorials/cmake-sources/includes.html#id3)
CMAKE_CURRENT_LIST_DIR
CMAKE_CURRENT_BINARY_DIR

${CMAKE_COMMAND}

${Java_JAVAC_EXECUTABLE}                # maybe this one comes by using the     find_package(Java COMPONENTS Development REQUIRED)
${Java_JAR_EXECUTABLE}

${CMAKE_ANDROID_ARCH_ABI}  # comes with the Android Toolchain, I believe


$<TARGET_FILE_NAME:${target}>


# --------------------------------------------------------------------------------------------------
# Deprecate CMake commands

macro(my_command)
    message(DEPRECATION
        "The my_command command is deprecated!")
    _my_command(${ARGV})
endmacro()

# --------------------------------------------------------------------------------------------------
# Deprecate CMake variables

set(hello "hello world!")

function(__deprecated_var var access)
    if(access STREQUAL "READ_ACCESS")
        message(DEPRECATION
            "The variable '${var}' is deprecated!")
    endif()
endfunction()

variable_watch(hello __deprecated_var) # calls __deprecated_var with hello each time hello used :o

# --------------------------------------------------------------------------------------------------
# set policies to deactivate warnings or errors

if(POLICY CMP0038) # if CMP0038 is unknown to your CMake version
    cmake_policy(SET CMP0038 OLD)    # requests the old backwards compatible solution for cmake policy CMP0038
endif()

# --------------------------------------------------------------------------------------------------
# define and run tests with CTest

# Define test like this
add_test(NAME Foo.Test
    COMMAND foo_test --number 0
    )

#Run like this:
ctest -R 'Foo.' -j4 --output-on-failure


# --------------------------------------------------------------------------------------------------
# HERE specific CMake commands (excerpt)
# look here:    https://mos.cci.in.here.com/job/here-cmake-tests-trigger/HTML_Report/


#  ideally, use cmake 3.5
#  include path best practices: include/here/blubb

here.MYPROJECT for projects     # dot-delimeter for projects
here::MYTARGET for targets      # colon-colon delimeter for targets

here_project(MYPROJECT VERSION 0.0.01)

here_find_package(zlib REQUIRED)
here_add_library(my-project)
here_add_library(pugixml ${PUGIXML_SOURCES} ${PUGIXML_HEADERS})
here_target_sources(pugixml PRIVATE ${PUGIXML_SOURCES} PRIVATE ${PUGIXML_HEADERS})
here_add_executable(my-project)
here_target_link_libraries(my-project PRIVATE my-foundation-project)
here_install(INCLUDES)
here_install(INCLUDES DIRECTORIES ${CMAKE_CURRENT_LIST_DIR}/src)   # for headers are not in the include/ dir
here_install(LIBRARIES my-project)
here_install(EXECUTABLES my-project)

here_finalize_exports() # put this to the bottom of your CMakeLists.txt, likely :)
here_finalize_exports(NO_NAMESPACE) # for external libraries that don't have no namespace


add_library(here::traffic_client INTERFACE IMPORTED)            # i noted that down from the slides
here_add_library(here::traffic_client INTERFACE IMPORTED)       # but maybe this is more correct...


cmake -DHERE_DEBUG_CMAKE=ON  # more verbose output
cmake -DCMAKE_INSTALL_COMPONENT


# dealing with options
here_declare_option
here_use_option
here_set_option


# check for features - not platforms
include(CheckCXXSourceCompiles)
check_cxx_source_compiles("
  int main() {
  #if !defined(__EXCEPTIONS)
  #error Exceptions not supported.
  #endif
  }" exceptions_supported)


# --------------------------------------------------------------------------------------------------
# Further

enable_testing()
add_test(mytestname mytestprogramtarget)

# If we have compiler requirements for this library, list them here
target_compile_features(lib
    PUBLIC cxx_auto_type
    PRIVATE cxx_variadic_templates)

if(CMAKE_COMPIER_IS_GNUCXX)
    target_compile_options(foo
        PUBLIC -fno-elide-constructors
        )
endif()


# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS lib EXPORT MyLibraryConfig
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})



include(ProcessorCount)
ProcessorCount(N)


file(REMOVE_RECURSE ...)

string(COMPARE EQUAL "${A}" "" my_is_empty_out_var)


find_program(ANT ant CMAKE_FIND_ROOT_PATH_BOTH)


# --------------------------------------------------------------------------------------------------
# das geht

get_filename_component(source ${source} ABSOLUTE)       # makes (relative paths absolute)


set(ENV{USERNAME} "Andi L")
$ENV{USERNAME}  # read environment variable USERNAME

#important:
if(DEFINED ENV{USERNAME})  # the DEFINED is important, would not work w/out


# --------------------------------------------------------------------------------------------------
# exorting stuff

export(EXPORT migrantTargets
       FILE "${CMAKE_CURRENT_BINARY_DIR}/MigrantTargets.cmake"
       NAMESPACE here::migrant::)


# --------------------------------------------------------------------------------------------------
# configuring .in files

# use in conjunction
configure_file(src/pugiconfig.hpp.in src/pugiconfig.hpp @ONLY)

# inside pugiconfig.hpp.in
#cmakedefine PUGIXML_NO_EXCEPTIONS

# the configured file pugiconfig.hpp could then be found inside the
# ${CMAKE_CURRENT_BINARY_DIR}/src/pugiconfig.hpp


# --------------------------------------------------------------------------------------------------
# variable watch prints notifications when a variable has changed

variable_watch(MYVAR)

# ...
set(MYVAR "foo")  # triggers a notification since variable_watch is activated.


# --------------------------------------------------------------------------------------------------
# UNSORTED STUFF

add_definitions(-DBOO_USE_SHORT_INT)                          # This is wrong! -- doesn't bubble to the target
target_compile_definitions(boo PUBLIC "BOO_USE_SHORT_INT")    # bubbles to the target



execute_process(COMMAND ssh -p 29418 "${GERRIT_USER}@${GERRIT_SERVER}"
                        gerrit query "${QUERY_STRING}"

add_custom_command()        # run a command at build time
add_custom_target()         # run a command at build time
