-------------------------------------------------------------------------------
-- comments :)

-- that's a single line comment

-------------------------------------------------------------------------------
-- query data

SELECT * FROM my_table
SELECT mycol1, mycol3 FROM my_table
SELECT mt.mycol1, mt.mycol3 FROM my_table mt

SELECT mycol1, mycol3 FROM my_table WHERE mycol2 = "some value"

-------------------------------------------------------------------------------
-- get all distinct values in a column

SELECT DISTINCT mt.mycol FROM mytable mt WHERE mt.myothercol = "miau"
