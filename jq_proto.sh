# Prototypical statements for the json-processing command line tool `jq`.
#
# author: andreasl

###############################################################################
# command line args

# jq -r   # don't parse input as json, instead, each line is passed to the filter as a string.

###############################################################################
# select stuff and filter

cat myfile.json | jq '.[] | select(.state == "some_state") | "\(.loc), \(.sku)"'

###############################################################################
# get distinct values
cat myfile.json | jq 'map(.myfield) | unique'  # jq-ish way
cat myfile.json | jq '.[] | .state' | sort -u  # bash-y way

###############################################################################
# count

# count array lenghts
cat myarrayfile.json | jq 'map(.myfield) | unique | length'


###############################################################################
# grouping

# group all json objects with the same value for `myfield` into arrays, yielding several arrays
cat myarrayfile.json| jq 'group_by(.myfield)'
