
# NO
    if(foo)
    #  ...
    else(foo)
    #  ...
    endif(foo)

# YES
    if(foo)
    #  ...
    else()
    # ...
    endif()

# --------------------------------------------------------------------------------------------------
# name functions with lowercase

#NO
    function(QI_MY_WONDERFUL_FUNCTION)
    #  ...
    endfunction()

#YES
    function(qi_my_nice_function)
    #  ...
    endfunction()

# --------------------------------------------------------------------------------------------------
# Keep long multiline strings together

# NO
message(STATUS  "This is a very long\n"
              "message on\n"
              "several lines\n"
)

# YES
message(STATUS "This is a very long
  message spanning on
  several lines
")

# --------------------------------------------------------------------------------------------------
# Always quote variable that represent a string:
# (and consequently, always quote string when comparing string in an if)

set(myvar "foo")
if ("${myvar}" STREQUAL "bar")
# ...
endif()

# --------------------------------------------------------------------------------------------------
# Do not quote variable that are booleans

set(mybvar ON)
set(mybvar OFF)
if (myvar)
# ...
endif()

# Note that this will NOT produce the
# expected result:
if(${myvar}) # bug!

endif()

# --------------------------------------------------------------------------------------------------
# When storing paths in variables, do NOT have the CMake variables end up with a slash:

# YES:
set(_my_path "path/to/foo")
set(_my_other_path "${_my_path}/${_my_var}")

# NO:
set(my_path "path/to/foo/")
set(_my_other_path "${_my_path}${_my_var}")   # wrong: this is ugly
set(_my_other_path "${_my_path}/${_my_var}")  # this is a bug!, see below


# --------------------------------------------------------------------------------------------------
# Do not quote variables that CMake expects to be a list:

set(_foo_args "--foo" "--bar")

# YES:
execute_process(COMMAND foo ${_foo_args})

# NO:
execute_process(COMMAND foo "${_foo_args}")


# --------------------------------------------------------------------------------------------------
# do not set the CMAKE_CXX_FLAGS manually

# This will break cross-compilation
set(CMAKE_CXX_FLAGS "-DFOO=42")

# use:
add_definitions("-DFOO=42")

# or, better, set the compile flags
# only when necessary:
# (this will save compile time when you change the define!)
set_source_files_properties(
  src/foo.cpp
    PROPERTIES
      COMPILE_DEFINITIONS FOO=42
)

# --------------------------------------------------------------------------------------------------
# Do not set CMAKE_FIND_ROOT_PATH

# This will break finding packages in the toolchain:

# don't
set(CMAKE_FIND_ROOT_PATH "/path/to/something")

# Use this instead:
# (create an empty list if CMAKE_FIND_ROOT_PATH does not exist)
if(NOT CMAKE_FIND_ROOT_PATH)
  set(CMAKE_FIND_ROOT_PATH)
endif()
list(APPEND CMAKE_FIND_ROOT_PATH "/path/to/something")

# --------------------------------------------------------------------------------------------------
# Do not set the CMAKE_MODULE_PATH

#  presumably, include (...) will no longer work

# don't
set (CMAKE_MODULE_PATH "/path/to/something")

# Use this instead:
# (create an empty list if CMAKE_FIND_ROOT_PATH does not exist)
if(NOT CMAKE_MODULE_PATH)
  set(CMAKE_MODULE_PATH)
endif()
list(APPEND CMAKE_MODULE_PATH "/path/to/something")
