-------------------------------------------------------------------------------
-- comments :)

-- that's a single line comment

-------------------------------------------------------------------------------
-- the interactive fundamentals

show databases

use mydatabase  -- also important in sql scripts

show tables

DESCRIBE mytable  -- show meta information about the table
DESC mytable  -- short form of DESCRIBE mytable

-------------------------------------------------------------------------------
-- query data

SELECT * FROM mytable
SELECT mycol1, mycol3 FROM mytable
SELECT mt.mycol1, mt.mycol3 FROM mytable mt

SELECT mycol1, mycol3 FROM mytable WHERE mycol2 = "some value"

SELECT * FROM mytable WHERE mycol2 = "some value" AND myothercol != 42

SELECT * FROM mytable WHERE mycol LIKE "%jack%jones%"   -- case insensitive


-------------------------------------------------------------------------------
-- get all distinct values in a column

SELECT DISTINCT mt.mycol FROM mytable mt WHERE mt.myothercol = "miau"


-------------------------------------------------------------------------------
-- variables

SET @my_variable = "%jack%jones%";

SELECT * FROM my_brands abb WHERE brand LIKE @my_variable;


-------------------------------------------------------------------------------
-- instertion of rows

INSERT INTO mytable (brand, pic_url) VALUES ('Wildling','Wildling.png')

-------------------------------------------------------------------------------
-- deletion

DELETE FROM mytable                -- delete everything from mytable
DELETE FROM mytable mt WHERE mt.mycol = "nooo"
