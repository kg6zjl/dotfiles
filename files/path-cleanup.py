#!/usr/bin/python3

import os

first = []
second = []

#get current path
current_path = list(dict.fromkeys(os.environ["PATH"].split(':')))

#put anything with user at beginning of path
for item in current_path:
    if os.environ["USER"] in item:
        first.append(item)
    else:
        second.append(item)

#combine the lists
output = first + second

#set delimiter to :
print(':'.join(str(x) for x in output))
