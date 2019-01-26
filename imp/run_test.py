import IMP
import IMP.core
import IMP.atom
import IMP.algebra
import IMP.domino
import IMP.npctransport
import IMP.rmf
import IMP.test
import RMF
import os
import re

# Make sure that install prefix is set correctly
d = IMP.test.get_data_path('linux.words')
fh = open(d)
del fh
d = IMP.atom.get_example_path('cg_pdb.py')
fh = open(d)
del fh

# Make sure that we can read in an RMF file that we ourselves created
m = IMP.Model()
d = IMP.core.XYZR.setup_particle(IMP.Particle(m),
                  IMP.algebra.Sphere3D(IMP.algebra.Vector3D(1,2,3), 2.0))
IMP.atom.Mass.setup_particle(d, 4.0)

r = RMF.create_rmf_file("test.rmf")
IMP.rmf.add_hierarchies(r, [d])
IMP.rmf.save_frame(r)
del r

r = RMF.open_rmf_file_read_only("test.rmf")
IMP.rmf.link_hierarchies(r, [d])
IMP.rmf.load_frame(r, 0)
del r

os.unlink("test.rmf")

# Make sure that IMP.domino was built with HDF5 support
x = IMP.domino.ReadHDF5AssignmentContainer

# Make sure that IMP.npctransport has full protobuf support
x = IMP.npctransport.Configuration

def test_cmake_file(cmake):
    """Make sure that all paths in the cmake file exist."""
    vars = {}
    r = re.compile('set\s*\(\s*(\S+(DIR|PATH|LIBRARIES))\s*(\S+)',
                   flags=re.IGNORECASE)
    with open(cmake) as fh:
        for line in fh:
            m = r.search(line)
            if m:
                val = m.group(3)
                if val[0] == '"' and val[-1] == '"':
                    val = val[1:-1]
                vars[m.group(1)] = val.split(";")
    # Don't check any empty paths, or paths that reference other
    # variables ($) since we don't substitute those
    bad = [(key,val) for (key,val) in vars.items()
           if not all(not d or '$' in d or os.path.exists(d) for d in val)]
    if bad:
        raise ValueError("The following paths in the cmake file do not exist: "
                         + "; ".join("%s = %s" % (key, ";".join(val))
                                     for key,val in bad))

test_cmake_file(os.path.join(os.environ['PREFIX'], 'lib', 'cmake',
                             'IMP', 'IMPConfig.cmake'))
