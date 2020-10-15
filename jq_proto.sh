# Prototypical statements for the json-processing command line tool `jq`.
#
# author: andreasl

# select stuff and filter
cat 'myfile.json' | jq -r '.[] | select(.state == "some_state") | "\(.loc), \(.sku)"'

# get distinct values
cat myfile.json | jq -r 'map(.myfield) | unique'  # jq-ish way
cat myfile.json | jq -r '.[] | .state' | sort -u  # bash-y way

