// -------------------------------------------------------------------------------------------------
// connecting and connection to Mongo

// bash
mongo localhost:30000  // connect to mongo which sits on port 3000
mongo localhost:30000/my_db  // connect to the mongodb and directly connect to the catabase my_db


conn = new Mongo()      // create a Mongo instance
db = conn.getDB("mydb") // get or create a db
db.getSiblingDB("mynewdb")   // equiv to conn.getDB("mydb");

conn.getDBNames()  // retrieve an array of all db names
conn.getDBNames().indexOf("mydb")  // query mydb's index from list; -1 if mydb doesn't exist
conn.adminCommand("listDatabases")  // json info about databases; similar to shortcut `show dbs`

// -------------------------------------------------------------------------------------------------
// dbs

db.getMongo()  // get Mongo instance; get information about the connection

db.runCommand("isMaster")      // get info about the current mongo instance in the group
db.runCommand( { isMaster: 1 } )    // same as  db.runCommand("isMaster")
db.runCommand("isMaster").ismaster  // true or false

if (!db.runCommand("isMaster").ismaster) {
    print("Is not master!");
    exit;
}

db   // show the current database
db = db.getSiblingDB('mydb')  // get or create mydb; eqiov to conn.getDB("mydb")
use mydb  // shortcut for conn.getDB("mydb") switch to mydb


// delete a db
use my_db
drop my_db

// -------------------------------------------------------------------------------------------------
// collections

db.getCollectionNames()  // show collections in current db
show collections  // shortcut for db.getCollectionNames()
db.getCollectionNames().indexOf("mycollection")  // query mycollection's index from list; -1 if mycollection doesn't exist

db.createCollection("mycollection")  // create a collection

db.mycollection  // access (possibly yet non-existing) collection mycollection
db.getCollection("mycollection")  // same as db.mycollection

db.mycollection.find({})  // find all items in mycollection
db.mycollection.find({"my_field": "my_value"})  // find all items that match the criterion

db.mycollection.updateMany({'my_field':'my_value'},{$set:{'some_field':'some_new_value'}})  // update the fields of the items to which the filter applies


db.mycollection.drop()  // delete the collection mycollection and its contents

// -------------------------------------------------------------------------------------------------
// find

db.mycollection.find({})  // find all
db.mycollection.find({}).pretty()   // find all, pretty print
db.mycollection.find({}).pretty().toArray()   // find all, pretty print, to array, e.g. to iterate over them
db.mycollection.find({}).pretty().toArray().length   // get the number of found items
db.mycollection.find({}).length()  // shortcut equiv to db.mycollection.find({}).pretty().toArray().length

// -------------------------------------------------------------------------------------------------
// scripting get input

// -------------------------------------------------------------------------------------------------
// scripting
// - shortcuts don't work in scripts
// see: https://docs.mongodb.com/manual/tutorial/write-scripts-for-the-mongo-shell/

// bash
mongo  // start a repl
mongo --quiet myscript.js  // run a script against mongodb
mongo --eval "var myarg = 'Fooo'" myscript.js  // run a script with a cli argument
mongosh  // more convenient node.js-powered repl with syntax highlighting & node-module support; doesn't support running script files


args = JSON.parse(cat("config.json")); // load settings from an external file; mongo doesn't support cli-args, other than via --eval

conn = new Mongo();
db = conn.getDB("c1_cre");
if (conn.getDBNames().indexOf(db) == -1) {
    print("Error: Database `c1_cre` doesn't exist.");
    quit(1);
}
if (!db.runCommand("isMaster").ismaster) {
    print("Error: Is not master.");
    quit(2);
}

collectionName = "sso_page_template";
if (db.getCollectionNames().indexOf("sso_page_template") == -1) {
    print("Error: Collection `" + collectionName + "` does not exist.");
    quit(3);
}





out = conn.adminCommand("listDatabases")  // json info about databases; similar to shortcut `show dbs`
printjson(out)

db = db.getSiblingDB("mynewdb")   // create & switch to mynewdb; equiv to conn.getDB("mynewdb"); equiv to `use mynewdb``
print(db)


db.mycollection.insertMany([
   { item: "journal", qty: 25, status: "A", size: { h: 14, w: 21, uom: "cm" }, tags: [ "blank", "red" ] },
   { item: "notebook", qty: 50, status: "A", size: { h: 8.5, w: 11, uom: "in" }, tags: [ "red", "blank" ] },
   { item: "paper", qty: 10, status: "D", size: { h: 8.5, w: 11, uom: "in" }, tags: [ "red", "blank", "plain" ] },
   { item: "planner", qty: 0, status: "D", size: { h: 22.85, w: 30, uom: "cm" }, tags: [ "blank", "red" ] },
   { item: "postcard", qty: 45, status: "A", size: { h: 10, w: 15.25, uom: "cm" }, tags: [ "blue" ] }
]);

db.getCollection('mycollection').find({}).pretty().toArray();
out = db.mycollection.find({}).pretty().toArray();
printjson(out)

// -------------------------------------------------------------------------------------------------
// exporting data from a db to a file

// bash
mongoexport --host '127.0.0.1' --port 30005 --db=c1_cip -c config  -o mongodb_c1_cip_exports/config.json
mongoexport --host '127.0.0.1' --port 30005 --db=c1_cip -c purchase -o mongodb_c1_cip_exports/purchase.json
mongoexport --host '127.0.0.1' --port 30005 --db=c1_cip -c purchases -o mongodb_c1_cip_exports/purchases.json


// -------------------------------------------------------------------------------------------------
// stuff

// retrieve distinct interval_sizes on the problematic timeframe
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1546297200000. $lt: 1547161200000 }}) // Jan 01-10 ->[ 3600000 ]
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1547942400000, $lt: 1548374400000 }}) // Jan 20-25 -> [ 3600000 ]
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1548374400000, $lt: 1548547200000 }}) // Jan 25-27 -> [ 3600000 ]
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1548547200000, $lt: 1548633600000 }}) // Jan 27-28 -> [ 3600000 ]
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1548633600000, $lt: 1548720000000 }}) // Jan 28-29 -> [ 3600000 ]
db.metric_traffic_per_channel.distinct("interval_size",{shop:"RHP", timestamp: {$gt:1548720000000, $lt: 1548806400000 }}) // Jan 29-30 -> [ 3600000, 86400000 ]