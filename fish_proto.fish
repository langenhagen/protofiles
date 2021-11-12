# --------------------------------------------------------------------------------------------------
# for loops

for f in *.c
    echo "> $f"
end


for a in (abbr --list)
    abbr --erase $a
end

# --------------------------------------------------------------------------------------------------
# variables

set myvar 23

set -lx PIP_REQUIRE_VIRTUALENV false  # temporary env var; -l|--local: local -x|--export: export;
