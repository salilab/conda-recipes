import sys

_, cmake = sys.argv
# Use CMake path separators throughout
with open(cmake) as fh:
    contents = fh.read()

with open(cmake, 'w') as fh:
    fh.write(contents.replace('\\', '/'))
