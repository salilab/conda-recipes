from __future__ import print_function
import sys
import os

def install(src, dest, rename_map):
    print("Install %s -> %s" % (src, dest))
    with open(src, 'rb') as fh:
        contents = fh.read()
    for orig, repl in rename_map.items():
        contents = contents.replace(orig.encode('ascii'), repl.encode('ascii'))
    with open(dest, 'wb') as fh:
        fh.write(contents)

source_dir = sys.argv[1]
dest_dir = sys.argv[2]
norename_index = sys.argv.index('--norename')

norename = sys.argv[norename_index+1:]
rename = sys.argv[3:norename_index]

rename_map = {}
for r in rename:
    root, ext = os.path.splitext(r)
    new_fname = '_m' + root[:-2] + ext
    print("Renaming %s to %s" % (r, new_fname))
    rename_map[r] = new_fname

for r in rename:
    install(os.path.join(source_dir, r), os.path.join(dest_dir, rename_map[r]),
            rename_map)
for r in norename:
    install(os.path.join(source_dir, r),
            os.path.join(dest_dir, os.path.basename(r)), rename_map)
