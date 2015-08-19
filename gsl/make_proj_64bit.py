# Hack project files to work on 64 bit
import sys

fname = sys.argv[1]

contents = open(fname).read()
contents = contents.replace('Win32', 'x64')
open(fname, 'w').write(contents)
