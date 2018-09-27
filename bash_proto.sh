# author: andreasl


# --------------------------------------------------------------------------------------------------
# set -e and +e
# see https://www.quora.com/What-is-the-difference-between-set-+e-and-set-e-in-a-bash-script

set -e      # the script immediately exits on error
set +e      # any errors that occur down the line will NOT cause the script to exit, the script will keep running

set -x      # print every command to the output -- you can use it as bash's debug mode; comments are not printed
set +x      # disable print every command to the output

set -o pipefail     # bail out when a command at one pipe returns with a non-zero status
    # example:
    notexistingcommand | echo "a" # dies after echo "a". Otherwise, it would not die

set -u      # treat unset variables as an error and exit immediately upon their usage



# --------------------------------------------------------------------------------------------------
# output into stream

echo "Output into nothing / silence the output" >/dev/null
echo "Append output stream to file and error stream to same as output stream" >myfile.txt 2>&1

echo "exclamation marks at the end with double quotes do NOT work!"  # doesn't work
echo 'exclamation marks at the end with single quotes DO work!'  # works
echo exclamation marks at the end without quotes DO work!  # works

>&2 echo "This outputs to the stderr error stream."
(>&2 echo "error")  # To avoid interaction with other redirections use subshell

# --------------------------------------------------------------------------------------------------
# source files / sourcing files

. "path/to/file/to/be/sourced.inc"
. works/also/but/better/to/quote/when/whitespaces/can/occur

# --------------------------------------------------------------------------------------------------
# the no-op

: # noop as in

for i in A B C ; do
    :                   # empty loop is not possible without noop, syntax error
done

# --------------------------------------------------------------------------------------------------
# apostrophes and quotation marks

printf "stuff inside double quotation marks expands, e.g. ${variables}, $variables, special\nchars like \\ and \ "
printf 'stuff inside single quotation marks does not expand, at least not ${variables}, $variables, but special\nchars like \\ and \ '
echo -e stuff without quotation resolves into several arguments which expand, at least not ${variables}, $variables, but special\nchars like \\ and \

# --------------------------------------------------------------------------------------------------
# Variables

export GLOBAL_VARIABLE='HELLO'
local_variable=World


my_array=("a" "b" "c")
my_array=("a", "b", "c")
my_array+=('d')             # adds a new element
echo ${my_array}            # prints a
echo ${my_array[1]}         # prints b
echo ${my_array[2]}         # prints c
echo ${my_array[11000]}     # prints nothing
echo -e "-e flag enables echo to process escape sequences, like \n, or \t. Works with single and double quotes"
printf '%s\n' "${my_array[@]}"         # @ returns all values as sep string (here in a new line each)
printf '%s\n' "${my_array[*]}"         # * returns all values as one string (here in the same line each)

echo ${#my_array[@]}        # prints 3, i.e. the length of the array

for i in ${my_array[@]} ; do
    echo "jo $i"
done

printf '%s\n' "${my_array[@]}"    # print an array with newline delimiting each entry


declare -a my_explicit_array=()             # explicitly declare an array variable
typeset -a my_other_explicit_array=()       # declare and typeset are exact synonyms

my_long_var="blakeks"
my_short_var=${my_long_var#bla}  # cuts the first part of the given var, i.e. "bla", leaving just "keks"
echo ${my_short_var}

readonly var=32
#var=128  # does not work



echo "$_"    # prints "echo" ; $_ is the invoking command
printf "$_"  # prints "printf"

# --------------------------------------------------------------------------------------------------
# for loops

for value in 0 1 3 ; do
    echo $value  # prints 0 1 and 3
done

for value in {1..5} ; do
    echo $value  # prints 1 2 3 4 5
done

for value in $(seq 1 5) ; do
    echo $value # prints 1 2 3 4 5
done

my_array=("one" "two" "three")
for value in "${my_array[@]}" ; do
    echo $value
done

# --------------------------------------------------------------------------------------------------
# until loops

retry=0
maxretry=3
until [ $retry -ge $maxretry ]
do
    docker pull $BUILD_DOCKER_IMAGE && break
    sleep 10
    retry=$[$retry+1]
done


# --------------------------------------------------------------------------------------------------
# if-then-else

# in if clauses, = and == are equivalent

# = is for strings
if [ "$expressions" = 'should_be_evaluated_either_by_test_or_wrapped_into_square_brackets' ]; then
    # ...
fi

# -eq should be used for numbers, also  -ne, -gt -ge, -lt, -le
if [ 1 -eq 1 ] ; then
    echo "WELT";
fi

if commands_should_not_go_into_square_brackets ; then
    # ...
fi

# == and != should be used for strings
if [ "$foo" == "staging" ]  || [ "$foo" == "stage" ]; then
    echo "OR concatenation ||"
elif [ "$foo" == "Andreas" ]  && [ "$bar" == "Langenhagen" ]; then
    echo "AND concatenation &&"
else
    echo "else case"
fi



if [[ "Does this string contain a substring?" == *"contain a"* ]] ; then
    # note the [[ ... ]], if it is [ ... ], it's the other way round.
    # Works also with "Does" and "ubstring?", i.e. at the edges.
    # is case specific.
    echo 'Substring found!'
fi

if [[ "Also check for regular expressions is possible with equalstilde" =~ r.*r ]] ; then
    echo "Regex found!"
fi

# --------------------------------------------------------------------------------------------------
# switch case :)

case "$status_code" in
    "200")
        return 0
        ;;              ## ;; is how end a case clause :)
    "404"|"666")
        return 1
        ;;
    *)
        die "Url $transpiler_url returned status code $status_code"
        ;;
esac

# --------------------------------------------------------------------------------------------------
# inline command code execution
myvar=$(pwd)
myvar=`pwd`

echo "$(pwd)"  # some people prefer this over backticks
echo "`pwd`"


# --------------------------------------------------------------------------------------------------
# have a die function :)

function die {
    echo -e "$@"
    exit 1
}

[ -n "$version" ] || die "Version string must not be empty"    # use like this, for example :)


# --------------------------------------------------------------------------------------------------
# traps
# code that will be executed on certain signals

function finish {
  # cleanup code goes here
}
trap finish EXIT  # calls finish on exit

trap "read -n1 -p 'Press any key to exit' -s ; echo" EXIT


# --------------------------------------------------------------------------------------------------
# use $0 or better ${BASH_SOURCE[0]} to refer to the script's name

# ${BASH_SOURCE[0]} is not sh compatible
# but there was an advantage for ${BASH_SOURCE[0]} which I don't recall currently :)
echo "[$0] vs. [${BASH_SOURCE[0]}]"

if [ $# != 1 ] ; then
    printf "Usage:\n\t$0 <BUILD-PATH>\n\nExample:\n\t$0 path/to/build/folder\n\n"
    exit 1
fi


# --------------------------------------------------------------------------------------------------
# Use cat to create a file

cat > "path/to/my-file.txt" << MYFILE_EOF
This is the input of the file
It can span
several lines.
MYFILE_EOF


# --------------------------------------------------------------------------------------------------
# Use local variables within functions
# functions seem to work with /bin/bash but not with /bin/sh

function myFunction {
    local my_var=42  # local var does not leak outside function scope
    return $my_var
}


echo "Script file name: " $0
echo "Script's first parameter: " $1

function myFunction2 {
    echo "USAGE"
    echo "Script's file name: " $0
    echo "myFunction2's first param" $1  # != $1 of the script
}
myFunction2 "The first param given to the function"


# --------------------------------------------------------------------------------------------------
# Check if current computer is a Mac

if [ "$(uname)" == "Darwin" ] ; then
    echo "we're on Mac"
elif [ `uname` == "Linux" ] ; then
    echo "we're on a Linux"
fi

# if echo $HOME | grep -q "/Users/" ; then  # it's most probably a mac


# --------------------------------------------------------------------------------------------------
# Check if given path points to a file, directory or a symlink
# Symlinks can also be files or directories.


if [ -f "<path>" ]; then
    echo "Is a file"
fi

if [ -d "<path>" ]; then
    echo "Is a directory"
fi

if [ -L "<path>" ]; then
    echo "Is a symlink"
fi


# --------------------------------------------------------------------------------------------------
# additionals

printf "The value of param #1 is $1\n"

echo This '$(pwd)': $(pwd) equals '${PWD}': ${PWD} but not '${pwd}: ' ${pwd} stays empty


script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)  # directory of the given script
script_path=${BASH_SOURCE[0]}  # path to the script from where you are, I believe

# --------------------------------------------------------------------------------------------------
# command line parsing -- stupenduously simple -- it's so simple, don't do it :)


if [ "$1" == "" ] ; then
    echo "my cmd arg not provided"
    exit 1
elif [ "$1" == "Hello" ] ; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else :)"
fi


# --------------------------------------------------------------------------------------------------
# command line parsing -- very simple

my_cmd_arg=$1
if [ "$my_cmd_arg" == "" ] ; then
    echo "my cmd arg not provided"
elif [ "$my_cmd_arg" == "Hello" ] ; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else :)"
fi


# --------------------------------------------------------------------------------------------------
# command line parsing -- simple and complete, I guess :) -- I believe this is the best way

logfile="default.log"
send_alive_pushover=false
while [ $# -gt 0 ] ; do
    key="$1"
    case $key in
    -a|--alive)
        send_alive_pushover=true
        ;;
    -f|--file)
        logfile="$2"
        shift # past argument
        ;;
    -y|--yesterday)
        logfile="yesterday.log"
        ;;
    -h|--help)
        show_usage
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

# --------------------------------------------------------------------------------------------------
# command line parsing -- Getopt

SHORT=p:b:a:
LONG=product:,build_type:,arch:
if [[ $# -lt 2 ]]; then
   usage "Incorrect number of parameters"
fi
PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
eval set -- "$PARSED"

while true; do
    case "$1" in
        -p|--product)
            PRODUCT="$2"
            shift 2
            ;;
        -b|--build_type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE="$2"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            usage "Unknown parameter: $@"
            ;;
    esac
done


# --------------------------------------------------------------------------------------------------
# command line parsing -- Getopts

# CAUTION: getopts, unlike getopt, can just understand short names like -p but not long name, e.g. --page
# CAUTION: IF you are using getopt, Mac OS X's getopt is not the gnu-getopt, but the bsd-getopt and behaves differently

while getopts ":s:p:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "s = ${s}"
echo "p = ${p}"

# --------------------------------------------------------------------------------------------------
# test -- aka [ ]

[ "hallo" ]; echo $?        # prints 0
[ "" ]; echo $?             # prints 1
[[ $# -gt 0 ]] ; echo $#    # "new test" or "extended test" - less portable, but but more versatile, e.g. it can test whether a string matches a regular expression


# --------------------------------------------------------------------------------------------------
# Coloring and printing

CYAN='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function echo-error {
    printf "${RED}${@}${NC}\n"
}

function echo-head {
    printf "${CYAN}${@}${NC}\n"
}

function echo-ok {
    printf "${GREEN}${@}${NC}\n"
}

function echo-warn {
    printf "${YELLOW}${@}${NC}\n"
}


printf "%s${no_color}" "$line"  # prints a given string raw, i.e. with special characters like %

# read a variable line by line.
while read -r line; do  # trims line
    echo "..." $line
done <<< "$some_multiline_string"

# OR

while IFS= read -r line; do  # declaring IFS variable configures read not to trim
    echo "..." $line
done <<< "$some_multiline_string"

# --------------------------------------------------------------------------------------------------
# sleeping / waiting

sleep .5 # Waits 0.5 second.
sleep 5  # Waits 5 seconds.
sleep 5s # Waits 5 seconds.
sleep 5m # Waits 5 minutes.
sleep 5h # Waits 5 hours.
sleep 5d # Waits 5 days.

# --------------------------------------------------------------------------------------------------
# find a program

command -v  # similar to `which`, but builtin

command -v xcrun >/dev/null || die "Xcode command line tools are mandatory"


# --------------------------------------------------------------------------------------------------
# read

read -e -n10 -p "my prompt: " value  # -e newline after input is read  -n10 capture 10 characters, no ENTER needed
read -t2 key  # read into key variable  with a 2 seconds timeout
read -en1  # newline after input is read, read 1 char, throw var away


read -p "Please type your password: " -s  # -s: input not promted to command line; -s doesn't work together with -e; -s shows key symbol, if -n not specified

read -n1 -p 'Press any key to exit' -s ; echo  # does not work with -e, therefore echo afterwards
trap "read -n1 -p 'Press any key to exit' -s ; echo" EXIT

# --------------------------------------------------------------------------------------------------
# read yes no ?

# -e read line, i.e. go to next line after input is read
read -e -n1 -p "Continue? [yY/nN]: " key
if [ "$key" == "y" ] || [ "$key" == "Y" ] ; then
    echo "Yess"
fi


# --------------------------------------------------------------------------------------------------
# date

if [ `date +%w` -eq 0 ] ; then
    echo "date +%w  prints weekday with 0 being Sunday"
fi


# --------------------------------------------------------------------------------------------------
# calculations with arithmetic expressions -- math

a=12
b=13

# with double ((parentheses))
(( res1 = a - b ))               # sets variable res1 to -1

# or with expr:
res2=`expr $a + $b`  # spaces are important
# res2=`expr ( $a + $b )`  # doesnt work - expr seems to have problems with parentheses in equations


# you can also declare a variable to be of integer type, so the right hand side of an assignment
# is treaded as an arithmetic operation, and you don't need the $ for variable expansion
declare -i res3
res3=a-b


# absolute value of a number:
my_negative_number=-10
my_absolute_number=${my_negative_number#-}

my_number=-12
my_number=${my_numberr#-}               # works :)


# --------------------------------------------------------------------------------------------------
# string substitution

firstString="I am a Cat"
secondString="Dog"
echo "${firstString/Cat/$secondString}"    # prints "I am a Dog"

# --------------------------------------------------------------------------------------------------
# handing over variables to awk

variable="line one\nline two"
awk -v var="$variable" 'BEGIN {print var}'  # -v variable name="..."

# --------------------------------------------------------------------------------------------------
# sed

sed -i "s/oldstring/newstring/" myfile.txt  # replace in file


# --------------------------------------------------------------------------------------------------
# use text-templates and set the variables later

TEMPLATE_FILE="my-template.txt"  # contains arbitrary content with ${PLACEHOLDER_1} and ${PLACEHOLDER_2}

PLACEHOLDER_1="Katze"  # will be replaced accordingly
PLACEHOLDER_2="Hundi"

TEMPLATE_TEXT="`cat ${TEMPLATE_FILE}`"
TEXT=`eval "echo \"${TEMPLATE_TEXT}\""`  # eval echo evaluates the variables found in TEMPLATE_FILE

echo ${TEMPLATE_TEXT}  # plain template text
echo "-----------------------------------------------------------------"
echo ${TEXT}  # text with templates substituted with the variables's values

# --------------------------------------------------------------------------------------------------
# idioms


# --------------------------------------------------------------------------------------------------
# functions / recipes


function increment_count {
    # Given a file path and a grep pattern,
    # finds corresponding line in the given file and applies an +1 increment
    # to the last column in the line.
    # The line's last column must consist of a number.
    # There should exactly be one matching line.
    # The file should exist.
    # The function does no erroch checking!
    #
    # Parameters:
    #   $1:  the grep-pattern for which to look for.
    #   $2:  the file name in which to find the line whose last column is to be incremented.
    #
    # Example:
    #   contents of myfile.txt before execution:
    #       Hello world,
    #       The current count is: 0
    #
    #   # invoke function
    #   increment_count "current count is: " "path/to/my/file.txt"
    #
    #   contents of myfile.txt after execution:
    #       Hello world,
    #       The current count is: 1
    # .

    local line=`grep "$1" "$2"`
    local current_count=`echo $line | awk '{print $NF}'`
    local new_count=`expr $current_count + 1`
    local new_line=`echo $line | awk -v nc="$new_count" '{$NF = nc; print}'`
    sed -i "s/$line/$new_line/" "$2"
}

function check_if_this_computer_is_a_mac {
    # Checks if the given unix system is a mac by checking the home directory
    # There are other ways, but this is one.
    # .
    if echo $HOME | grep -v -q "/Users/" ; then
        echo "we're not on mac"
    else
        echo "we're on mac"
    fi
}

function check_if_this_computer_is_a_mac_2 {
    # Checks if the given unix system is a mac by checking the home directory
    # There are other ways, but this is one.
    # .
    if [ "$(uname)" != "Darwin" ] ; then
        echo "we're not on mac"
    else
        echo "We're on Mac"
    fi
}

function is_folder_empty {
    # Checks if the given folder is empty.
    # Beware of whitespaces, maybe.
    # .
    if [ -z "$(ls -A $1)" ]; then
        echo 'given folder is empty'
    else
        echo 'given folder is NOT empty'
    fi
}

function write_find_output_into_array() {
    # taken from: https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash
    array=()
    while IFS=  read -r -d $'\0'; do
        array+=("$REPLY")
    done < <(find . -type d -print0)
}