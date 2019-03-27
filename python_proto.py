# author: andreasl
# version: 18-11-14

# This file contains general python and python2 related prototypical information

# --------------------------------------------------------------------------------------------------
# printing

'foo {} and {!s}'.format('bar','baz')  # {} and {!s} print the __str__ result of the given object
'foo {!r}'.format('bar')               # {!r} prints the __repr__ result of the given object

# --------------------------------------------------------------------------------------------------
# set -x equivalent

python3 -m trace --ignore-dir /home/barn/miniconda3/ -t myscript

# --------------------------------------------------------------------------------------------------
# Concatenate strings in a List
mylist = ["Yeah", "can", "do"]
print(" ".join(mylist)

# --------------------------------------------------------------------------------------------------
# pretty printing

import pprint

pp = pprint.PrettyPrinter()

obj = {'my':'rather', 'complex':{'object':True}, 'full':'of', 'an':'ugly', 'amount':'of', 'stuff':None}

pp.pprint(entities, depth:12)

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
# range

range(3)  # yields [0,1,2]

# --------------------------------------------------------------------------------------------------
# Loops

a = [1, 2, 3, 4, 5]
for el in a:
        if el == 0:
            break
else:                           # optional for-else
    print("for's else gets triggered when no break statement is called")

# --------------------------------------------------------------------------------------------------
# Chained comparisons

x = 12.3
print( 7 < x < 11)  # False
print( 7 < x < 13)  # True


# --------------------------------------------------------------------------------------------------
# list comprehensions

# Python's list comprehensions are awesome.

vals = [expression
        for value in collection
        if condition]

# ...  is equivalent to:

vals = []
for value in collection:
    if condition:
        vals.append(expression)


even_squares = [x * x for x in range(10) if not x % 2]  # [0, 4, 16, 36, 64]

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
# nice (pythonic) idioms

path = path or my_default_path  # set a default value


der my_function_yet_to_be_implemented(self):
    raise ExecutionFailed("Not implemented!")


# if the logging in Python does not work, then you can do this
raise ValueError("I can serve as a log message")

a, b = 2, 3
a, b = b, a  # swap two vars without using a tmp var

# --------------------------------------------------------------------------------------------------
# time and sleeping

import time
time.sleep(5)  # sleeps for 5 seconds

# --------------------------------------------------------------------------------------------------
# threading
server_thread = threading.Thread(target=server.serve_forever, daemon=True)
server_thread.start()

# --------------------------------------------------------------------------------------------------
# debugging, python debugger, pdb

import pdb; pdb.set_trace();  # put it somewhere to set a breakpoint then press ? when you reached it
import sys, pdb; pdb.Pdb(stdout=sys.__stdout__).set_trace()  # python debugger for robot framework

# --------------------------------------------------------------------------------------------------
# timeit
# The "timeit" module lets you measure the execution time of small bits of Python code

import timeit
timeit.timeit('"-".join(str(n) for n in range(100))', number=10000)    # takes 0.3412662749997253
timeit.timeit('"-".join([str(n) for n in range(100)])', number=10000)  # takes 0.2996307989997149
timeit.timeit('"-".join(map(str, range(100)))', number=10000)          # takes 0.2458147069992264


# --------------------------------------------------------------------------------------------------
# pitfalls

# def foo( from = None):  # from causes invalid syntax; from is a word that you use in impoirt .. from
#   pass

# better do:
# def foo( from_ = None):
#   pass


# --------------------------------------------------------------------------------------------------
# Python's integrated simple http server:

python -m SimpleHTTPServer 8000  # Python 2; serves the current directory at http://localhost:8000
python3 -m http.server  # Python 3


# --------------------------------------------------------------------------------------------------
# find the most common elements in an iterable
import collections

c = collections.Counter('helloworld')  # Counter({'l': 3, 'o': 2, 'e': 1, 'd': 1, 'h': 1, 'r': 1, 'w': 1})
c.most_common(3)  # returns [('l', 3), ('o', 2), ('e', 1)]


# --------------------------------------------------------------------------------------------------
# try except exception handling

try:
    import pymongo  # nice idea :D
except ImportError as err:
    print err
    sys.exit(1)
except (IDontLikeYouException, YouAreBeingMeanException) as e:
    prin "Catch multiple types of exceptions in one block"