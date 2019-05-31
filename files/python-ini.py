#!/usr/bin/python3

import configparser
import sys

config = configparser.ConfigParser()
config.read(sys.argv[1])


#remove default
if config.has_section('default'):
    config.remove_section('default')
    config.write(open(sys.argv[1],'w'))

if sys.argv[2] != 'reset':
    #create/recreate default
    if not config.has_section('default'):
        config.add_section('default')

    for l in config[sys.argv[2]]:
        print("export",l.upper()+"="+config[sys.argv[2]][l])
        config.set('default', l, config[sys.argv[2]][l])

#write to file
config.write(open(sys.argv[1],'w'))
