
def resample_theta():
    pass # TODO

def resample_alphabeta():
    pass # TODO

def resample_Z():
    pass # TODO

## Run the sampler and save a copy of the variables at each iteration.
# samples = []
# for siter in xrange(1000):
#     print "ITER",siter
#     resample_Z()

#     resample_theta()
#     resample_alphabeta()
#     samples.append({'theta':theta.copy(), 'alpha':alpha.copy(), 'beta':beta.copy()})
#     ## Not saving Z since it can take a lot of memory.  1000 iters is ok, but 10000 iters is >1 GB (since it takes up 10000*Njus*Ncase*8 or so bytes.)
