from __future__ import print_function
import sys
import glob

prefix = sys.argv[1]
build_prefix = sys.argv[2]

build_prefix_escaped = build_prefix.replace('\\', '\\\\')
build_prefix_cmake = build_prefix.replace('\\', '/')

for cmake_file in glob.glob("%s/Library/lib/cmake/CGAL/*.cmake" % prefix):
    with open(cmake_file, "r") as fh:
        c = fh.read()
    with open(cmake_file, "w") as fh:
        c = c.replace(build_prefix_cmake, "${CGAL_INSTALL_PREFIX}")
        c = c.replace(build_prefix_escaped, "${CGAL_INSTALL_PREFIX}")
        c = c.replace(build_prefix, "${CGAL_INSTALL_PREFIX}")
        fh.write(c)
