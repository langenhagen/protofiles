# author: langenhagen
# version: 17-11-17

# --------------------------------------------------------------------------------------------------
# set -e and +e
# see https://www.quora.com/What-is-the-difference-between-set-+e-and-set-e-in-a-bash-script

set -e      # On error, the script normally barfs out to the system. basically the default:
set +e      # any errors that occur down the line will NOT cause the script to exit, the script will keep running

# --------------------------------------------------------------------------------------------------
# Variables

export GLOBAL_VARIABLE="HELLO"
local_variable=World


# --------------------------------------------------------------------------------------------------
# for Loops

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

if [ "$expressions" = 'should_be_evaluated_either_by_test_or_wrapped_into_square_brackets' ]; then
    # ...
fi

if commands_should_not_go_into_square_brackets ; then
    # ...
fi


if [ "$1" == "staging" ]  || [ "$1" == "stage" ]; then
    echo "if"
else
    echo "else"
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

function myFunction {
    local my_var=42
    return $my_var
}


# --------------------------------------------------------------------------------------------------
# Check if current computer is a Mac

function check_if_this_computer_is_a_mac {
    if echo $HOME | grep -v -q "/Users/" ; then
        echo "we're not on mac"
    else
        echo "we're on mac"
    fi
}


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
# getopt

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
        -a|--arch)
            ARCHITECTURE="$2"
            shift 2
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
# command line parsing -- simple

android_abi=x86_64                              # with default value
android_platform=${DEFAULT_ANDROID_PLATFORM}
cmake_build_suffix=                             # without default value
cmake_prefix=${DEFAULT_CMAKE_PREFIX}
cmake_target=${DEFAULT_CMAKE_TARGET}
while [[ $# -gt 0 ]] ; do
    key="$1"
    case $key in
    --cmake-build-suffix)
        cmake_build_suffix="$2"
        shift # past argument
        ;;
    --cmake-prefix)
        cmake_prefix="$2"
        shift # past argument
        ;;
    --cmake-target)
        cmake_target="$2"
        if [ "${cmake_target}" != "${DEFAULT_CMAKE_TARGET}" ] ; then
            echo "WARNING"
        fi
        shift # past argument
        ;;
    --android-abi)
        android_abi="$2"
        shift # past argument
        ;;
    --android-platform)
        android_platform="$2"
        if [ "${android_platform}" != "${DEFAULT_ANDROID_PLATFORM}" ] ; then
            echo "WARNING"
        fi
        shift # past argument
        ;;
    -h|--help)
        usage
        shift # past argument
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
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

[  "hallo" ]; echo $?           # prints 0
[  "" ]; echo $?                # prints 1