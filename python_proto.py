# author: langenhagen

#!/usr/bin/env python              # the correct shebang for a Python script

# --------------------------------------------------------------------------------------------------
# general help

# You can call help() around a module, class, function, even on objects
# in order to get more information

# --------------------------------------------------------------------------------------------------
# set -x equivalent

# python -m trace --ignore-dir /home/barn/miniconda3/ -t myscript

# --------------------------------------------------------------------------------------------------
#comments & docstrings

'''
This is a
Multiline
Comment
'''

""" Also a
multiline
comment
"""

r"""For consistency, always use \"\"\"triple double quotes\"\"\"
around docstrings. Use r\"\"\"raw triple double quotes\"\"\"
if you use any backslashes in your docstrings.
For Unicode docstrings, use u\"\"\"Unicode triple-quoted strings."""

def foo():
    """One-Line Docstrings are fine. note: there's no blank line between docstring and code."""
    pass


u"""I may be a unicode Docstring 😁😁😁."""


# function with a one-line focstring, perfectly fine
def add(a, b):
    """Add two numbers and return the result."""
    return a + b


# Numpy-style docstrings
def random_number_generator(arg1, arg2):
    """
    Summary line.

    Extended description of function.

    Parameters
    ----------
    arg1 : int
        Description of arg1
    arg2 : str
        Description of arg2

    Returns
    -------
    int
        Description of return value

    """
    return 42


# Use Sphinx to compile ReStructuredText (.rst files) Docstrings for python
# The Sphinx-Extension  sphinx.ext.napoleon  can handly Numpy-Syle Docstrings

# see: https://www.python.org/dev/peps/pep-0257/

# --------------------------------------------------------------------------------------------------
# variables are dynamically typed
x = 'string'
x = 12
x = None
x = 12.3

del x  # everything in python is an object and you can delete objects

if foo is None:
    pass

# --------------------------------------------------------------------------------------------------
# numeric delimiters

myint = 1_0  # == 10
myfloat = 2_0.0  # == 20.0
thousand = 1_000  # == 1000
million = 1_000_000.0  # == 1000000


# --------------------------------------------------------------------------------------------------
# output

print("This goes to stdout")
print("This goes to stderrr", file=sys.stderr)

pi = 3.14
print(f"PI is {pi}")

# --------------------------------------------------------------------------------------------------
# string formatting

'foo {} and {!s}'.format('bar','baz')  # {} and {!s} print the __str__ result of the given object
'foo {!r}'.format('bar')               # {!r} prints the __repr__ result of the given object

# --------------------------------------------------------------------------------------------------
# input

my_input = input('please enter a number: ')  # type(my_input) will be 'str'

input('->')

# --------------------------------------------------------------------------------------------------
# pretty printing

myobj = dict(my=rather, complex=:{"object":True}, full="of", an="ugly", amount="of", stuff=None)

# with pprint - meh
import pprint
pp = pprint.PrettyPrinter()
pp.pprint(myobj, depth:12)

# with json - i prefer it over pprint
import json
print(json.dumps(myobj, indent=2))


# --------------------------------------------------------------------------------------------------
# Loops

a = [1, 2, 3, 4, 5]
for el in a:
    if el == 0:
        break
else:                           # optional for-else
    print("for's else gets triggered when no break statement is called")

names = ['Anton', 'Beatrice', 'Carl']
# instead of:
i=0
for name in names:
    print(i, name)
# rather do:
for i, name in enumerate(name):
    print(i, name)
# or even:
for i, name in enumerate(namem, start=1):
    print(i, name)

# --------------------------------------------------------------------------------------------------
# if-elif-else

if x:
    print('A')
elif y:
    print('B')
else:
    print('C')

# one line if-else
a = b if b else 'mydefault'   # else case when b == '' or b == None

# --------------------------------------------------------------------------------------------------
# Chained comparisons

x = 12.3
print( 7 < x < 11)  # False
print( 7 < x < 13)  # True

# --------------------------------------------------------------------------------------------------
# functions

''' implementation of the karate chop code kata
'''

def my_function(my_param):
    ''' implementation of the karate chop code kata
    '''
    pass


def my_function(a=1, b=2, c=3):
   print(f'{a}; {b}; {c}')

my_function()
my_function(1,2)
my_function(3, 4, 5)
my_function(c=6,b=7,a=8)
my_function(b=9)

# --------------------------------------------------------------------------------------------------
# argument unpacking

# tuple unpacking
my_params_as_a_tuple = {8, 9, 10}
my_function(**my_params_as_a_tuple)  # ** in a function extracts a dict as function params

# dict unpacking
my_params_as_a_dict = {'a': 10, 'b': 11, 'c': 12}
my_function(**my_params_as_a_dict)  # ** in a function extracts a dict as function params

def my_vararg_function(*args):  # *arg means non-keyworded, variable-length argument list
    print (type(args))  # type: class 'tuple'
    for i in args:
      print (i)

my_vararg_function(1,'Hello',3)


def my_keyworded_vararg_function(a, **kwargs):  # **kwargs means keyworded, variable-length argument list
    print (type(kwargs))  # type: class 'dict'
    for k,v in kwargs.items():
      print (f'{k}: {v}')

my_keyworded_vararg_function(a='AAAAA',b='Hello',c=3)
my_params = {'d': 'one', 'e': 'two', 'f': 'three'}
my_keyworded_vararg_function('AAAAA', **my_params)


# following throws a TypeError, since param 'a' would be assigned twice in the function call
#my_params = {'a': 'BBBBB'}
#my_keyworded_vararg_function('AAAAA', **my_params)

# --------------------------------------------------------------------------------------------------
# string types

type('bytes for storing data')  # unicode string / not in python 2.7
type(b'bytes for storing data')  # <class 'bytes'>
type(bytearray(b'a bytearray'))  # <class 'bytearray'>

f'Formatted string'

# 'we cannot add a string' + b'and bytes'  # does not work

# f-strings make string-formatting easy
# f-strings are faster than both %-formatting and str.format()
name = "Eric"
age = 74
f"Hello, {name}. You are {age}."  # prints 'Hello, Eric. You are 74.'

def to_lowercase(input):
    return input.lower()

name = "Eric Idle"
f"{to_lowercase(name)} is funny."  # f-Strings are evaluated at runtime: 'eric idle is funny.'

# --------------------------------------------------------------------------------------------------
# 'is' checks for identity, "==" checks for equality
a = [1, 2, 3]
b = a

a is b  # True
a == b  # True

c = list(a)
a == c  # True
a is c  # False


# --------------------------------------------------------------------------------------------------
# lambdas

add = lambda x, y: x + y  # NOTE: PEP8 style guide advises never to store a lambda in a var yourself
print(add(3, 5))  # 8

print((lambda x, y: x * y)(3, 5))  # 15

# --------------------------------------------------------------------------------------------------
# rounding

# Python 3 rounds to the next even number:

round(2.5)   # 2
round(3.5)   # 4
round(-3.5)  # -4

# --------------------------------------------------------------------------------------------------
# containers

mylist = [1,2,3]
mydict = {'a': 1, 'b': 2}
myset = {1,2,3,1}  # yields {1,2,3}
mytuple = (1,2,3)  # immutable list

# merge two dictionaries
mydict2 = {'b': 3, 'c': 4}
my_merged_dict = {**mydict, **mydict2}


# --------------------------------------------------------------------------------------------------
# lists and ranges

range(3)  # iterable from [0..2]
list(range(3))  # [0,1,2]

#print a list
my_list=[1,4,5]
print(*my_list, sep=' : ')  # prints  1 : 4 : 5

for i, elem in enumerate(['foo', 'bar', 'baz']):  # enumerate adds indices to lists/ranges
    print(f'{i}: {elem}')  # prints 0: foo \n 1: bar \n 2: baz

start_at_index=42
for i, elem in enumerate(['foo', 'bar', 'baz'], start_at_index):
    print(f'{i}: {elem}')  # prints 42: foo \n 43: bar \n 44: baz

for i, elem in enumerate(range(3)):
    print(f'{i}: {elem}')    # prints 0: 0 \n 1: 1 \n 2: 2


# --------------------------------------------------------------------------------------------------
# Classes

class MyClass:
    pass

class MyClass():
    """This is a one-liner class doc-string"""
    my_class_var = 42

    # def __new__(cls, *args, **kwargs):
    #     """handles object construction
    #     Usually, you don't want or need to overwrite it.
    #     """
    #     instance = super().__new__(cls)
    #     return instance

    def __init__(self, my_param):
        """handles object initialization"""
        self.my_member_var = my_param

    def my_method(self):
        pass

    @classmethod  # use classmethods e.g. for factory methods, helpful in combination with Inheritance
    def from_string(cls, my_param=None):
        return cls(my_param)

    @staticmethod
    def my_staticmethod():
        pass

    @property
    def my_member(self):
        print( '... do some in the getter here ...')
        return self.my_member_var

    @my_member.setter
    def my_member(self, value):
        print( '... do some stuff in the setter here ...')
        self.my_member_var = value

class MyChildClass(MyClass):
    pass

MyClass.my_staticmethod()
MyClass.from_string()  # creates a MyClass object
MyChildClass.my_staticmethod()
MyChildClass.from_string()  # creates a MyChildClass object

my_object = MyClass("Hi there!")
my_object.my_method()
my_object.my_member = 'Jowas'
print(my_object.my_member)


# Abstract classes
from abc import ABC, abstractmethod

class MyAbstractBaseClass(ABC):

    def __init__(self):
        pass

    @abstractmethod
    def do_something(self):
        pass

class MyConcreteClass(MyAbstractBaseClass):
    def do_something(self):
        return 42

#a = MyAbstractBaseClass()  # throws an error
b = MyConcreteClass()  # works

# --------------------------------------------------------------------------------------------------
# operator overloading

class FunctionLike(object):
    def __call__(self, a):  # overloads the () operator
        print "I got called with %r!" % (a,)

myfun = FunctionLike()
myfun(10)

# --------------------------------------------------------------------------------------------------
# decorators

# a proper decorator with args and kwargs for arbitrary positional arguments
def do_twice(func):
    def wrapper_do_twice(*args, **kwargs):
        func(*args, **kwargs)
        func(*args, **kwargs)
    return wrapper_do_twice

@do_twice
def foo()
    print('This function is decorated')
    pass


def outer_decorator(func):
    def wrapper_outer_decorator(*args, **kwargs):
        print("OUTER")
        func(*args, **kwargs)
    return wrapper_outer_decorator

def inner_decorator(func):
    def wrapper_inner_decorator(*args, **kwargs):
        print("INNER")
        func(*args, **kwargs)
    return wrapper_inner_decorator

@outer_decorator
@inner_decorator
def get_text(name):
   return f"Hello, {name} !"

print(get_text("Foo"))  # Outputs OUTER\nINNER\nHello, Foo!



def decorator_with_argument(tag_name):
    def tags_decorator(func):
        def func_wrapper(name):
            return "<{0}>{1}</{0}>".format(tag_name, func(name))
        return func_wrapper
    return tags_decorator

@tags("p")
def get_text(name):
    return "Hello " + name

print get_text("John") # Outputs <p>Hello John</p>

# --------------------------------------------------------------------------------------------------
# context managers

with open("file.txt") as f:
    contents = f.read()

with open("file.txt", "w+") as f:
    f.write("Yeah\n")

# implement a context manager via a class:
# use this approach when the Context Management is complex
class MyOpen:
    def __init__(self, filename):
        self.file = open(filename)

    def __enter__(self):   # !
        return self.file

    def __exit__(self, ctx_type, ctx_value, ctx_traceback):  # !
        self.file.close()


with MyOpen('file') as f:
    contents = f.read()


# implement a context manager via python's own contextlib
# use this approach when the context management is simple
from contextlib import contextmanager

@contextmanager
def custom_open(filename):
    f = open(filename)
    try:
        yield f
    finally:
        f.close()

with custom_open('file') as f:
    contents = f.read()

# --------------------------------------------------------------------------------------------------
# logging

import logging

# --------------------------------------------------------------------------------------------------
# exceptions

import logging

raise IOError('this is my error')

try:
    this_nice_statement_throws_a_Name_error
except NameError as err:
    log.exception(err, "My error message")
except (OtherError, ThirdError) as err:
    log.exception(err, "Catch multiple types of exceptions in one block")


# --------------------------------------------------------------------------------------------------
# generators

my_generator = (letter for letter in 'abcdefg')

next(my_generator)  # a
next(my_generator)  # b
next(my_generator)  # c ...

# --------------------------------------------------------------------------------------------------
# comprehensions  aka  ... for ... in (...)

i = 1

mylist = [i for i in range(5)]  # [0,1,2,3,4]
mylist = [i for i in range(5) if i % 2 == 0]  # [0,2,4]
myset = {i for i in range(5)}  # {0,1,2,3,4}
mydict = {i:2*i for i in range(5)}  # {0,1,2,3,4}

print(f'i: {i}')  # outer i is untouched: i == 1

# --------------------------------------------------------------------------------------------------
# Concatenate strings in a List
mylist = ["Yeah", "can", "do"]
print(" ".join(mylist))

# --------------------------------------------------------------------------------------------------
# static methods

class MyClass:
    @staticmethod
    def ima_static_method(arg1, arg2, ...):
        pass

# --------------------------------------------------------------------------------------------------
# type annotations

# Python 3.5+ supports type annotations that can be used with tools like Mypy to have static typing
def foo(a: int, b: int = 42) -> int:
    return a + b

def function_that_returns_none(a: int, b: int = None) -> None:
    pass

# --------------------------------------------------------------------------------------------------
# nice standard functions

print([i for i in zip('ABCD', 'xy')])  # prints [('A', 'x'), ('B', 'y')]

# list() converts an iterable into a list
list(filter(lambda x: x % 2 == 0, [i for i in range(100)]))  # 0, 2, 4, ...

my_tuple = (1, 2, 3, 4)
my_list = [1, 2, 3, 4]
my_set = {1, 2, 3, 4}
my_dict = {'Andreas': 'echt cool', 'Salome': 'auch cool', 3: 'auch cool ;)' }

list(map(lambda x: 2**x, [1,2,3,4]))  # =[2, 4, 8, 16]

x, y, z = 0, 1, 0
if any((x, y, z)):
    print('passed')  # works

# --------------------------------------------------------------------------------------------------
# namedtuples
# Using namedtuple is way shorter than
# defining a class manually:
from collections import namedtuple
Car = namedtuple('Car', 'color mileage')

my_car = Car('red', 3812.4)
my_car = Car(color='red' , mileage=3812.4)  # also good

my_car.color  # red
my_car.mileage # 3812.4

# my_car.mileage = 1234 # doesn't work; like tuples, namedtuples are immutable:

# --------------------------------------------------------------------------------------------------
# module collections

import collections

# find the most common elements in an iterable
c = collections.Counter('helloworld')  # Counter({'l': 3, 'o': 2, 'e': 1, 'd': 1, 'h': 1, 'r': 1, 'w': 1})
c.most_common(3)  # returns [('l', 3), ('o', 2), ('e', 1)]


# --------------------------------------------------------------------------------------------------
# json

import json
my_mapping = {'a': 23, 'b': 42, 'c': 0xc0ffee}
print(json.dumps(my_mapping, indent=4, sort_keys=True))
# returns
# {
#     "a": 23,
#     "b": 42,
#     "c": 12648430
# }

# --------------------------------------------------------------------------------------------------
# pathlib - deal with paths and files and do some file operations

from pathlib import Path

p = Path("path/to/my/file.tar.gz")

p.parent  # path/to/my

p.name  # file.tar.gz
p.stem  # file.tar

p.suffix  # ".gz"
p.suffixes  # [".tar", ".gz"]

p.unlink(missing_ok=False)  # delete the file

# get the absolute script file path
print(__file__)

# get the CWD old schoolish
from os import getcwd
current_cwd = getcwd()

# get the current script directory
script_dir = Path(__file__).parent.absolute()


# change the CWD to the directory of __file__
from os import chdir
script_dir = Path(__file__).parent
chdir(script_dir)

# --------------------------------------------------------------------------------------------------
# pandas - 3rd party library

import pandas as pd

df = pd.read_csv("path/to/my.csv")

# --------------------------------------------------------------------------------------------------
# time and sleeping

import time
time.sleep(5)  # sleeps for 5 seconds

# --------------------------------------------------------------------------------------------------
# threading
server_thread = threading.Thread(target=server.serve_forever, daemon=True)
server_thread.start()

# --------------------------------------------------------------------------------------------------
# debugging with pdb

# way to go
breakpoint()     # simply add breakpoint() to your application

# more cumbersome way - works in python
import pdb; pdb.set_trace();  # put it somewhere to set a breakpoint then press ? when you reached it
import sys, pdb; pdb.Pdb(stdout=sys.__stdout__).set_trace()  # python debugger for robot framework

# --------------------------------------------------------------------------------------------------
# inspection

#view the source code of some object
import inspect
lines = inspect.getsource(foo)
print(lines)

# view the signature of some classes
from inspect import signature
signature(Parent)  # <Signature (name: str, age: int, ugly: bool = False) -> None>
signature(Child)

# --------------------------------------------------------------------------------------------------
# timeit
# The "timeit" module lets you measure the execution time of small bits of Python code

import timeit
timeit.timeit('"-".join(str(n) for n in range(100))', number=10000)    # takes 0.3412662749997253
timeit.timeit('"-".join([str(n) for n in range(100)])', number=10000)  # takes 0.2996307989997149
timeit.timeit('"-".join(map(str, range(100)))', number=10000)          # takes 0.2458147069992264

# --------------------------------------------------------------------------------------------------
# temporary files

import tempfile
temp_dir = tempfile.mkdtemp()
# you still have to delete manually

# --------------------------------------------------------------------------------------------------
# Python's integrated simple http server:

python -m SimpleHTTPServer 8000  # Python 2; serves the current directory at http://localhost:8000
python3 -m http.server  # Python 3

# --------------------------------------------------------------------------------------------------
# advanced importing

# add the parent directory to the sys.path to import modules and packages from there.
import pathlib
import sys
sys.path.insert(0, pathlib.Path(__file__).absolute().parents[1].as_posix())
import my_neighboring_package

# --------------------------------------------------------------------------------------------------
# regexes
import re

# named capture groups "(?P<my_identifier>.*)"
match = re.search("(?P<name>.*) (?P<phone>.*)", "John 123456")
match.group("name")  # returns "John"

# --------------------------------------------------------------------------------------------------
# Usage message

import sys
def show_usage():
    print(
        "Usage:\n"
        "{} <file>\n"
        "\n"
        "Example:\n"
        "{} ~/dev/script.py".format(sys.argv[0], sys.argv[0])
    )

# --------------------------------------------------------------------------------------------------
# Pytest
# Pytest can test function return values against their docstrings:
# pytest can ensure the results are correct:

# According to, https://vincent.bernat.ch/en/blog/2019-sustainable-python-script
# this works:

def fizzbuzz(n, fizz, buzz):
    """Compute fizzbuzz nth item given modulo values for fizz and buzz.

    >>> fizzbuzz(5, fizz=3, buzz=5)
    'buzz'
    >>> fizzbuzz(3, fizz=3, buzz=5)
    'fizz'
    >>> fizzbuzz(15, fizz=3, buzz=5)
    'fizzbuzz'
    >>> fizzbuzz(4, fizz=3, buzz=5)
    4
    >>> fizzbuzz(4, fizz=4, buzz=6)
    'fizz'

    """
    if n % fizz == 0 and n % buzz == 0:
        return "fizzbuzz"
    if n % fizz == 0:
        return "fizz"
    if n % buzz == 0:
        return "buzz"
    return n


# Call pytest then like the following:
# python3 -m pytest -v --doctest-modules ./<FILENAME>.py
#
# This requires the script name to end with .py. I dislike appending an extension
# to a script name: the language is a technical detail that shouldn’t be exposed
# to the user. However, it seems to be the easiest way to let test runners, like
# pytest, discover the enclosed tests.

# --------------------------------------------------------------------------------------------------
# Tricks

path = path or my_default_path  # set a default value


der my_function_yet_to_be_implemented(self):
    raise ExecutionFailed("Not implemented!")

# if the logging in Python does not work, then you can do this
raise ValueError("I can serve as a log message")

a, b = 2, 3
a, b = b, a  # swap two vars without using a tmp var


# Write to a frozen dataclass object
@dataclass(frozen=True)
class C:
    pass

c = C()

object.__setattr__(c, "myfield", 42)

# --------------------------------------------------------------------------------------------------
# Drop to shell

# drop into Python shell after program execution
python -i my_script.py

# or
import code
code.interact(local=locals())

# into a PDB shell
import pdb
pdb.set_trace()

# into an IPython shell
import IPython
IPython.embed()

# into a BPython shell
from bpython import embed
embed(locals_=locals(), banner="\nDropping to interactive shell\n")


# --------------------------------------------------------------------------------------------------
# Python pitfalls

# def foo(from=None):  # from causes invalid syntax; from is a word that you use in import ... from
#   pass

# better do:
# def foo(from_=None):
#   pass
