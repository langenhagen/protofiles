# author: langenhagen
# version: 17-08-05

# --------------------------------------------------------------------------------------------------
# get current file name

puts "$0            : #{$0}"
puts "__FILE__      : #{__FILE__}"
puts "$PROGRAM_NAME : #{$PROGRAM_NAME}"


# --------------------------------------------------------------------------------------------------
# Script Argument vector and usage

if ARGV.empty?
  puts "Usage: ruby #{__FILE__} <my_argument>"
  exit 0
end

# --------------------------------------------------------------------------------------------------
# Conditionals

unless File.exist? File.expand_path my_file_name then
    #...
end

unless you_can_also_omit_the_then_keyword
    #...
end

# --------------------------------------------------------------------------------------------------
# Functions

def my_fun(my_variable)
   return my_variable + 42
end

function_invocations_dont_need_parentheses = my_fun 32

function_invocations_can_have_parentheses = my_fun(32)

function_invocation_chains_need_parentheses = my_fun(32).chr


# --------------------------------------------------------------------------------------------------
# Exceptions

begin
     # ...
rescue => err
    puts "Exception: #{err}"
    exit 1
end


# --------------------------------------------------------------------------------------------------
# Regexes

first_occurence = line[/\d+/]
last_occurence = line.scan(/\d+/)[-1].to_i


# --------------------------------------------------------------------------------------------------
# Filehandling

file = File.new("filename", "r", :encoding => 'ISO-8859-1')