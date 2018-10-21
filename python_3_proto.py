# author: langenhagen
# version: 18-10-21

# --------------------------------------------------------------------------------------------------
#comments


# -*- coding: utf-8 -*-  # this line you often see at the 1st or 2nd line in a script


'''
This is a
Multiline
Comment
'''

""" Also a
multiline
comment
"""

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


# --------------------------------------------------------------------------------------------------
#input

my_input = input('please enter a number: ');  # type(my_input) will be 'str'

# --------------------------------------------------------------------------------------------------
# functions

''' implementation of the karate chop code kata
'''

def my_function(my_param):
    ''' implementation of the karate chop code kata
    '''
    pass


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
    pas



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

with open('file.txt') as f:
    contents = f.read()

# implement a context manager via a class:
# use this approach when the Context Management is complex
class MyOpen(object):
    def __init__(self, filename):
        self.file = open(filename)

    def __enter__(self):   # !
        return self.file

    def __exit__(self, ctx_type, ctx_value, ctx_traceback):  # !
        self.file.close()


with MyOpen('file') as f:
    contents = f.read()


# implemen a context manager via python's own contextlib
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
# exceptions

raise IOError('this is my error')


try:
    this_nice_statement_throws_a_Name_error
except NameError as err:
    print(err, 'My error message')


# --------------------------------------------------------------------------------------------------
# generators

my_generator = (letter for letter in 'abcdefg')

next(my_generator)  # a
next(my_generator)  # b
next(my_generator)  # c ...


# --------------------------------------------------------------------------------------------------
# list comprehensions  aka  ... for ... in (...)

i = 1
print('my list comprehension:', [i for i in range(5)])  # prints: ... [0,1,2,3,4]
print(f'i: {i}')  # i: 1


# --------------------------------------------------------------------------------------------------
# static methods


class MyClass:
    @staticmethod
    def ima_static_method(arg1, arg2, ...):
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