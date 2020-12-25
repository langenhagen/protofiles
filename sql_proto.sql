----------------------------------------------------------------------------------------------------
-- comments :)

-- that's a single line comment

----------------------------------------------------------------------------------------------------
-- pitfalls

-- apparently, postgres wants single quotes

----------------------------------------------------------------------------------------------------
-- administrative stuff - groups and users

CREATE GROUP my_group
SELECT groname FROM pg_group;  -- show groups

DROP GROUP my_group

CREATE USER my_user WITH PASSWORD 'test123' IN GROUP my_group
\du  -- in postgres, list users


REVOKE CONNECT ON DATABASE postgres FROM PUBLIC  -- disable group PUBLIC users access to database `postres`



----------------------------------------------------------------------------------------------------
-- the interactive fundamentals

show databases  -- mysql
\list           -- in postgres show databases,
\l              -- in postgres, show databases
\l+             -- in postgres, show databases with extra info

use mydatabase  -- also important in sql scripts

show tables
\dt            -- in postgres show tables

DESCRIBE mytable  -- show meta information about the table
DESC mytable  -- short form of DESCRIBE mytable

----------------------------------------------------------------------------------------------------
-- database fundamentals

CREATE DATABASE mydb
DROP DATABASE mydb

----------------------------------------------------------------------------------------------------
-- table fundamentals

CREATE TABLE accounts (
    user_id serial PRIMARY KEY,
    username VARCHAR ( 50 ) UNIQUE NOT NULL,
    password VARCHAR ( 50 ) NOT NULL,
    email VARCHAR ( 255 ) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

DROP TABLE mytable

----------------------------------------------------------------------------------------------------
-- table types

varchar ( <n> ) -- variable length char of max length <n>
serial          -- autoincrement posgres
json            -- postgres
jsonb           -- posgre, better json type


CREATE TYPE my_type AS ENUM ('good', 'bad', 'yippie');  -- enum type in postgres


----------------------------------------------------------------------------------------------------
-- query data

SELECT * FROM mytable
SELECT mycol1, mycol3 FROM mytable
SELECT mytable.mycol1, mytable.mycol3 FROM mytable
SELECT mt.mycol1, mt.mycol3 FROM mytable mt

SELECT mycol1, mycol3 FROM mytable WHERE mycol2 = "some value"   -- where
SELECT * FROM mytable WHERE mycol2 = "some value" AND myothercol != 42  -- where with 2 conditions

SELECT * FROM mytable WHERE mycol LIKE "%jack%jones%"   -- match strings case insensitive

SELECT name, lastname from students WHERE name BETWEEN "A" AND "N"  -- check ranges with BETWEEN

SELECT mycol -> 'my_jsonkey' -> 'my_nested_json_key' -> 69 FROM mytable  -- postgres select a nested JSON array at index 69


----------------------------------------------------------------------------------------------------
-- count rows

SELECT COUNT(*) FROM mytable
SELECT COUNT(DISTINCT weekday) FROM birthdays   -- likely yields 7


----------------------------------------------------------------------------------------------------
-- get all distinct values in a column

SELECT DISTINCT mt.mycol FROM mytable mt WHERE mt.myothercol = "miau"


----------------------------------------------------------------------------------------------------
-- variables

SET @my_variable = "%jack%jones%";

SELECT * FROM my_brands abb WHERE brand LIKE @my_variable;


----------------------------------------------------------------------------------------------------
-- instertion of rows

INSERT INTO mytable (brand, pic_url) VALUES ("Wildling","Wildling.png")

INSERT INTO events (
    aggregate_id,
    timestamp,
    body
)
VALUES (
    '83f7fd3a-51fe-4ec0-80ca-ad4d3f2c0dcd',             -- apparently posgre wanta single quotes ' '
    '2019-09-22T23:07:01',
    '{"this":"is", "my":2, "friend":{"jason":[1,2,3,5]}}'
)


----------------------------------------------------------------------------------------------------
-- update rows

UPDATE mytable SET name = "Damian", city = "Berlin" WHERE customer_id = 666;


----------------------------------------------------------------------------------------------------
-- deletion

DELETE FROM mytable                -- delete everything from mytable
DELETE FROM mytable mt WHERE mt.mycol = "nooo"
