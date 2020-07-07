// -------------------------------------------------------------------------------------------------
// connecting

// bash
mongo localhost:30000  // connect to mongo which sits on port 3000
mongo localhost:30000/my_db  // connect to the mongodb and directly connect to the catabase my_db


// -------------------------------------------------------------------------------------------------
// run a script against the mongodb

// bash
mongo --quiet myscript.js

// -------------------------------------------------------------------------------------------------
// dbs
db.runCommand( { isMaster: 1 } )

db   // show the current database
db.getSiblingDB('mydb')  // switch to mydb
use other_db  // switch to mydb; shortcut


// delete a db
use my_db
drop my_db

// -------------------------------------------------------------------------------------------------
// collections

db.getCollectionNames()  // show collections in current db
show collections         // show collections in current db shortcut

db.getCollection('purchases').updateMany({'conversion_source':'SWG'},{$set:{'conversion_source':'subscribe_with_google'}})
db.getCollection('purchases').find({'conversion_source':'SWG'})
db.getCollection('purchases').find({'conversion_source':'subscribe_with_google'})

db.mycollection.drop()  // delete the collection mycollection and its contents

// -------------------------------------------------------------------------------------------------
// find

db.inventory.find({})  // find all
db.inventory.find({}).pretty()   // find all, pretty print

// -------------------------------------------------------------------------------------------------
// scripting
// shortcuts don't work in scripts
// see: https://docs.mongodb.com/manual/tutorial/write-scripts-for-the-mongo-shell/

conn = new Mongo()     // boilerplate
db = conn.getDB("test")

out = db.adminCommand('listDatabases')  // equiv to `show dbs``
printjson(out)

db = db.getSiblingDB('mynewdb')   // create&switch to mynew to `use mynewdb``
print(db)

db.mycollection.insertMany([
   { item: "journal", qty: 25, status: "A", size: { h: 14, w: 21, uom: "cm" }, tags: [ "blank", "red" ] },
   { item: "notebook", qty: 50, status: "A", size: { h: 8.5, w: 11, uom: "in" }, tags: [ "red", "blank" ] },
   { item: "paper", qty: 10, status: "D", size: { h: 8.5, w: 11, uom: "in" }, tags: [ "red", "blank", "plain" ] },
   { item: "planner", qty: 0, status: "D", size: { h: 22.85, w: 30, uom: "cm" }, tags: [ "blank", "red" ] },
   { item: "postcard", qty: 45, status: "A", size: { h: 10, w: 15.25, uom: "cm" }, tags: [ "blue" ] }
]);

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