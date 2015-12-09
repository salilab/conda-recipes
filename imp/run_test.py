import IMP
import IMP.core
import IMP.atom
import IMP.algebra
import IMP.rmf
import IMP.test
import RMF
import os

# Make sure that install prefix is set correctly
IMP.test.get_data_path('linux.words')

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

os.unlink("test.rmf")
