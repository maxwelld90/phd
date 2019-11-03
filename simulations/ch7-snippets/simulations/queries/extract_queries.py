import fnmatch
import os

queries = []

print 'no_terms,topic,terms'

for root, dirnames, filenames in os.walk('/users/grad/david/Workspace/thesis/ch7/simulations/performance_50runs/'):
    for filename in fnmatch.filter(filenames, '*.queries'):
        f = open(os.path.join(root, filename), 'r')

        name = filename.split('-')
        topic = name[2]

        for line in f:
            line = line.strip()

            if line not in queries:
                print "{0},{1},{2}".format(len(line.split(' ')), topic, line)
                queries.append(line)