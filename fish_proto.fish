# --------------------------------------------------------------------------------------------------
# for loops

for f in *.c
    echo "> $f"
end


for a in (abbr --list)
    abbr --erase $a
end

for i in (seq 10)
    echo "$i"
end

# --------------------------------------------------------------------------------------------------
# while loops

while true;
    clear -x;
    du -sh *.ts;
    sleep 5;
end


# --------------------------------------------------------------------------------------------------
# variables

set myvar 23

set -lx PIP_REQUIRE_VIRTUALENV false  # temporary env var; -l|--local: local -x|--export: export;


# --------------------------------------------------------------------------------------------------
# arrays

set my_array value1 value2 value3

set my_array[1] value4  # fish arrays are 1-indexed
set my_array[2] value5
set my_array[3] value6

echo "the array: $my_array"         # value4 value5 value6
echo "at index 2: $my_array[2]"     # value5; fish arrays are 1-indexed
echo "at index 99: $my_array[99]"   # emptpy, no error

for item in $my_array
    echo "> $item"
end



# --------------------------------------------------------------------------------------------------
# functions

function say_hi
    echo "Hi $argv"
    echo "ftr: $argv[1]"  # fish array indices start at 1
end

say_hi
say_hi everbody!
say_hi you and you and you


# --------------------------------------------------------------------------------------------------
# tests

test (random) -eq 1 && echo 'yay!'

# --------------------------------------------------------------------------------------------------
# read  -  read is a little bit different in fish than in Bash

read -P 'print this string'  # -P is equivalent to -p in Bash
