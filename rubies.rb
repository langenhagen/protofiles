#!/usr/bin/env ruby

# !!! TRY USING pry instead of irb. It has autocompletion
# install pry like this: gem install pry

=begin
This is a multiline comment.
They look ugly. Use #
=end

# important tools ruby gems (package utility)
# irb interactive rooby
# ri ruby interactive reference such as man

puts __FILE__
puts __LINE__

ENV # environment variable mappings
ARGV # synonymous for $*

defined? variable # True if variable is initialized
:symbol
str '\tHi!'   # == "\\n"
puts str      # => "\nHi!"
str = "\tHi!"
puts str      # ==> "    Hi!"
v = gets


'StRIng'.downcase
str.downcase! # Same as downcase, but changes are made in place.
'x' * 3 # xxx
# there are many great & useful methods on the string objects, e.g. unpack or chomp
# chomp removes the last given character or charactersequence. E.g. dy default a \n or a  '\r'.
# Thus, chomp can be used to remove the last \n character from a readline command with readline.chomp


$globalvar = 'glbl'
Constant = true
var = nil
var = 'Jo'
puts var # with newline at the end
print var # without newline at the end

integer = 36   # the same as 3_6 ...underscores get ignored in digit strings!
hexnum = 0x42
binarynum = 0b1010
pwr = 2**3
parallel, assignment, possible = 1, 2, 3

a, b = 1, 3
a, b = b, a         # swaps to a=3 b=1


puts "Product of 24 * 60 * 60 is: #{24*60*60}"



def foo
    return 2, '3', 4
end

arr = foo

def foo( a, b,c='default')
    print a
    puts b
    puts "Das geht auch #{c}. Aber nur in \"\" quotes"
end

foo 'jo', 'schnegge', '!!!'
foo 'jo', 'schnegge', 42
foo 'was', 'geht'


def foo
  x = 42
  thelastassignment = 'willimplicitlybereturned'
end
v = foo


class A
end
a = A.new

class C
    def initialize( id, name)
        @id = id
        @name = name
    end
end
c = C.new( 42, 'Robert', 'Specialstreet 900')

c = C.allocate

class C

    puts "Will be printed at class definition. #{self.name}"

    Const = 3.14
    @inst_var = 42  # instance vars are private or protected.
    @@class_var=0
    def initialize(id, name)
        @id=id
        @name=name
    end

    def public_method
        puts "id #@id"
        puts "name #@name"
    end

    def protected_method
        puts "protected"
    end

    protected :protected_method

    def private_method
        puts "private"
    end

    private :private_method

    def +(other)
        C.new(@inst_var + other.inst_var, 'name')
    end

    def set_id=(id)
        @id = id
    end

    def C.class_method
        @@class_var += 1
        puts "Total count: #@@class_var"
    end
end

puts C::Const


10.times do puts 'jo' end
10.times do |i| puts "jo #{i}" end

arr = [  "fred", 10, 3.14, "This is a string", "last element", ]
arr.each do |i|
   puts i
end

arr.collect { |i| i*2 }  # returns transformed array from the container entries

(10..15).each do |n|        # range with .. end inclusively
   next if n == 12
   break if n == 14
   print n, ' '
end

(1...4).each do |n|        # range with ... end exclusively
   print n, ' '
end

r = ('a'..'d')    # 'a', 'b', 'c', 'd'
r = ('bar'..'bat').to_a  # 'bar', 'bas', 'bat'
r.include?('bas')

variable.freeze
variable.frozen?

Const = 0        # global Constant
module Foo
    Const = 0           # module constant
    ::Const = 1         # set global Const to 1
    Const = 2           # set local Const to 2
end
puts Const
puts Foo::Const


if x == 2
    puts 'is true'
end

if x == 3
    puts 'x is three'
elsif x == 2
    puts 'x is twoo'
else
    puts 'do I care?'
end

if x ==3 then puts 'JOOOO' end

puts 'jo' if x == 3

puts "'c' in ('a'..'j')" if ('a'..'j') === 'c'

unless x == 3
    puts 'x != 3 '
else
    puts == 'x == 3'
end

puts 'x not 3' unless x == 3


case x
    when 0..2
        puts 'x el [0..2]'
    when 3...4
        puts 'x el [3..4['
    else
        puts 'default'
end


while x < 5 do
    print '!'
    x += 1
end

(print '*'; x+=1) while x < 5

begin
    puts '!'
    x +=1
end while x < 5

until x>10
    x *=3
puts x
end

until x>10 do x*=3; puts x end

for x in 0..5 do puts x end



def foo(*test)
   puts "Variable Number of input params is #{test.length}"
   test.each do |i|
       puts 'Input: ' + i.to_s
   end
end

foo "A", "B", "C"
foo 1,2,3,4


alias new_method_alias method_name     # define aliases for methods
alias $MATCH $&                        # or global vars
undef method_name
alias_name          # aliases work even if the original method has been undefined
undef alias_name


def foo
   puts "yield executes a given block"
   yield
   puts "block call with any number of params works "
   yield 44
   puts "again block called 2 parameters"
   yield 100, 'katze'
end
foo {puts "This is a block. Given Parameters will be ignored if not used"}
foo {|i, j| puts "Block with param #{i} and #{j}"}


def foo(&block_as_param)
   block_as_param.call
end
foo { puts "!!!"}



BEGIN {
  puts "BEGIN blocks can be in every file and all BEGIN blocks will be executed at startup"
}

END {
  puts "END blocks can be in every file and all END blocks will be executed " \
       "in the reverse order of the BEGIN BLOCKS"
}


module M
    PI = 3.141592654
    def M.foo
        puts 'Module function that can be used wwit M.foo'
    end

    def bar
        puts 'bar: Function that can be included into e.g. a class'
    end
end

puts M::PI
M.foo
# M.bar # is not callable

class Foo
    include M
end

f = Foo.new
# f.foo # is not callable
f.bar


$LOAD_PATH << '.'
require 'filename'
require 'filename.py'

class Child < Mother
end

arr = Array.new
arr = Array.new(3)
arr = Array.new(3, 'predefined_val')
nums = Array.new(10) { |i| i *= 2 }
nums = Array[1, 2, 3]
digits = Array(1..3)

arr.size == arr.length

intersected_arr = array & other_array
union_arr = array | other_array
concatenated_arr = array + other_array
subtracted_arr = array - other_array
arr[0]
arr.at(0)
arr[1, 3]
arr[3, 1]  # returns empty array
arr(1..3)
arr.slice(1)
arr.slice(1..3)
arr[some_pos_out_of_bounds]  # returns nil
arr[-1]      # last element
arr[-3..-1]  # last 3 elements
arr[some_pos_out_of_bounds] = 42  # sets42 at pos and creates nil elements in between

arr * 3       # [0,1,2] to [0,1,2,0,1,2,0,1,2]
arr * 3       # [0,1,2] to [0,1,2,0,1,2,0,1,2]
arr * ' - '   # arr to '0 - 1 - 2 - 3'

# arrays have many useful built-in functions!

hsh = Hash.new
hsh = Hash.new('default_value')
hsh = Hash['a' => 100, 'b' => 200, ['also a', 'valid key'] => '999']
hsh[42]
hsh['string_key']
hsh['some_invalid_key'] # = nil or some specified default value
hsh.keys
hsh.values

current_time = Time.new
t = Time.new
t = Time.now # same as Time.new
t.inspect  # string representation
t.year
t.month
t.day
t.weekday # 0 is or might be sunday
t.hour
t.min
t.sec
t.zone
time.utc_offset
t.to_a # to array
Time.local(2017, 3, 30)
Time.utc(2017, 3, 30)
Time.gm(2017, 3, 30)    # greenwich mean time, same as utc
Time.now.to_i   # seconcds since epoch
Time.at(time_obj)  # seconds since epoch
Time.now.to_f   # seconcds since epoch with microseconds
puts t.to_s
puts time.strftime("%Y-%m-%d %H:%M:%S")


abort # die
exit 0
exit

$! # last exception object raised
$@ # stacktrace of the last exception raised
$/ # input record separator (defaults to newline)
$\ # output record separator (defaults to nil)
$0 # current running ruby program
$SAFE # security level 0 no security (default) ... 4 highest

str = %{Ruby is fun.}  # equivalent to "Ruby is fun."
str = %Q{ Ruby is fun. } # equivalent to " Ruby is fun. "
str = %q[Ruby is fun.]  # equivalent to 'Ruby is fun.' single quoted.
str = %x!ls! # equivalent to back tick command output result of `ls`

$KCODE = 'u' # set string character encoding to utf8, a for ascii (default), n also ascii

str =~ obj # Matches str against a regular expression pattern obj. Returns the position where the match starts; otherwise, false.

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

begin
    puts 'some_statement'
    raise 'Exception'
rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
rescue SyntaxError, NameError => e
    puts 'HAHAHAHAHA!'
rescue
      retry
else
    puts 'no_rescue_case_called (aka default'
ensure
    puts 'will always be executed with the context of the begin block'
end


fname = 'un_existent.txt'
begin
    puts fname
    file = open(fname)
    puts 'File open' if file
rescue
    fname = 'existent.txt'
    retry
ensure
    file.close
end

# CATCH AND THROW ############################################

def promptAndGet(prompt)
    print prompt
    res = readline.chomp
    throw :my_symbol if res == "!"  # not shown, but throws can also carry arguments maybe
    return res
end

# catches will be stepped in by program flow as if it where normal code
catch :my_symbol do

    # catch-block can be fast-aborted by its inner code if the inner code calls throw
    # this does not undo what happened until then, it just bails out, so it seems...

    # catch block aborts when some input is '!'

    name = promptAndGet("Name: ")
    age  = promptAndGet("Age:  ")
    sex  = promptAndGet("Sex:  ")
end


raise 'Error Message'
raise ExceptionType, 'Error Message'
raise ExceptionType, 'Error Message' unless i == 1
raise ExceptionType, 'Error Message' if i > 3

<=> # Combined comparison operator. Returns 0 if first operand equals second, 1 if first operand is greater than the second and -1 if first operand is less than the second.  (a <=> b) returns -1.
=== # Used to test equality within a when clause of a case statement. (1...10) === 5 returns true.
.eql? # True if the receiver and argument have both the same type and equal values. 1 == 1.0 returns true, but 1.eql?(1.0) is false.
equal? # True if the receiver and argument have the same object id.  if aObj is duplicate of bObj then aObj == bObj is true, a.equal?bObj is false but a.equal?aObj is true.