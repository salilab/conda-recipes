import os
import sys

# Make sure that expected symlinks are there
# Certain versions of conda-build break our symlinks and replace them with
# copies. This makes the package much larger and also breaks setting up
# the license key at post-install. conda-build 2.1 seems to be affected
# but conda-build 2.0.10 seems OK.

# No symlinks in the Windows package
if sys.platform == 'win32':
    sys.exit(0)

p = os.path.join(os.environ['SP_DIR'], 'modeller')
assert(os.path.islink(p) and os.path.exists(p))

prefix = os.environ['CONDA_PREFIX']
ver = os.environ['PKG_VERSION']
p = os.path.join(prefix, 'lib', 'modeller-%s' % ver, 'src', 'include')
assert(os.path.islink(p) and os.path.exists(p))
