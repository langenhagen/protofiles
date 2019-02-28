# --------------------------------------------------------------------------------------------------
# for loops

for f in *.c
    echo "> $f"
end


for a in (abbr --list)
    abbr --erase $a
end