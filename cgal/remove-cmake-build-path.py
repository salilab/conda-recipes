import sys
import glob

prefix = sys.argv[1]
build_prefix = sys.argv[2]

build_prefix_cmake = build_prefix.replace('\\', '/')

for cmake_file in glob.glob("%s/Library/lib/cmake/CGAL/*.cmake" % prefix):
    with open(cmake_file, "rb") as fh:
        contents = fh.read()
    with open(cmake_file, "wb") as fh:
        fh.write(contents.replace(build_prefix_cmake, "${CGAL_INSTALL_PREFIX}"))
