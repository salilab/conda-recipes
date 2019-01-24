import sys

_, cmake, build_prefix, prefix = sys.argv

with open(cmake) as fh:
    contents = fh.read()

with open(cmake, 'w') as fh:
    fh.write(contents.replace(build_prefix, prefix))
