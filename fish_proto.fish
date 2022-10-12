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
    du -sh myfile;
    echo;
    sleep 5;
end


# --------------------------------------------------------------------------------------------------
# variables

set myvar 23

set -lx PIP_REQUIRE_VIRTUALENV false  # temporary env var; -l|--local: local -x|--export: export;
