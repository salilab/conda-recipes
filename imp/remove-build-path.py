import sys

_, cmake, build_prefix, prefix = sys.argv
# Use CMake path separators throughout
build_prefix = build_prefix.replace('\\', '/')
prefix = prefix.replace('\\', '/')

with open(cmake) as fh:
    contents = fh.read()

with open(cmake, 'w') as fh:
    fh.write(contents.replace('\\', '/').replace(build_prefix, prefix))
