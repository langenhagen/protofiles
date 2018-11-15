# author: andreasl
# version: 18-11-14

# This file contains general python and python2 related prototypical information

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
