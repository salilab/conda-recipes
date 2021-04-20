import RMF
import os

# Make sure that we can read in an RMF file that we ourselves created
r = RMF.create_rmf_file("test.rmf")
r.add_frame("root", RMF.FRAME)
del r

r = RMF.open_rmf_file_read_only("test.rmf")
r.set_current_frame(RMF.FrameID(0))
del r

os.unlink("test.rmf")
