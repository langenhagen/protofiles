# Prototypical statements for the json-processing command line tool `jq`.
#
# author: andreasl

###############################################################################
# command line args

# jq -r   # remove quotation marks from output; don't parse input as json, instead, each line is passed to the filter as a string.

###############################################################################
# treat an array of jsons as several individual jsons

cat myarrayfile.json | jq '.[]'  # many json objects, without comma between them


###############################################################################
# select stuff and filter

cat myarrayfile.json | jq -r '.[] | .location'   # get the location fields without quotation marks

cat myarrayfile.json | jq '.[] | select(.state == "some_state") | "\(.loc), \(.sku)"'


###############################################################################
# get distinct values
cat myfile.json | jq 'map(.myfield) | unique'  # jq-ish way
cat myarrayfile.json | jq '.[] | .state' | sort -u  # bash-y way


###############################################################################
# count

# count array lenghts
cat myarrayfile.json | jq 'map(.myfield) | unique | length'


###############################################################################
# grouping

# group all json objects with the same value for `myfield` into arrays, yielding several arrays
cat myarrayfile.json| jq 'group_by(.myfield)'
