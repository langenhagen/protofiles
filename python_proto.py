# author: andreasl
# version: 18-11-14

# This file contains general python and python2 related prototypical information

# --------------------------------------------------------------------------------------------------
# printing

'foo {} and {!s}'.format('bar','baz')  # {} and {!s} print the __str__ result of the given object
'foo {!r}'.format('bar')               # {!r} prints the __repr__ result of the given object


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
# namedtuples
# Using namedtuple is way shorter than
# defining a class manually:
from collections import namedtuple
Car = namedtuple('Car', 'color mileage')

my_car = Car('red', 3812.4)

# Car(color='red' , mileage=3812.4)

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

path = path or some_alternative_path


der my_function_yet_to_be_implemented(self):
    raise ExecutionFailed("Not implemented!")


# if the logging in Python does not work, then you can do this
raise ValueError("I can serve as a log message")


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
