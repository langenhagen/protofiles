----------------------------------------------------------------------------------------------------
-- comments :)

-- that's a single line comment

----------------------------------------------------------------------------------------------------
-- pitfalls

-- apparently, postgres wants single quotes; best use single quotes

----------------------------------------------------------------------------------------------------
-- meta administrative stuff

select sqlite_version();


----------------------------------------------------------------------------------------------------
-- administrative stuff - groups and users


export PGPASSWORD=pass  # in bash; a way to set the PostgreSQL password via env variable


CREATE GROUP my_group
SELECT groname FROM pg_group;  -- show groups

DROP GROUP my_group

CREATE USER my_user WITH PASSWORD 'test123' IN GROUP my_group
\du  -- in postgres, list users


REVOKE CONNECT ON DATABASE postgres FROM PUBLIC  -- disable group PUBLIC users access to database `postres`


----------------------------------------------------------------------------------------------------
-- show permissions

-- mysql for current user
SHOW GRANTS


----------------------------------------------------------------------------------------------------
-- show the running queries

show processlist

----------------------------------------------------------------------------------------------------
-- the interactive fundamentals

show databases  -- mysql
\list           -- in postgres show databases,
\l              -- in postgres, show databases
\l+             -- in postgres, show databases with extra info

use mydatabase  -- also important in sql scripts
\c              -- use database in postgres

show tables
\dt            -- show tables in postgres
.tables        -- show tables in sqlite

describe mytable  -- show meta information about the table
\d mytable        -- in postgres, describe the table
desc mytable  -- short form of describe mytable
.schema mytable -- sqlite similar to describe; shows how the table was created; don't add a semicolon to this command
pragma table_info(skill_iteration);  -- sqlite similar to describe; get info about table's columns


.indexes  -- list indexes in SQLite


----------------------------------------------------------------------------------------------------
-- database fundamentals

CREATE DATABASE mydb
DROP DATABASE mydb

----------------------------------------------------------------------------------------------------
-- types

bool        -- tinyint(1)
tinyint(1)  -- same as bool

----------------------------------------------------------------------------------------------------
-- table fundamentals

CREATE TABLE mytable (
    user_id serial PRIMARY KEY,
    username VARCHAR ( 50 ) UNIQUE NOT NULL,
    password VARCHAR ( 50 ) NOT NULL,
    email VARCHAR ( 255 ) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

DROP TABLE mytable;

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

select token, uuid from skills where token in ('andi','mandi','sugar','candy');


----------------------------------------------------------------------------------------------------
-- postgres query JSON
-- https://www.postgresql.org/docs/9.5/functions-json.html

SELECT mycol -> 'my_jsonkey' -> 'my_nested_json_key' ->> 69 FROM mytable  -- postgres select a nested JSON array at index 69


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
-- insertion of rows

INSERT INTO mytable (name) VALUES ("Arthur");
INSERT INTO mytable (name, type) VALUES ('MyName','g00d');
INSERT INTO mytable (name, type) VALUES ('MyName','g00d'),('OtherName','b4d');


-- long version with fields specified
INSERT INTO events (
    aggregate_id,
    timestamp,
    body
)
VALUES (
    '83f7fd3a-51fe-4ec0-80ca-ad4d3f2c0dcd',         -- apparently postgres wants single quotes ' '
    '2019-09-22T23:07:01',
    '{"this":"is", "my":2, "friend":{"jason":[1,2,3,5]}}'
)

-- short version
INSERT INTO events VALUES (
    '83f7fd3a-51fe-4ec0-80ca-ad4d3f2c0dcd',
    '2019-09-22T23:07:01',
    '{"this":"is", "my":3, "friend":{"jake":[6,7,8]}}'
)

INSERT INTO my_table SELECT * FROM other_table;  -- insert results from a select query


----------------------------------------------------------------------------------------------------
-- update rows

UPDATE mytable SET name = 'Damian', city = 'Berlin' WHERE customer_id = 666;

UPDATE alembic_version SET version_num = '448f011cf715';


----------------------------------------------------------------------------------------------------
-- deletion

DELETE FROM mytable                -- delete everything from mytable
DELETE FROM mytable mt WHERE mt.mycol = 'nooo'

----------------------------------------------------------------------------------------------------
-- alter table

ALTER TABLE mytable DROP COLUMN mycolumn;  -- doesn't work with asncient SQLite DBs.


ALTER TABLE mytable ADD COLUMN mycolumn VARCHAR(15);


ALTER TABLE mytable
    DROP COLUMN mycolumn,
    ADD COLUMN column_name VARCHAR(16);


-- rename a column in old MySQL
ALTER TABLE mytable
    CHANGE oldcolname newcolname varchar(20);


-- rename a column in common new SQL
ALTER TABLE mytable
    RENAME COLUMN oldcolname TO newcolname;


----------------------------------------------------------------------------------------------------
-- get the currnt time

select Now();  -- postres



----------------------------------------------------------------------------------------------------
-- extensions

\dx -- show extensions in postrges
select * FROM pg_extension; -- show extension in postrges via sql code
select * FROM pg_available_extensions  -- show available extensions in postrges


create extension "uuid-ossp";
create extension if not exists "uuid-ossp";
