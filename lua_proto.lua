----------------------------------------------------------------------------------------------------
-- conditional statements


if meu_valor ~= 0 then  -- ~= is not equals !=
    -- meu_valor is not 0
end


----------------------------------------------------------------------------------------------------
-- tables

t = {}    -- construct an empty table and assign it to variable "t"LU

t["foo"] = 123
t[3] = "bar"
t["foo"] -- prints 123
t[3] -- prints bar
t["unassigned"] -- returns nil


#t  -- length of the table/array

table.insert(t, "something")


----------------------------------------------------------------------------------------------------
-- string concatenation

url = url .. '?store_id=' .. store_id


missing = {}


----------------------------------------------------------------------------------------------------


a = {}


end
print(table.getn(a))         --> (number of lines read)

----------------------------------------------------------------------------------------------------
-- string manipulation


string.gsub("banana", "(an)", "%1-")    -- capture any occurences of "an" and replace
-- returns   ban-an-a
string.gsub("banana", "a(n)", "a(%1)")  -- brackets around n's which follow a's
-- returns   ba(n)a(n)a
string.gsub("banana", ",", ",\n") -- reverse any "an"s
-- returns  bnanaa

----------------------------------------------------------------------------------------------------
-- idioms / recipies

-- generates a (pretty) printed jsonified dict
string.gsub(require('cjson').encode(decoded_user_info)

-- nginx logs a (pretty) printed jsonified dict
ngx.log(ngx.WARN, '\nmy '..string.gsub(require('cjson').encode(decoded_user_info), ",", ",\nmy ")..'\n')

-- lua cannot gracefully concatenate strings and bools, thus do:
ngx.log(ngx.WARN, '\nmy use use_geoip2: '..tostring(use_geoip2)..'\n')