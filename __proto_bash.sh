# author: andreasl


# --------------------------------------------------------------------------------------------------
# set -e and +e
# see https://www.quora.com/What-is-the-difference-between-set-+e-and-set-e-in-a-bash-script

set -e      # the script immediately exits on error
set +e      # any errors that occur down the line will NOT cause the script to exit, the script will keep running

set -x      # print every command to the output -- you can use it as bash's debug mode
set +x      # disable print every command to the output

set -o pipefail     # bail out when a command at one pipe returns with a non-zero status
    # example:
    notexistingcommand | echo "a" # dies after echo "a". Otherwise, it would not die

set -u      # treat unset variables as an error and exit immediately upon their usage



# --------------------------------------------------------------------------------------------------
# output into stream

echo "Output into nothing" >/dev/null
echo "Append output stream to file and error stream to same as output stream" >myfile.txt 2>&1


# --------------------------------------------------------------------------------------------------
# Variables

export GLOBAL_VARIABLE="HELLO"
local_variable=World


my_array=("a" "b" "c")
my_array=("a", "b", "c")
echo ${my_array}            # prints a
echo ${my_array[1]}         # prints b
echo ${my_array[2]}         # prints c
echo ${my_array[11000]}     # prints nothing
echo ${my_array[@]}         # prints all values in one line: a b



my_long_var="blakeks"
my_short_var=${my_long_var#bla}  # cuts the first part of the given var, i.e. "bla", leaving just "keks"
echo ${my_short_var}


# --------------------------------------------------------------------------------------------------
# for loops

for value in 0 1 3 ; do
    echo $value  # prints 0 1 and 3
done

for value in {1..5} ; do
    echo $value  # prints 1 2 3 4 5
done

for value in (seq 1 5) ; do
    echo $value # prints 1 2 3 4 5
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

# -eq is for numbers
if [ "1" -eq "1" ] ; then
    echo "WELT";
fi

if commands_should_not_go_into_square_brackets ; then
    # ...
fi


if [ "$foo" == "staging" ]  || [ "$foo" == "stage" ]; then
    echo "OR concatenation ||"
elif [ "$foo" == "Andreas" ]  && [ "$bar" == "Langenhagen" ]; then
    echo "AND concatenation &&"
else
    echo "else case"
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
# have a die function :)

function die {
    echo -e "$@"
    exit 1
}

[ -n "$version" ] || die "Version string must not be empty"    # use like this, for example :)


# --------------------------------------------------------------------------------------------------
# use $0 or better ${BASH_SOURCE[0]} to refer to the script's name

# ${BASH_SOURCE[0]} is not sh compatible
# but there was an advantage for BASH_SOURCE[0] which I don't recall currently :)
echo "[$0] vs. [${BASH_SOURCE[0]}]"

if [ $# -ne 1 ] ; then
    die "Usage: $0 [PARAMETER_NAME]\n\n\tExample: $0 MyParam"
fi


# --------------------------------------------------------------------------------------------------
# Use Cat to create a file

cat > "AMS Sample Places/Main/ADAConfiguration.h" << ADACONFIGURATION_EOF
This is the input of the file
It can span
several lines.
ADACONFIGURATION_EOF


# --------------------------------------------------------------------------------------------------
# Use local variables within functions
# functions seem to work with /bin/bash but not with /bin/sh

function myFunction {
    local my_var=42
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

if [ `uname` == "Darwin" ] ; then
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

echo This '$(pwd)': $(pwd) equals '${PWD}': ${PWD} but not '${pwd}: ' ${pwd}, which stays empty


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


function check_if_this_computer_is_a_mac {
    if echo $HOME | grep -v -q "/Users/" ; then
        echo "we're not on mac"
    else
        echo "we're on mac"
    fi
}

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

read -e -n10 -p "my prompt: " value  # -e newline after input is read  -n10 capture 10 characters

read -t2 key  # read into key variable  with a 2 seconds timeout


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
# calculations with arithmetic expressions

a=12
b=13

# with double quotes"
(( res1 = a - b ))               # sets variable res1 to -1

# or wit expr:
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
# use text-templates and set the variables later

TEMPLATE_FILE="my-template.txt"  # contains arbitrary content with ${PLACEHOLDER_1} and ${PLACEHOLDER_2}

PLACEHOLDER_1="Katze"  # will be replaced accordingly
PLACEHOLDER_2="Hundi"

TEMPLATE_TEXT="`cat ${TEMPLATE_FILE}`"
TEXT=`eval "echo \"${TEMPLATE_TEXT}\""`  # eval echo evaluates the variables found in TEMPLATE_FILE

echo ${TEMPLATE_TEXT}  # plain template text
echo "-----------------------------------------------------------------"
echo ${TEXT}  # text with templates substituted with the variables's values