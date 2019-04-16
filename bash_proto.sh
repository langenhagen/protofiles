#!/bin/bash
#
# Prototypical bash snippets.
# Use as reference.
# If there are several ways of solving a specific task, the snippets here exhibit the, to our
# knowledge and belief, best ways af doing things.
#
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
    notexistingcommand || echo "a" # dies after echo "a". Otherwise, it would not die

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

source "path/to/file/to/be/sourced.inc"  # works too, but is not posix compatible


# --------------------------------------------------------------------------------------------------
# the no-op

: # noOp as in the following loop:

for i in A B C ; do
    :                   # empty loop is not possible without noOp, syntax error
done


while : ; do
  echo "Infinite loop"
  sleep 1
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

my_long_var="blakeks"
my_short_var=${my_long_var#bla}  # cuts the first part of the given var, i.e. "bla", leaving just "keks"
echo ${my_short_var}

readonly var=32
#var=128  # does not work

echo "$_"    # prints "echo" ; $_ is the invoking command
printf "$_"  # prints "printf"


# --------------------------------------------------------------------------------------------------
## cd-ing in scripts:

cd some/where || exit 1
(cd  /home/jenkins/PROJECTS/ansible-playbooks/ && git pull) || exit 1

# --------------------------------------------------------------------------------------------------
# here-documents and here-strings

# here-document - a multiline string input
wc -w << EOF
    here-documents
    allow you to
    import
    several lines of text
EOF

# here-string - a single line string input
wc -w <<< 'this should work'

myvar='this works, too'
wc -w <<< $myvar


# --------------------------------------------------------------------------------------------------
# arrays

my_array=("a" "b" "c")
my_array=("a", "b", "c")  # linter warning: better use spaces, not commas
my_array=(
    "a"
    "b"
    "c"
    )
my_array+=('d')             # adds a new element
echo "${my_array}"            # prints a
echo "${my_array[1]}"         # prints b
echo "${my_array[2]}"         # prints c
echo "${my_array[11000]}"     # prints nothing
echo -e "-e flag enables echo to process escape sequences, like \n, or \t. Works with single and double quotes"
printf '%s\n' "${my_array[@]}"         # @ returns all values as sep string (here in a new line each)
printf '%s\n' "${my_array[*]}"         # * returns all values as one string (here in the same line each)

echo ${#my_array[@]}        # prints 3, i.e. the length of the array

for i in "${my_array[@]}" ; do
    echo "jo $i"
done

printf '%s\n' "${my_array[@]}"    # print an array with newline delimiting each entry



my_folders_array=('.' '..' $(ls))  # puts ., .. and all the files/folders given by `ls` into an array



my_multiline_string="this
is my
multiline\nstring"

mapfile -t my_array <<< "$my_multiline_string"

printf '%s\n' "${my_array[@]}"    # prints 'this' 'is my'  'multiline\nstring' in separate lines

for file in "${my_array[@]}" ; do  # iterates safely over an array and retain whitespaces
    echo "$file"
done

declare -a my_explicit_array=()             # explicitly declare an array variable
typeset -a my_other_explicit_array=()       # declare and typeset are exact synonyms


# --------------------------------------------------------------------------------------------------
# dictionaries, or associative arrays
# note: the dictionary might be reordered internally.

declare -A animals
animals=( ['cow']='moo' ['dog']='woof')

declare -A animals=( ['cow']='moo' ['dog']='woof')

declare -A animals
animals=(
    ['cow']='moo'
    ['dog']='woof'
)

animals['katze']='miau'    # set a value
echo ${animals['dog']}  # get a value; returns 'woof'

animal_names="${animals[@]}"    # expands the values
animal_sounds="${!animals[@]}"  # expands the keys

for key in "${!animals[@]}"; do
    echo "$key - ${animals[$key]}";
done


# --------------------------------------------------------------------------------------------------
# for loops
# you can use  continue  and  break

for value in 0 1 3 ; do
    echo "$value"  # prints 0 1 and 3
done

for value in {1..5} ; do
    echo "$value"  # prints 1 2 3 4 5
done

for value in $(seq 1 5) ; do
    echo "$value" # prints 1 2 3 4 5
done

my_array=("one" "two" "three")
for value in "${my_array[@]}" ; do
    echo "$value"
done

for i in $(seq "$(tput cols)"); do printf '*'; done;  # one-liner for loop; print a character repeatedly; that's the best I came up with after 1 hr googling


# also possible, but uncanny
for ((i = 0; i < ${#my_array[@]}; i++)) do
    echo "${my_array[$i]}"
done

# --------------------------------------------------------------------------------------------------
# until loops

retry=0
maxretry=3
until [ $retry -ge $maxretry ]
do
    docker pull "$build_docker_image" && break
    sleep 10
    retry=$((retry+1))
done


# --------------------------------------------------------------------------------------------------
# if-then-else

# in if clauses, = and == are equivalent

# = is for strings
if [ "$expressions" = 'should_be_evaluated_either_by_test_or_wrapped_into_square_brackets' ]; then
    : # ...
fi

# -eq should be used for numbers, also  -ne, -gt -ge, -lt, -le
if [ 1 -eq 1 ] ; then
    echo "WELT";
fi

if commands_should_not_go_into_square_brackets ; then
    : # ...
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

if [[ 'Is any of the given substrings contained?' =~ ('any'|'mooooh') ]]; then
    echo 'should work'
fi


if [ ! -f 'myfile' ] || [ -x 'myexecutable' ] && [ -f 'mythirdfile' ] ; then
    echo 'Complex if-statement with files and and / or concatenators'
fi

# --------------------------------------------------------------------------------------------------
# switch case

case "$status_code" in
    "200")
        return 0
        ;;              ## ;; is how end a case clause
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
myvar=`pwd`  # `..` is legacy, cannot be nested, like $(..)

echo "$(pwd)"
echo "`pwd`"  # `..` is legacy, cannot be nested, like $(..)


# --------------------------------------------------------------------------------------------------
# have a die function

function die {
    echo -e "$*"
    exit 1
}

[ -n "$version" ] || die "Version string must not be empty"    # use like this, for example


# --------------------------------------------------------------------------------------------------
# traps
# code that will be executed on certain signals

function finish {
  : # cleanup code goes here
}
trap finish EXIT  # calls finish on exit, whether on script's normal exit, ctrl+c or via kill <pid>, but not kill -9

trap "read -n1 -p 'Press any key to exit' -s ; echo" EXIT


# --------------------------------------------------------------------------------------------------
# use $0 or better ${BASH_SOURCE[0]} to refer to the script's name

# $0 refers to the called script's name, even when referenced in a file that is sourced by called script
# ${BASH_SOURCE[0]} would refer to the sourced script name in such case
# ${BASH_SOURCE[0]} is not sh compatible
# both $0 and ${BASH_SOURCE[0]} dont follow to the roots of symlinks.

# but there was an advantage for ${BASH_SOURCE[0]} which I don't recall currently
echo "[$0] vs. [${BASH_SOURCE[0]}]"


absolute_script_dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # directory of the current script
absolute_script_dir_path_followed_through_symlinks="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
relative_script_file_path="$(dirname ${BASH_SOURCE[0]})"  # path to the script from where you are, I believe

# move the PWD to the script's directory
absolute_script_dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${absolute_script_dir_path}" || exit 1



if [ $# != 1 ] ; then
    printf "Usage:\n\t$0 <BUILD-PATH>\n\nExample:\n\t$0 path/to/build/folder\n\n"
    exit 1
fi

# use ${FUNCNAME[0]} to refer to the current function's name
function foo {
    echo "${FUNCNAME[0]}"  # prints foo
}




# --------------------------------------------------------------------------------------------------
# Use cat or better read or echo to create a file or a long text inside a variable

cat > "path/to/my-file.txt" << MYFILE_EOF
This is the input of the file
It can span
several lines.
MYFILE_EOF


printf 'Some Trext\n' >> 'path/to/my/file'  # does not work in write-protected directories

printf 'Some Text\n' | sudo tee /etc/sysctl.d/idea.conf  # works in secure folders, overwrites file
printf 'Some Text\n' | sudo tee -a mysecurefile  # works in secure folders, tee -a: appends file


# preferred over cat, since cat is an external command, read is built into bash
IFS= read -r -d '' myvar << EOF
  This is the input of a variable
It can span
    several lines, but echo won't print linebreaks.
 printf will.
EOF


myvar=$(cat << MYVAR_EOF
  This is the input of a variable
It can span
   several lines, but echo won't print linebreaks.
 printf will.
MYVAR_EOF
)


# --------------------------------------------------------------------------------------------------
# copying to clipboard

printf "Copy me to clipboard" | xclip -i -f -selection primary | xclip -i -selection clipboard  # copies to primary and to clipboard clipboards


# --------------------------------------------------------------------------------------------------
# Use local variables within functions
# functions seem to work with /bin/bash but not with /bin/sh

function myFunction {
    local my_var=42  # local var does not leak outside function scope
    return "$my_var"
}


echo "Script file name: " "$0"
echo "Script's first parameter: " "$1"

function myFunction2 {
    echo "USAGE"
    echo "Script's file name: " "$0"
    echo "myFunction2's first param" "$1"  # != $1 of the script
}
myFunction2 "The first param given to the function"


# --------------------------------------------------------------------------------------------------
# Check if current computer is a Mac

if [ "$(uname)" == "Darwin" ] ; then
    echo "we're on Mac"
elif [ "$(uname)" == "Linux" ] ; then
    echo "we're on a Linux"
fi

# if echo $HOME | grep -q "/Users/" ; then  # it's most probably a mac


# --------------------------------------------------------------------------------------------------
# Check if given path points to a file, directory or a symlink
# Symlinks can also be files or directories.


if [ -f "<path>" ]; then  # symlinks are identified too
    echo "Is a file"
fi

if [ -d "<path>" ]; then  # symlinks are identified too
    echo "Is a directory"
fi

if [ -L "<path>" ]; then
    echo "Is a symlink"
fi


# --------------------------------------------------------------------------------------------------
# additionals

printf "The value of param #1 is $1\n"

echo '$(pwd): '$(pwd)' equals ${PWD}: '${PWD}' but not ${pwd}: '${pwd}' - the latter stays empty'


# --------------------------------------------------------------------------------------------------
# command line options

#consider following
my_script some input "some more input"
# or
my_function some input "some more input"


$* # refers to the input as a string - good in most cases
for a in "$*"; do
    echo $a; # prints five lines: some input some more input
done

for a in "$*"; do
    echo $a; # prints just one line
done


$@ # refers to the input as an array - good when you want to iterate over it
for a in "$@"; do
    echo $a;  # prints three lines: some input "some more input"
done

for a in $@; do
    echo $a;  # prints five lines: some input some more input
done


# --------------------------------------------------------------------------------------------------
# command line option parsing -- stupenduously simple -- it's so simple, don't do it


if [ "$1" == "" ] ; then
    echo "my cmd arg not provided"
    exit 1
elif [ "$1" == "Hello" ] ; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else"
fi


# --------------------------------------------------------------------------------------------------
# command line option parsing -- very simple

# just for help
if [ "${1}" == '-h' ] || [ "${1}" == '--help' ] ; then
    show_usage
fi


# also:
my_cmd_arg="${1}"
if [ "$my_cmd_arg" == "" ] ; then
    echo "my cmd arg not provided"
elif [ "$my_cmd_arg" == "Hello" ] ; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else"
fi


# --------------------------------------------------------------------------------------------------
# command line option parsing -- simple and complete, I guess -- I believe this is the best way

logfile="default.log"
send_alive_pushover=false
while [ $# -gt 0 ] ; do
    key="$1"
    case ${key} in
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
    --)
        shift # past argument
        command="$*"
        break
        ;;
    -h|--help)
        show_usage
        exit 0
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

# --------------------------------------------------------------------------------------------------
# command line parsing -- Getopt

short=p:b:a:
long=product:,build_type:,arch:
if [[ $# -lt 2 ]]; then
   show_usage "Incorrect number of parameters"
fi
PARSED=$(getopt --options "$short" --longoptions "$long" --name "$0" -- "$*")
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
            show_usage "Unknown parameter: $*"
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
            ((s == 45 || s == 90)) || show_usage
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            show_usage
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


cd ~
if [ $? != 0 ] ; then
    echo 'Error!'  # does not go in here
fi

cd does/not/exist
if [ $? != 0 ] ; then
    echo 'Error!'  # goes in here. I recommend this way to test $?. It works
fi

# test changes the last return value. if you test against several cases, use either switch or put
# the return value into a variable:
git pull --rebase origin master
code="${?}"
if [ "${code}" == 0 ] ; then
    echo 'all good'
elif [ "${code}" == 1 ] ; then
    echo 'branch does not exist'
elif [ "${code}" == 128 ] ; then
    echo 'merge conflicts'
else
    echo 'unknown error'
fi


# --------------------------------------------------------------------------------------------------
# Printing

myvar=4
printf '%0.s=' $(seq 1 $myvar);  printf '\n'  # prints $myvar number of '='

printf "$PWD"; printf '%0.s.' $(seq ${#PWD} 50 );  printf '\n'

printf "Pad the following number with up to 5 zeros %05d\n" 42;
printf "Pad the following number with up to 5 spaces %5d\n" 42;
printf "Pad some text%3s\n" Hi;

# --------------------------------------------------------------------------------------------------
# Coloring

# color codes; overwrite with empty string '' if you want to disable them dynamically
# The sheme appear to be combined values, with the first column definining form related things
# (bold/italic, etc) and the second column defining colors. One can, however, apparently, omit
# columns.

# Print the 256 colors :)
for i in {0..15} ; do
    for j in {0..15} ; do
        ((c= j * 16 + i ));
        printf "\x1b[38;5;${c}m%9s" "colour${c}";
    done
    printf "\n";
done


# color codes
cyan='\e[1;36m'
red='\e[31m'
red='\e[0;31m'
green='\e[1;32m'
yellow='\e[1;33m'
nc='\e[m' # No Color
bold='\e[1m'

# \e can also appear as \033, but \e is shorter

# or in short form
r='\e[31m'
g='\e[32m'
b='\e[1m'
rb='\e[1;31m'
n='\e[m'

printf "\e[1mSOMETHING IN BOLD\e[m\n"
printf "\e[0;31mSOMETHING IN RED\e[m\n"
printf "\e[1;32mSOMETHING IN BOLD GREEN\e[m\n"
printf "\e[1;33mSOMETHING IN YELLOW\e[m\n"
printf "\e[0;33mSOMETHING IN DARK YELLOW\e[m\n"

function echo-error {
    printf "${red}${*}${nc}\n"
}

function echo-head {
    printf "${cyan}${*}${nc}\n"
}

function echo-ok {
    printf "${green}${*}${nc}\n"
}

function echo-warn {
    printf "${yellow}${*}${nc}\n"
}


printf "%s${no_color}" "$line"  # prints a given string raw, i.e. with special characters like %

printf '%-50s' 'Some filled string '; printf 'some string starting after 50 characters\n';


# You can print bold, tinted, italic, underscored and even blinking text. Really fancy
printf '\e[0mHallo\e[m\n'
printf '\e[1mHallo\e[m\n'  # bold/bright
printf '\e[2mHallo\e[m\n'
printf '\e[3mHallo\e[m\n'
printf '\e[4mHallo\e[m\n'  # underline
printf '\e[5mHallo\e[m\n'  # blinking
printf '\e[6mHallo\e[m\n'
printf '\e[7mHallo\e[m\n'
printf '\e[8mHallo\e[m\n'
printf '\e[1;2mHallo\e[m\n'
printf '\e[1;5mHallo\e[m\n'  # bold/bright & blinking

# --------------------------------------------------------------------------------------------------
# Print a color palette
# found here: https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal

for((i=16; i<256; i++)); do
    printf "\e[48;5;${i}m%03d" $i;
    printf '\e[0m';
    [ ! $(((i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
done


# --------------------------------------------------------------------------------------------------
# read

read -e -n10 -p "my prompt: " value  # -e newline after input is read  -n10 capture 10 characters, no ENTER needed
read -t2 key  # read into key variable  with a 2 seconds timeout
read -en1  # throw var away -e: makes read print a newline after character is read  -n1: read 1 char


read -p "Please type your password: " -s  # -s: input not promted to command line; -s doesn't work together with -e; -s shows key symbol, if -n not specified

read -n1 -p 'Press any key to exit' -s ; echo  # does not work with -e, therefore echo afterwards
trap "read -n1 -p 'Press any key to exit' -s ; echo" EXIT


echo "Really?"
read -r -p "<ctrl+c> to escape or enter to proceed"


# --------------------------------------------------------------------------------------------------
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

command -v  MYPRGRAM  # similar to `which`, but builtin, and thus generally preferred

command -v xcrun >/dev/null || die "Xcode command line tools are mandatory"
command -v xcrun >/dev/null && echo "Program exists, do something"


if [ "$(command -v apt)" ] ; then
    echo "apt exists"
fi

if [ ! "$(command -v brew)" ] ; then
    echo "brew dows not exist"
fi


# --------------------------------------------------------------------------------------------------
# read yes no ? or yes or no :)

# -e read line, i.e. go to next line after input is read
read -e -n1 -p 'Continue? [yY/nN]: ' key
if [ "$key" == 'y' ] || [ "$key" == 'Y' ] ; then
    echo 'You pressed Yess'
fi

read -e -n1 -p 'Continue? [yY/nN]: ' key
if [ "$key" != 'y' ] && [ "$key" != 'Y' ] ; then
    echo 'Good Bye!'
    exit 1
fi


# --------------------------------------------------------------------------------------------------
# date

if [ $(date +%w) -eq 0 ] ; then
    echo "date +%w  prints weekday with 0 being Sunday"
fi


# --------------------------------------------------------------------------------------------------
# time - measure execution time of something

time ls
time myscript.sh  # returns the execution time in minuts seconds

# --------------------------------------------------------------------------------------------------
# calculations with arithmetic expressions -- math

a=12
b=13

# with double ((parentheses))
(( res1 = a - b ))               # sets variable res1 to -1

res2=1
(( res2 += 2 ))  # increases res2 to 3

# or with expr:
res2=`expr $a + $b`  # spaces are important; prefer $((..))
# res2=`expr ( $a + $b )`  # doesnt work - expr seems to have problems with parentheses in equations


# you can also declare a variable to be of integer type, so the right hand side of an assignment
# is treaded as an arithmetic operation, and you don't need the $ for variable expansion
declare -i res3
res3=a-b


# absolute value of a number:
my_negative_number=-10  # could also be 10
my_absolute_number=${my_negative_number#-}


# --------------------------------------------------------------------------------------------------
# Default values in Bash
# found here: https://unix.stackexchange.com/questions/122845/using-a-b-for-variable-assignment-in-scripts/122878
# There are more variants to this, look in the link or for terms like "Parameter Expansion" and
# "Parameter Substitution"


# the following substitutes non-existent and empty vars:
echo "$my_nonexisting_or_null_var"  # empty / non-existent
my_substituted_var="${my_nonexisting_or_null_var:-default value}"
echo "$my_substituted_var"  # prints 'default value'
# vs.
my_var="has value"
echo "$my_var" # prints 'has value'
my_substituted_var="${my_var:-default value}"
echo "$my_substituted_var" # prints 'has value'

# the following substitutes non-existing vars:
myvar_with_default_value="${my_nonexisting_var-I am the default value}"
echo "$myvar_with_default_value" # prints 'I am the default value'

my_existing_var="Hello"
myvar_with_default_value="${my_existing_var-I am the default value}"
echo "$myvar_with_default_value" # prints 'Hello'


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

myvar='This contains some oldstring'
sed -i 's/oldstring/newstring/g' <<< "$myvar"   # replace oldstring with newstring in a variable

sed -i 's/oldstring/newstring/g' myfile           # replace oldstring with newstring in myfile.txt -i: write result inplace back to file
sed -i '/pattern to match/d' myfile          # delete containing pattern in file

sed '/BEGIN MARKER/,/END Marker/d' myfile       # delete all lines between and including the given markers

sed -n '/Begin Match/,/End Match/p' myfile        # print all lines between and including Begin Match and End Match; -n: quiet the rest of the output

sed '0,/replace_this/s//with_that/' my.lua  # replaces the first occurence of 'replace_this' with 'with_that'; only work in gnu sed
sed '0,/this/d' my.lua  # deletes the first line containing 'this'; only with gnu sed

echo 'willNotChange:WillAlsoNotChange:ThisAfterLastColonWillChange' | sed 's|\(.*\):.*|\1:AChange|'  # changes everything after the last colon; uses the capture group \1

sed 's/[ \t]*$//'                                 # remove trailing whitespaces or tabs
fold -s -w 72 myfile.txt | sed 's/[ \t]*$//'      # fold myfile's contents at 72 characters, sed removes trailing whitespaces


# --------------------------------------------------------------------------------------------------
# Write and overwrite blocks or sections of text into files

begin_section_line='# === BEGIN SUBLIME TEXT BLOCK - DO NOT TOUCH MANUALLY ===';
end_section_line='# === END SUBLIME TEXT BLOCK ===';

hosts_file_section=$(cat << SECTION_EOF
${begin_section_line}
Your message goes here
${end_section_line}
SECTION_EOF
)

# for root secured files:
hosts_file_path="/etc/hosts";
sudo sed -i "/${begin_section_line}/,/${end_section_line}/d" "${hosts_file_path}";
printf "${hosts_file_section}" | sudo tee -a "${hosts_file_path}";
# OR for normal user files:
hosts_file_path="/etc/hosts";
sed -i "/${begin_section_line}/,/${end_section_line}/d" "${hosts_file_path}";
printf "${hosts_file_section}" >> "${hosts_file_path}";

# --------------------------------------------------------------------------------------------------
# templates text files and set the variables later

template_file="my-template.txt"  # contains arbitrary content with ${placeholder_1} and ${placeholder_2}

placeholder_1="Katze"  # will be replaced accordingly
placeholder_2="Hundi"

text_template="$(cat ${template_file})"
text="$(eval "echo \"${text_template}\"")"  # eval echo evaluates the variables found in TEMPLATE_FILE

echo "${text_template}"  # plain template text
echo "-----------------------------------------------------------------"
echo "${text}"  # text with templates substituted with the variables's values


# --------------------------------------------------------------------------------------------------
# idioms and caveats

# using user defined functions with `find`'s `-exec` `-execdir` and so on
# you have to call the function using `bash -c`
function my_function_called_by_find {
    printf "Hi \e[1m${PWD}\e[0m\n"
}
export -f my_function_called_by_find  # since the subshell should you open below in find
                                      # should know about the function, you have export -f it

find . -maxdepth 3 -type d -iname "*.git" -execdir bash -c 'my_function_called_by_find' '{}' \;

# --------------------------------------------------------------------------------------------------
# emulating ternary operator with boolean concatenation

test "${1}" == '--moo' && is_moo='yes' || is_moo='no'


# --------------------------------------------------------------------------------------------------
# a nice and readable way to abstract variables to booleans

is_moo="$(test "${1}" == '--moo'; echo ${?})"
if [ "${is_moo}" -eq "0" ] ; then
    echo 'Mooooo'
fi


# --------------------------------------------------------------------------------------------------
# Temporary dirs

# possible workflow

tmp_dir_path="$(mktemp -d)"
cd "${tmp_dir_path}"
# ...
rm -rf "${tmp_dir_path}"

# --------------------------------------------------------------------------------------------------
# functions / recipes

echo $(((RANDOM%1000+1)))  # create a random number


echo -- *.log | xargs -n1 cp /dev/null  # delete the contents of multiple files


# colorize tail-ed output with awk (your tail version has to support stream flushing)
tail -f var/log/nginx/*.log | awk '
  /warn/ {print "\e[32m" $0 "\e[39m"; next}
  /error/ {print "\e[33m" $0 "\e[39m"; next}
  {print}
'

# check if myfile is a binary
myfile="05-2raumwohnung-ich_bin_der_regen.mp3"
myfile_charset="$(file -i "${myfile}" | awk '{print $3}' | grep 'charset=binary')"
if [[ $? -eq 0 ]] ; then
    echo "${myfile} is a binary file: ${myfile_charset}"
else
    echo "${myfile} is not a binary file: ${myfile_charset}"
fi


# grep to a variable and retain lines, e.g. for further grepping
current_results=$(grep -i '#snippet' "${data_file}")
printf '%s' "${current_results}"  | grep -i 'hello' # using '%s'  retains possible \n characters in
                                                    # the content, i.e. they are given as \n as
                                                    # opposed to break lines like  printf
                                                    # "${current_results}"  would do


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

    local line
    line="$(grep "$1" "$2")"
    local current_count
    current_count="$(echo "$line" | awk '{print $NF')"
    local new_count
    new_count="$(expr $current_count + 1)"
    local new_line
    new_line="$(echo "$line" | awk -v nc="$new_count" '$NF = nc; print}')"
    sed -i "s/$line/$new_line/" "$2"
}

function check_if_this_computer_is_a_mac {
    # Checks if the given unix system is a mac by checking the home directory
    # There are other ways, but this is one.
    # .
    if echo $HOME | grep -v -q "/Users/" ; then  # grep -q: quiet
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
    if [ -z "$(ls -A "$1")" ]; then
        echo 'given folder is empty'
    else
        echo 'given folder is NOT empty'
    fi
}

function write_find_output_into_array {
    # taken from: https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash
    array=()
    while IFS=  read -r -d $'\0'; do
        array+=("$REPLY")
    done < <(find . -type d -print0)
}

function count_occurences_of_substring_in_string {
    # Prints the number of occurences of a given substring $1 in a given string $2.
    # Found on:  https://stackoverflow.com/questions/26212889/bash-counting-substrings-in-a-string
    local recuced_string=${2//"$1"}
    echo "$(((${#2} - ${#recuced_string}) / ${#1}))"
}

function generate_random_pronounceable_word {
    # Given a word length, generates a random pronounceable word in lower case and returns it.
    # The word is created letter by letter, i.e. each character is added sequentially. A vovel is
    # created with the chance of 1/3 and an a consonant with the chance of 2/3, but no more than 2
    # consonants are created after one another.
    #
    # Usage:
    #   ${FUNCNAME[0]} <number>
    #
    # Example:
    #   ${FUNCNAME[0]} 7

    local word_length="${1}"
    local num_consonants_since_last_vovel=0
    local random_word
    for v in $(seq 1 "${word_length}") ; do
        if [[ num_consonants_since_last_vovel -ge 2 ]] || [[ $(((RANDOM%3))) -eq 0 ]] ; then
            local random_letter
            random_letter=$(tr -dc 'aeiou' < '/dev/urandom' | head -c 1)
            ((num_consonants_since_last_vovel = 0))
        else
            local random_letter
            random_letter=$(tr -dc 'bcdfghjklmnpqrstvwxyz' < '/dev/urandom' | head -c 1)
            ((num_consonants_since_last_vovel += 1))
        fi
        random_word="${random_word}${random_letter}"
    done

    echo "${random_word}"
}

function show_usage {
    # Given the name of the script, prints the usage string.
    #
    # Usage:
    #   ${FUNCNAME[0]}

    script_name="$(basename "$0")"

    output="${script_name}\n"
    output="${output}\n"
    output='Usage:\n'
    output="${output} ${script_name} [-q|--quiet] [-d|--depth <number>] [<path>] [-- <command>]\n"
    output="${output}\n"
    output="${output}Examples:\n"
    output="${output}  ${script_name}                      # lists the found git repositories\n"
    output="${output}  ${script_name} -d 2 -- ls           # lists the found git repositories and"
    output="${output} calls \`ls\` from all git repos in this file level and one level below\n"
    output="${output}  ${script_name} -q -d 2 -- ls        # calls \`ls\` from all git repos in"
    output="${output} this file level and one level below but does not list the found gir repos\n"
    output="${output}  ${script_name} -p path/to/dir -- ls # calls \`ls\` from all git repos below"
    output="${output} the given path\n"
    output="${output}  ${script_name} -q -- realpath .     # prints the paths of all git repos"
    output="${output} below the current path\n"
    output="${output}  ${script_name} -h                   # prints the usage message\n"
    output="${output}  ${script_name} --help               # prints the usage message\n"
    output="${output}\n"
    output="${output}Note:\n"
    output="${output}  If you want to use subshell related-variables, like e.g. \$PWD, wrap them"
    output="${output} into single quotation marks so that they will not be expanded ''"
    output="${output} immediately.\n"
    printf "${output}"
}

function show_usage {
    # Given the name of the script and an optional error message, prints this error message in color
    # and prints the usage string.
    #
    # Usage:
    #   ${FUNCNAME[0]} <error_message>
    #
    # Examples:
    #   ${FUNCNAME[0]}
    #   ${FUNCNAME[0]} "Incorrect number of parameters"

   script_name="$(basename "$0")"

    if ! [ -z "${2}" ] ; then
        printf "\e[0;31m${2}\e[0m\n\n"
    fi
    output="${script_name}\n"
    output="${output}\n"
    output='Usage:\n'
    output="${output}  ${script_name} <my_param>\n         # <does something>\n"
    output="${output}  ${script_name} -h                   # prints the usage message\n"
    output="${output}  ${script_name} --help               # prints the usage message\n"
    output="${output}\n"
    output="${output}Example:\n"
    output="${output}  ${script_name} https://codereview.mycompany.com/15481\n"
    printf "${output}"
}
