#!/bin/bash
# Prototypical bash snippets.
# Use as reference.
# If there are several ways of solving a specific task, the snippets here exhibit the, to our
# knowledge and belief, best ways af doing things.
#
# author: andreasl

# --------------------------------------------------------------------------------------------------
# set and shopt
# see https://www.quora.com/What-is-the-difference-between-set-+e-and-set-e-in-a-bash-script

set -e      # the script immediately exits on error; errors in if-conditions still pass, though
set +e      # any errors that occur down the line will NOT cause the script to exit, the script will keep running

set -x      # print every command to the output -- you can use it as bash's debug mode; comments are not printed
set +x      # disable print every command to the output

set -o pipefail     # bail out when a command at one pipe returns with a non-zero status
    # example:
    notexistingcommand || printf 'a\n' # dies after printf 'a\n'. Otherwise, it would not die

set -u      # treat unset variables as an error and exit immediately upon their usage

shopt globstar  # show the current value of a shell option

shopt -s extglob  # activate extendend globbing capabilities in a script, like, I guesss: `ls "foo/"*bar*`

shopt -s globstar  # activate double asterisk `**` globbing like: `ls **`; otherwise, `**` globbing only returns 1 result


# --------------------------------------------------------------------------------------------------
# inspect a given thing

type pwd  # pwd is a builtin
type date  # date is /bin/date
type cd  # prints the definiton of `cd`

type -t file  # results `file``
type -t pwd   # results `builtin`
type -t cd   # results `function`


# --------------------------------------------------------------------------------------------------
# output and streams

printf 'Output into nothing / silence the output\n' >/dev/null
printf 'Append output stream to file and error stream to same as output stream\n' >myfile.txt 2>&1

>&2 echo 'This outputs to the stderr error stream.'
(>&2 echo 'error')  # To avoid interaction with other redirections use subshell

./myprogram.sh |& tee -a  # since Bash version 4 you may use  |&  as an abbreviation for  2>&1 |

# print every character repeatedly for a fixed number
printf '=%.0s' {1..100}  # doesn't work with variables

# print every character repeatedly for a variable number
printf '=%.0s' $(seq "$(tput cols)") # print a character repeatedly


echo -e "-e flag enables echo to process escape sequences, like \n, or \t. Works with single and double quotes"


# --------------------------------------------------------------------------------------------------
# source files / sourcing files
# calling 'exit' from within a sourced file makes the sourcing script exit

. 'path/to/file/to/be/sourced.inc'
. works/also/but/better/to/quote/when/whitespaces/can/occur

source 'path/to/file/to/be/sourced.inc'  # works too, but is not posix compatible

source "path/to/file/to/be/sourced.inc" 'sourcing accepts' 'parameters' ':)'


# --------------------------------------------------------------------------------------------------
# the no-op

: # noOp as in the following loop:

for i in A B C; do
    :                   # empty loop is not possible without noOp, syntax error
done

while true; do
  echo 'Also Infinite loop'
  sleep 1
done

while :; do
  echo 'Also infinite loop'
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

echo "$_"    # prints "echo"; $_ is the invoking command
printf "$_"  # prints "printf"


# length of a string-variable
mystring="hi there"
echo "mystring has the length: ${#mystring}"

# --------------------------------------------------------------------------------------------------
# Source a .env file

set -o allexport
source .env
set +o allexport


source_env() {
    if [ -f "$1" ]; then
        set -o allexport
        source "$1"
        set +o allexport
    fi
}

source_env .env

# --------------------------------------------------------------------------------------------------
# defaults - parameter substitution / parameter expansion

# the following substitutes non-existent or empty vars:
echo "$my_nonexisting_or_null_var"  # empty / non-existent
my_substituted_var="${my_nonexisting_or_null_var:-default value}"
echo "$my_substituted_var"  # prints 'default value'
# vs.
my_var="has value"
echo "$my_var" # prints 'has value'
my_substituted_var="${my_var:-default value}"
echo "$my_substituted_var" # prints 'has value'

# you can also use variables in the defaults
default=42
myvar=${my_nonexisting_or_null_var:-${default}}

# the following substitutes non-existing vars:
myvar_with_default_value="${my_nonexisting_var-I am the default value}"
echo "$myvar_with_default_value" # prints 'I am the default value'

my_existing_var="Hello"
myvar_with_default_value="${my_existing_var-I am the default value}"
echo "$myvar_with_default_value" # prints 'Hello'


# --------------------------------------------------------------------------------------------------
# + Use alternative value if variable is declared or set, otherwise use empty value

myvar=${my_undefined_var+'my alternative value'}
echo "myvar = $myvar"      # myvar =

my_empty_var=
myvar=${my_empty_var+'my alternative value'}
echo "myvar = $myvar"      # myvar = my alternative value

my_set_var=123
echo ${my_set_var+'my alternative value'}
echo "myvar = $myvar"      # myvar = my alternative value

# --------------------------------------------------------------------------------------------------
# :+ Use alternative value if variable is set, otherwise use empty value;
# :+ is weaker than +

myvar=${my_undefined_var:+'my alternative value'}
echo "myvar = $myvar"      # myvar =

my_empty_var=
myvar=${my_empty_var:+'my alternative value'}
echo "myvar = $myvar"      # myvar =     ; different from  myvar=${my_empty_var+'my alternative value'} which would give 'my alternative value'

my_set_var=123
myvar=${my_set_var:+'my alternative value'}
echo "myvar = $myvar"      # myvar = 'my alternative value'

# --------------------------------------------------------------------------------------------------
# string substitution / parameter substitution aka parameter expansion

first_string='I am a Cat'
second_string='Cat'
third_string='Dog'
echo "${first_string/Cat/$third_string}"    # "I am a Dog"
echo "${first_string/$second_string/Bear}"    # "I am a Bear"
echo "${first_string/Cat/}"  # print "I am a" - remove first occurence, do not overwrite original var

my_var='Hello, Andi, Andi and Andi'

echo "${my_var/Andi/}"  # remove first occurence of Andi, does not overwrite the original var
echo "${my_var//Andi/}"  # remove all occurences of Andi, does not overwrite the original var
echo "${my_var/Andi/Cat}"  # replace first occurence of Andi with Cat, does not overwrite the original var
echo "${my_var//Andi/Cat}"  # replace all occurences of Andi with Cat, does not overwrite the original var

echo "${my_multiline_string//$'\n'/,}"  # replace all newlines with commas ,


echo "${my_var#Hello, }"  # nongreedy remove any prefix from the expanded value that matches the pattern
echo "${my_var%, Andi and Andi}"  # nongreedy remove any suffx from the expanded value that matches the pattern

echo "${my_var#*,}"  # remove substring before comma, - nongreedy aka lazy
echo "${my_var##*,}"  # remove substring before comma , - greedy aka eager
echo "${my_var%,*}"  # remove substring after last comma , - nongreedy aka lazy
echo "${my_var%%,*}"  # remove substring after first comma , - greedy aka eager

my_var='  Something untrimmed   '
echo "${my_var##*( )}"      # greedy trim all leading spaces; needs `shopt -s extglob` set
echo "${my_var%%*( )}!"     # greedy trim all trailing spaces; needs `shopt -s extglob` set

echo ${my_var:18:3} # retieve a substring by offset and length
echo ${my_var::5} # retieve a substring with no offset and and length 5
echo ${my_var:((-4)):4} # retieve a substring by negative offset and length

offest=-4
echo ${my_var:$offset:4} # works, too


echo ${PWD//\//\\\/}  # escape all occurences of '/' to '\/'


# --------------------------------------------------------------------------------------------------
# pattern deletion / parameter expansion

my_var="Hello, Andi, Andi and Andi"
file_path='path/to/looong/my/file.tar.gz'
echo "${my_var#Hello, }"  #remove any prefix from the expanded value that matches the pattern
echo "${file_path#*/}"  # to/looong/my/file.tar.gz; delete shortest prefix pattern
echo "${file_path#*.}"  # prints the file extension tar.gz`
echo "${file_path##*/}"  # prints the filename `file.tar.gz`; builtin replacement for command "basename"; delete longest prefix pattern


echo "${my_var%, Andi and Andi}"  #remove any suffx from the expanded value that matches the pattern, e.g. trailing characters
echo "${file_path%.*}"  # path/to/looong/my/file.tar; remove shortest file extension
echo "${file_path%%.*}"  # path/to/looong/my/file; remove longest file extension


script_name="${0##*/}"

# --------------------------------------------------------------------------------------------------
# missing variable messages

ls "${my_unset_variable:?Message gets displayed by bash if the variable does not exist}"  # bash: my_unset_variable: Message gets displayed by bash if the variable does not exist


# --------------------------------------------------------------------------------------------------
# indirect redirection
# specify variables in clear text use clear text variables:

my_var='my_other_var'
my_other_var='hello indirect redirection'

echo ${my_var}  # my_other_var
echo ${!my_var}  # hello indirect redirection


my_var='not_a_variable'
echo ${my_var}  # my_other_var
echo ${!my_var}  # empty string ''

# --------------------------------------------------------------------------------------------------
# cd-ing in scripts:

cd some/where || exit 1
(cd  /home/jenkins/PROJECTS/ansible-playbooks/ && git pull) || exit 1


# --------------------------------------------------------------------------------------------------
# cp behaves differently when copying folders and the destination folder is different

cp -r "mysourcefolder" "mydestfolder"  # copy contents of mysourcefolder into mydestfolder if mydestfolder is absent, else copy mysourcefolder into mydestoflder
cp -Tr "mysourcefolder" "mydestoflder"  # always copy ontents of mysourcefolder into mydestfolder

# --------------------------------------------------------------------------------------------------
# here documents and here strings aka heredoc and herestrings

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

my_array=()
my_array=('a' 'b' 'c')
my_array=('a', 'b', 'c')  # linter warning: better use spaces, not commas
my_array=(
    'a'
    'b'
    'c'
)
my_array+=('d')             # add a new element
my_other_array=("${my_array[@]}")  # copy an array
my_array+=("${my_other_array[@]}")  # append an array
echo "${my_array}"            # print just a
echo "${my_array[1]}"         # print b
echo "${my_array[2]}"         # print c
echo "${my_array[11000]}"     # print nothing
echo "${my_array[-1]}"  # print c, the last element
echo "${my_array[-2]}"  # print b, the second-to-last element
printf '%s\n' "${my_array[@]}"         # @ return all values as sep string (here in a new line each)
printf '%s\n' "${my_array[*]}"         # * return all values as one string (here in the same line each)

unset my_array[2]  # delete the element from the array at the given index, the other elements dont fill back the index!
unset my_array[0]  # delete the first element, the second element staying my_array[1] however!
unset my_array[${#my_array[@]}-1]  # delete the last element

my_array=( "${my_array[@]//b/foo}" )  # replace all occurences of pattern in every string in every item with foo
my_array=( "${my_array[@]/b/foo}" )  # replace first occurence of pattern in every string in every item with foo

echo "Array has length ${#my_array[@]}"        # print 3, i.e. the length of the array

# print array - print an array with preceeding > and newline delimiting each entry
printf '> %s\n' "${my_array[@]}"
printf '> %s\n' "${my_array[@]:0:2}"  # sub-array from 0 with length 2
printf '> %s\n' "${my_array[@]:2}"  # sub-array from index 2 til end

# transform an array into a regex
tmp="${my_array[@]}"
regex="(${tmp// /|})"
echo "$regex"

# iteration
# wrap arrays into quotation marks to retain items with spaces.
for i in "${my_array[@]}"; do
    echo "jo $i"
done

# index-wise iteration
for i in "${!my_array[@]}"; do
    echo "${i}  ${my_array[$i]}"  # "0  a", then "1 b" and so on
done


my_folders_array=('.' '..' $(ls))  # puts ., .. and all the files/folders given by `ls` into an array


# convert a multiline string to an array

my_multiline_string='this
is my
multiline\nstring'

mapfile -t my_array <<< "$my_multiline_string"  # its items may contain whitespaces and still are nicely iterable

printf '%s\n' "${my_array[@]}"    # prints 'this' 'is my'  'multiline\nstring' in separate lines

IFS=,; echo "${my_array[*]}"  # set internal Field Separator (IFS) to comma `,`, so that "multiline,string"

for file in "${my_array[@]}"; do  # iterates safely over an array and retain whitespaces
    echo "$file"
done


# create an array from a string with custom delimeter
my_array_string='Hello;From;Bash!\nHulk\nSmash!'
IFS=';' read -ra my_array <<< "$my_array_string"  # IFS stands for "internal field separator"; defines here where to split the array
printf '%s\n' "${my_array[@]}"    # prints 'Hello' 'From'  'Bash!\nHulk\nSmash!' in separate lines

# create a string from array with custom nice delimeters
join_items_by() {
    # Join given strings by a given delimeter
    # Based on:
    # https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash
    local IFS="$1"
    shift
    printf '%s' "$*"
}
join_items_by '/' "${my_array[@]}"  # Hello/From/Bash!\nHulk\nSmash!

declare -a my_explicit_array=()             # explicitly declare an array variable
typeset -a my_other_explicit_array=()       # declare and typeset are exact synonyms


# --------------------------------------------------------------------------------------------------
# dictionaries, or associative arrays aka maps
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

for i in 0 1 3; do
    echo "$i"  # prints 0 1 and 3
done

# {1..5} not sh compatible
for i in {1..5}; do                # doesn't work with variables
    echo "$i"  # prints 1 2 3 4 5
done

# throwaway variables
for _ in {1..5}; do
    echo 'Hi!'
done

# sh compatible
for value in $(seq 5); do
    echo "$value" # prints 1 2 3 4 5
done

for value in $(seq 3 5); do
    echo "$value" # prints 3 4 5
done

my_array=('one' 'two' 'three')
for value in "${my_array[@]}"; do
    echo "$value"
done

for i in $(seq ${#my_array[@]}); do  # that's what works with arrays
    echo "index $i"
done

for f in *; do
    echo " file: $f";
done

# modern bash, c-style-ish for-loops
for ((i = 0; i < 10; i++)) {
    echo "${i} is a number"
}


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

# often, you can avoid if-statements
[ "Hello" == "World" ] && echo "never happens"
[ "Hello" == "World" ] || echo "will happen"
[ "Hello" == "World" ] && { echo "multiple"; echo "statements possible"; exit1; }

((42 != 36)) && {
    echo 'Modern way to use double parentheses (( )) for testing numbers'
    exit 1
}

# in if clauses, = and == are equivalent

# = is for comparing strings
if [ "$expressions" = 'should_be_evaluated_either_by_test_or_wrapped_into_square_brackets' ]; then
    : # ...
fi

# -eq should be used for numbers, also  -ne, -gt -ge, -lt, -le
if [ 1 -eq 1 ]; then
    echo "WELT";
fi


if commands_should_not_go_into_square_brackets; then
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


if [[ "Does this string contain a substring?" == *"contain a"* ]]; then
    # note the [[ ... ]]. If it is [ ... ], it's the other way round.
    # Works also at the edges, i.e. with "Does" and "ubstring?".
    # Is case specific.
    echo 'Substring found!'
fi

if [[ "Also check for regular expressions is possible with equalstilde" =~ r.*r ]]; then
    # it's important not to put the regex in quotes in bash. However, zsh wants quots.
    echo "Regex found!"
fi

if [[ 'Is any of the given substrings contained?' =~ 'any'|mooooh ]]; then
    echo 'should work'
fi

if [[ 'Should everywhere work ?' =~ ^fromstart|everywhere|end$ ]]; then
    echo 'should work';
fi

if [ ! -f 'myfile' ] || [ -x 'myexecutable' ] && [ -f 'mythirdfile' ]; then
    echo 'Complex if-statement with files and and / or concatenators'
fi

if [[ 'mysite.com/demo/v1' =~ mysite\.com/(demo|stage)/v1 ]]; then
    echo "Matches"
fi



# --------------------------------------------------------------------------------------------------
# switch case

case "$status_code" in
    '200')
        return 0
        ;;  # ;; is how end a case clause
    '404'|'666')
        return 1
        ;;
    *)
        die "Program returned status code ${status_code}"
        ;;
esac

# --------------------------------------------------------------------------------------------------
# inline command code execution
myvar=$(pwd)
myvar=`pwd`  # `..` is legacy, cannot be nested, like $(..)

echo "$(pwd)"
echo "`pwd`"  # `..` is legacy, cannot be nested, like $(..)


# --------------------------------------------------------------------------------------------------
# traps
# code that will be executed on certain signals

# Cleanup actions at program end.
on_exit() {
  : # cleanup code goes here
}
trap on_exit EXIT  # calls on_exit on exit, whether on script's normal exit, ctrl+c or via kill <pid>, but not kill -9

trap "read -n1 -p 'Press any key to exit' -s; echo" EXIT


# functions and traps can be defined inside e.g. if-clauses;
if [ "$a" == 'yes' ]; then
   echo "Yesssss"
   on_exit() {    # will be executed on program exit
       echo "My clean"
   }
   trap on_exit EXIT
fi

# delete a temporary file on exit
tmp=$(mktemp)
trap "rm -f $tmp" EXIT

# disable a trap
trap - EXIT

# ask for a readline between every command
trap 'read -p "Press enter to continue..."' DEBUG

# A nice debug readline before every command. Looks like:
trap '$(read -p "[${BASH_SOURCE}:${LINENO}] ${BASH_COMMAND}")' DEBUG      # print [/path/to/myscript.sh:6] echo "Hello $name"  before every command
trap '$(read -p "[${BASH_SOURCE##*/}:${LINENO}] ${BASH_COMMAND}")' DEBUG  # or omit path to file the alternative [myscript.sh:6] echo "Hello $name"

# Other Signals:
SIGHUP
SIGINT
SIGTERM
DEBUG

# Have only 1 exit trap
foo() { echo "Hello" }
trap foo EXIT
bar() { echo "World!" }
trap bar EXIT
# ... would only print 'World!'


# --------------------------------------------------------------------------------------------------
# use $0 or better ${BASH_SOURCE[0]} to refer to the script's name

# $0 refers to the called script's name, even when referenced in a file that is sourced by called script
# ${BASH_SOURCE[0]} would refer to the sourced script name in such case
# ${BASH_SOURCE[0]} is not sh compatible
# both $0 and ${BASH_SOURCE[0]} dont follow to the roots of symlinks.

echo "[$0] vs. [${BASH_SOURCE[0]}]"

# in the following some copy-pasteable snippets
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

parent_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$(dirname "${BASH_SOURCE[0]}")"
cd "$(dirname "${BASH_SOURCE[0]}")/.." || { echo 'Error: Failed to cd to project root'; exit 1; }


absolute_script_dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # directory of the current script, i.e. script or sourced script
absolute_script_dir_path_followed_through_symlinks="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
relative_script_file_path="$(dirname ${BASH_SOURCE[0]})"  # path to the script from where you are

# move the PWD to the script's directory
absolute_script_dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$absolute_script_dir_path" || exit 1


if [ $# != 1 ]; then
    printf "Usage:\n\t$0 <BUILD-PATH>\n\nExample:\n\t$0 path/to/build/folder\n\n"
    exit 1
fi

# alternative
[ $# != 1 ] && { printf "Usage:\n\t$0 <BUILD-PATH>\n\nExample:\n\t$0 path/to/build/folder\n\n"; exit 1; }


# use ${FUNCNAME[0]} to refer to the current function's name
foo() {
    echo "${FUNCNAME[0]}"  # prints foo
}




# --------------------------------------------------------------------------------------------------
# Use cat or better read or echo to create a file or a long text inside a variable

# warning: when using ``<< MYFILE_EOF` while writing bash code to a file, this thing
# interprets/evaluats subshells. if you want to prohibit that, put MYFILE_EOF into single quotes like
# so: << 'MYFILE_EOF'

cat > "my-file.txt" << MYFILE_EOF
   This is the input of the file
  It can span
 several lines
   and retains
  indentations.
MYFILE_EOF


cat > "my-file.txt" << 'MYFILE_EOF'
#!/bin/bash
echo use single quotes to prohibit subshells being evaluated.

limit=$(cat '/sys/fs/cgroup/memory/memory.limit_in_bytes')  # gets not evaluated upon write
usage=$(cat '/sys/fs/cgroup/memory/memory.usage_in_bytes')
remaining=$((limit - usage))
MYFILE_EOF

# using <<- is also possible. I miss to see the difference to <<
cat > "my-file.txt" <<- MYFILE_EOF
   This is the input of the file
  It can span
 several lines
   and retains
  indentations.
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

# less preferred
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

my_function() {
    local my_var=42  # local var does not leak outside function scope
    return "$my_var"
}


echo "Script file name: " "$0"
echo "Script's first parameter: " "$1"

my_function2() {
    echo "USAGE"
    echo "Script's file name: " "$0"
    echo "my_function2's first param" "$1"  # != $1 of the script
}
my_function2 "The first param given to the function"


# --------------------------------------------------------------------------------------------------
# Check if current computer is a Mac

if [ "$(uname)" == "Darwin" ]; then
    echo "we're on Mac"
elif [ "$(uname)" == "Linux" ]; then
    echo "we're on a Linux"
fi

# if echo $HOME | grep -q "/Users/"; then  # it's most probably a mac


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


chmod +x "${script_dir}/hooks"/*  # this works
chmod +x "${script_dir}/hooks/"*  # this does not

# --------------------------------------------------------------------------------------------------
# command line options

#consider following
my_script some input "some more input"
# or
my_function some input "some more input"


$* # refers to the input as a string - good in most cases
for a in $*; do
    echo $a; # prints five lines: some input some more input
done

for a in "$*"; do
    echo $a; # prints just one line
done


$@ # refers to the input as an array - good when you want to iterate over it
for a in "$@"; do
    echo $a;  # prints three lines: 'some' 'input' 'some more input'
done

for a in $@; do
    echo $a;  # prints five lines: 'some' 'input' 'some' 'more' 'input'
done

# short form: for a; do
for a; do
    echo $a;  # prints three lines: 'some' 'input' 'some more input'
done


# --------------------------------------------------------------------------------------------------
# command line option parsing -- naive -- it's so simple, don't do it

if [ "$1" == "" ]; then
    echo "my cmd arg not provided"
    exit 1
elif [ "$1" == "Hello" ]; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else"
fi

# --------------------------------------------------------------------------------------------------
# command line option parsing -- very simple with defaults -- very concice

myval="${1-mydefault}"
myotherval="${2-myotherdefault}"

# --------------------------------------------------------------------------------------------------
# command line option parsing -- very simple

# just for help
if [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
    show_help
fi

# cryptic but short
if [[ "$1" =~ ^(-h|--help)$ ]]; then
    show_help
    exit 0
fi

[[ "$1" =~ ^(-h|--help)$ ]] && die "$(show_help)" 0


# flexible & short but unstable, eg. when you call `./myscript please-helpme`
# bash has issues with word regexes with boundaries
if [[ "$*" =~ (-h|--help) ]]; then
    show_help
    exit 0
fi

# also:
my_cmd_arg="$1"
if [ "$my_cmd_arg" == "" ]; then
    echo "my cmd arg not provided"
elif [ "$my_cmd_arg" == "Hello" ]; then
    echo "my cmd arg is Hello"
else
    echo "my cmd arg is something else"
fi


# --------------------------------------------------------------------------------------------------
# command line option parsing -- simple and complete. I believe this is the best general way

logfile='default.log'
send_alive_pushover=false
while [ "$#" -gt 0 ]; do
    case "$1" in
    -a|--alive)
        send_alive_pushover=true
        ;;
    -f|--file)
        logfile="$2"
        shift # past argument
        ;;
    -y|--yesterday)
        logfile='yesterday.log'
        ;;
    --)
        shift
        command="$*"
        break
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main_arg="$1"
        ;;
    esac
    shift
done


# less elegant but allows for combined one-letter options in arbtrary order, like e.g. netstat tulpn
logfile='my.log'
send_alive_pushover=false
file=
args=()
while [ "$#" -gt 0 ]; do
    case "$1" in
    --alive)
        send_alive_pushover=true
        ;;
    -f|--file)
        logfile="$2"
        shift # past argument
        ;;
    --yesterday)
        logfile='yesterday.log'
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
    -[[:alnum:]]*)
        [[ "$1" =~ a ]] && send_alive_pushover=true
        [[ "$1" =~ y ]] && logfile='yesterday.log'
        ;;
    *)
        file="$1"
        shift
        args=("$@")
        break
        ;;
    esac
    shift # past argument or value
done

# --------------------------------------------------------------------------------------------------
# command line option parsing -- Getopt

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
# command line option parsing -- Getopts

# CAUTION: getopts, unlike getopt, can just understand short names like -p but not long name, e.g. --page
# CAUTION: Mac OS X uses bsd-getopt and behaves differently from Linux gnu-getopt

while getopts ":s:p:" o; do
    case "$o" in
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
[[ $# -gt 0 ]]; echo $#    # "new test" or "extended test" - less portable, but but more versatile, e.g. it can test whether a string matches a regular expression


cd ~
if [ $? != 0 ]; then
    echo 'Error!'  # does not go in here
fi

cd does/not/exist
if [ $? != 0 ]; then
    echo 'Error!'  # goes in here. I recommend this way to test $?. It works
fi

# test changes the last return value. if you test against several cases, use either switch or put
# the return value into a variable:
git pull --rebase origin master
code="$?"
if [ "$code" == 0 ]; then
    echo 'all good'
elif [ "$code" == 1 ]; then
    echo 'branch does not exist'
elif [ "$code" == 128 ]; then
    echo 'merge conflicts'
else
    echo 'unknown error'
fi


# --------------------------------------------------------------------------------------------------
# Printing

myvar=4
printf '%0.s=' $(seq 1 $myvar);  printf '\n'  # prints $myvar number of '='
printf '%-50s' 'gets trailing spaces until char 50'; printf 'another string starting after total 70 characters\n';

printf "$PWD"; printf '%0.s.' $(seq ${#PWD} 50 );  printf '\n'

printf "Pad the following number with up to 5 zeros %05d\n" 42;
printf "Pad the following number with up to 5 spaces %5d\n" 42;
printf "Pad some text%3s\n" Hi;


# --------------------------------------------------------------------------------------------------
# Coloring

# color codes; overwrite with empty string '' if you want to disable them dynamically
# The sheme appear to be combined values, with the 1st column definining form related things
# (bold/italic, etc) and the 2nd column defining colors. One can, however, apparently, omit
# columns.

# color codes
cyan='\e[1;36m'
red='\e[31m'
red='\e[0;31m'
green='\e[1;32m'
orange='\e[0;33m'
yellow='\e[1;33m'
nc='\e[m' # No Color
bold='\e[1m'

# or in short form
r='\e[31m'
g='\e[32m'
b='\e[1m'
rb='\e[1;31m'
n='\e[m'

# examples:
printf "\e[1mSOMETHING IN BOLD\e[m\n"
printf "\e[0;31mSOMETHING IN RED\e[m\n"
printf "\e[1;32mSOMETHING IN BOLD GREEN\e[m\n"
printf "\e[1;33mSOMETHING IN YELLOW\e[m\n"
printf "\e[0;33mSOMETHING IN DARK YELLOW\e[m\n"

# \e can also appear as \033, and apparently \x1b,but \e is shorter

# Print the 256 colors :)
for i in {0..15}; do
    for j in {0..15}; do
        ((c= j * 16 + i ));
        printf "\e[38;5;${c}m%3s" "$c";  # 38 apparently means foreground, 48 apparently means background
    done
    printf "\n";
done

# define the color codes only when the output is a capable tty
if [ -t 1 ]; then
    # if the current output is a terminal
    ncolors="$(tput colors)"
    if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        # if the terminal supports colors
        r='\e[31m'
        g='\e[32m'
        b='\e[1m'
        rb='\e[1;31m'
        n='\e[m'
    fi
fi

echo-error() {
    printf "${red}${*}${nc}\n"
}
echo-head() {
    printf "${cyan}${*}${nc}\n"
}
echo-ok() {
    printf "${green}${*}${nc}\n"
}
echo-warn() {
    printf "${yellow}${*}${nc}\n"
}

printf "%s${no_color}" "$line"  # prints a given string raw, i.e. with special characters like %

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

# with tput:
bold="$(tput bold)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

# You can't colorize text from printf given via %s, but via %s:
printf '%s\n' '\e[1mSOMETHING IN BOLD\e[m'  # doesn't work
printf '%b\n' '\e[1mSOMETHING IN BOLD\e[m'  # works; %b honor backslash escapes like \n or \e


# --------------------------------------------------------------------------------------------------
# Print a color palette
# found here: https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal

for ((i=16; i<256; i++)); do
    printf "\e[48;5;${i}m%03d" $i;  # apparently, 48 is for background colors, 38 would affect background colors
    printf '\e[0m';
    [ ! $(((i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
done


# --------------------------------------------------------------------------------------------------
# read - user keyboard input

read myvar  # read a line into myvar
read myvar othervar  # read the first word into myvar and the rest into othervar

read -e -n10 -p 'my prompt: ' value  # -e newline after input is read  -n10 capture 10 characters, no ENTER needed
read -t2 key  # read into key variable  with a 2 seconds timeout
read -rn1  # throwaway var  -n1: read 1 char; -r mangle backslashes: shellcheck likes it


read -p 'Please type your password: ' -rs pass;  # -r interpret backslashes verbatim; -s: input not prompted to command line; -s shows key symbol, if -n not specified

read -n1 -p 'Press any key to exit' -s; echo  # does not work with -e, therefore echo afterwards
trap "read -n1 -p 'Press any key to exit' -s; echo" EXIT


read -r -p $'Really?\nPress [ENTER] to continue or Ctrl-c to cancel.'  # $'...' enables ANSI C-style escape sequences in single(!) quotes


# --------------------------------------------------------------------------------------------------
# read a variable line by line.
while read -r line; do  # trims lines and trims trailing newlines
    echo '...' $line
done <<< "$some_multiline_string"

# OR

while IFS= read -r line; do  # declaring variable IFS empty configures read not to trim lines, but stil trims trailing newlines
    echo "..." $line
done <<< "$some_multiline_string"


# reading character-wise retains trailing newlines.
while IFS= read -rN1 character; do
    input_to_prepend+="$character"
done


# --------------------------------------------------------------------------------------------------
# Builtin aka faster way to read from stdin

myvar="$(</dev/stdin)"  # tructates trailing newlines


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

command -v  myprogram  # similar to `which`, but builtin, and thus generally preferred

command -v xcrun >/dev/null || die 'Xcode command line tools are mandatory'
command -v xcrun >/dev/null && echo 'Program exists, do something'


if command -v apt >/dev/null; then
    printf 'apt exists\n'
fi

if ! command -v brew >/dev/null; then
    printf 'brew does not exist\n'
fi


which myprogram  # search for binaries


whereis myprogram  # search for binaries and manpages
whereis -s myprogram  # search for sources
whereis -b myprogram  # search for binaries
whereis -m search for manpages  # search for manpages



# --------------------------------------------------------------------------------------------------
# read yes no ? or yes or no :)

# -r: don't mangle backslashes -e read line, i.e. go to next line after input is read
# [yY] is bash pattern matching https://www.gnu.org/software/bash/manual/bashref.html#Pattern-Matching
read -r -e -n1 -p 'Continue? [yY/nN]: ' yes_no
if [[ "$yes_no" == [yY] ]]; then
    echo 'You pressed Yes'
fi

read -r -e -n1 -p 'Continue? [yY/nN]: ' yes_no
if [[ "$yes_no" != [yY] ]]; then
    echo 'That is a No!'
    exit 1
fi

read -r -e -n1 -p 'Continue? [yY/nN]: ' yes_no
[[ "$yes_no" == [yY] ]] || (printf 'Cancel\n.'; exit 0 )


# --------------------------------------------------------------------------------------------------
# date

if [ $(date +%w) -eq 0 ]; then
    echo "date +%w  prints weekday with 0 being Sunday"
fi


now="$(date '+%Y-%m-%d--%H-%M-%S')"  # human readable and parseable format
now="$(date +%s)"  # timestamp in seconds since epoch; good for comparisons


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


n=0
let "n++"  # n == 1


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
sudo sed -i "/${begin_section_line}/,/${end_section_line}/d" "$hosts_file_path";
printf "$hosts_file_section" | sudo tee -a "$hosts_file_path";
# OR for normal user files:
hosts_file_path="/etc/hosts";
sed -i "/${begin_section_line}/,/${end_section_line}/d" "$hosts_file_path";
printf "$hosts_file_section" >> "$hosts_file_path";

# --------------------------------------------------------------------------------------------------
# templates text files and set the variables later

template_file="my-template.txt"  # contains arbitrary content with ${placeholder_1} and ${placeholder_2}

placeholder_1="Katze"  # will be replaced accordingly
placeholder_2="Hundi"

text_template="$(<"${template_file}")"
# text_template="$(cat ${template_file})"  # same but slower
text="$(eval "echo \"${text_template}\"")"  # eval echo evaluates the variables found in TEMPLATE_FILE

echo "$text_template"  # plain template text
echo "$text"  # text with templates substituted with the variables's values


# --------------------------------------------------------------------------------------------------
# idioms and caveats

# When using user defined functions with `find`'s `-exec` `-execdir` and so on
# you have to call the function using `bash -c`
my_function_called_by_find() {
    printf "Hi \e[1m${PWD}\e[0m\n"
}
export -f my_function_called_by_find  # since the subshell should you open below in find
                                      # should know about the function, you have export -f it

find . -maxdepth 3 -type d -iname "*.git" -execdir bash -c 'my_function_called_by_find' '{}' \;

# --------------------------------------------------------------------------------------------------
# emulating ternary operator with boolean concatenation

test "$1" == '--moo' && is_moo='yes' || is_moo='no'


# --------------------------------------------------------------------------------------------------
# a nice and readable way to abstract variables to booleans

is_moo="$(test "$1" == '--moo'; echo ${?})"
if [ "$is_moo" -eq "0" ]; then
    echo 'Mooooo'
fi


# --------------------------------------------------------------------------------------------------
# Temporary dirs - possible workflow

tmp_dir="$(mktemp -d)"
cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

cd "$tmp_dir"
# ...

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
myfile_charset="$(file -i "$myfile" | awk '{print $3}' | grep 'charset=binary')"
if [[ $? -eq 0 ]]; then
    echo "${myfile} is a binary file: ${myfile_charset}"
else
    echo "${myfile} is not a binary file: ${myfile_charset}"
fi


# grep to a variable and retain lines, e.g. for further grepping
current_results=$(grep -i '#snippet' "$data_file")
printf '%s' "$current_results"  | grep -i 'hello' # using '%s'  retains possible \n characters in
                                                    # the content, i.e. they are given as \n as
                                                    # opposed to break lines like  printf
                                                    # "$current_results"  would do


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
increment_count() {

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

# Checks if the given unix system is a mac by checking the home directory
# There are other ways, but this is one.
# .
check_if_this_computer_is_a_mac() {
    if echo $HOME | grep -v -q "/Users/"; then  # grep -q: quiet
        echo "we're not on mac"
    else
        echo "we're on mac"
    fi
}

# Checks if the given unix system is a mac by checking the home directory
# There are other ways, but this is one.
# .
check_if_this_computer_is_a_mac_2() {
    if [ "$(uname)" != "Darwin" ]; then
        printf "we're not on mac\n"
    else
        printf "We're on Mac\n"
    fi
}

# Checks if the given folder is empty.
# Beware of whitespaces, maybe.
# .
is_folder_empty() {
    if [ -z "$(ls -A "$1")" ]; then
        printf 'given folder is empty\n'
    else
        printf 'given folder is NOT empty\n'
    fi
}

# taken from: https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash
write_find_output_into_array() {
    array=()
    while IFS=  read -r -d $'\0'; do
        array+=("$REPLY")
    done < <(find . -type d -print0)
}

# Prints the number of occurences of a given substring $1 in a given string $2.
# Found on:  https://stackoverflow.com/questions/26212889/bash-counting-substrings-in-a-string
count_occurences_of_substring_in_string() {
    local recuced_string=${2//"$1"}
    echo "$(((${#2} - ${#recuced_string}) / ${#1}))"
}

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
generate_random_pronounceable_word() {

    local word_length="$1"
    local num_consonants_since_last_vovel=0
    local random_word
    for v in $(seq 1 "$word_length"); do
        if [[ num_consonants_since_last_vovel -ge 2 ]] || [[ $(((RANDOM%3))) -eq 0 ]]; then
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

    printf '%s\n' "$random_word"
}


# bulk-edit / id3 tag a music album
set_id3_tags() {
    artist='Sarah Jaffe'
    album="The Body Wins"
    year=2012

    track_number=1
    for file in *.mp3; do
      id3v2 --artist "$artist" --album "$album" --year="$year" --track "$track_number" "$file"
      track_number=$((track_number + 1))
    done
}


# --------------------------------------------------------------------------------------------------
# show usage  - show usage, but no help

#() {
    script_name="${0##*/}"

    msg="Usage:\n\n"
    msg+="  ${script_name} <search-pattern> <file-pattern>...\n"
    msg+="\n"
    msg+="Examples:\n\n"
    msg+="  ${script_name} 'foo' *.sh            # explain a bit in plain text here\n"
    # shellcheck disable=SC2059
    printf "$msg"
}

# --------------------------------------------------------------------------------------------------
# show_help  - show help string and usage

show_help() {
    script_name="${0##*/}"

    msg="${script_name}\n"
    msg+="Replace strings in files in a directory tree.\n"
    msg+="\n"
    msg+="Usage:\n\n"
    msg+="  ${script_name} <search-pattern> <file-pattern>...\n"
    msg+="\n"
    msg+="Examples:\n\n"
    msg+="  ${script_name} 'foo' *.sh            # explain a bit in plain text here\n"
    # shellcheck disable=SC2059
    printf "$msg"
}


show_help() {
    script_name="${0##*/}"

    msg="${script_name}\n"
    msg+="Replace strings in files in a directory tree.\n"
    msg+="\n"
    # shellcheck disable=SC2059
    printf "$msg"
    show_usage
}

# --------------------------------------------------------------------------------------------------
# have a die function

{ >&2 printf 'Error: MyMessage'; exit 1; }


# simple
die() {
    >&2 printf '%s\n' "$*"
    exit 1
}

# elaborate, flexible
die() {
    >&2 printf '%s\n' "$1"
    exit "${2:-1}"
}

[ -z "$version" ] && die "Version string must not be empty"    # use like this, for example


# --------------------------------------------------------------------------------------------------
# Compare semantic versions

# Check whether the second given semantic version is at least as big as the
# first given semantic version.
#
# Usage:
# version_lte 3.8 3.9   # returns true
# version_lte 3.8 3.8   # returns true
# version_lte 3.8.1 3.8   # returns false
# version_lte 4 3.1.2   # returns false
version_lte() {
    [ "$1" = "$(printf "%s\n%s" "$1" "$2" | sort -V | head -n1)" ]
}

# use it for python version checking
min_python_version='3.8'
python_version="$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")"

version_lte "$min_python_version" "$python_version" && echo compatible || echo incompatible

# --------------------------------------------------------------------------------------------------
# CURL

curl \
  --request POST \
  --data '{"service_id": "ovs_shz","store": "SHZ"}' \
  https://api-proxy.shz.de/celeraone/user/register


# --------------------------------------------------------------------------------------------------
# Convert a string into a viable filename.
slugify() {
    sed -E 's/[^_a-zA-Z0-9-]+/-/g;s/^-+|-+$//g;s/./\L&/g' <<< "$*"
}

# --------------------------------------------------------------------------------------------------
# remove a folder from variable safely
# without running the risk that an unitialized variable could cause deletion of most of your system

rm -rf "${mydir:?}/"  # if mydir is empty or not set, bash will issue a message `mydir: parameter null or not set`


# --------------------------------------------------------------------------------------------------
# GPG

gpg --full-gen-key  # interactive; best for learning; leave PW empty for no passphrase security

# non-interactive way
gpg --batch --generate-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: my-key42
Name-Email: andreasl@example.com
Expire-Date: 0
EOF

# --------------------------------------------------------------------------------------------------
# PID

# process ID
echo "Current PID ${$}"

# parent process ID
ps -o ppid= $$
