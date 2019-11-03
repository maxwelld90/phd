import fnmatch
import os

queries = {'D': [], 'ND': []}

print 'no_terms,is_diversified,topic,terms'

for root, dirnames, filenames in os.walk('/users/grad/david/Workspace/thesis/ch8/simulations/performance_50topics/'):
    for filename in fnmatch.filter(filenames, '*.queries'):
        f = open(os.path.join(root, filename), 'r')

        name = filename.split('-')
	interface =  name[1].split('_')[0][1]
	
	if interface == '1' or interface == '3':
            system = 'D'
            is_diversified = 1
	else:
	    system = 'ND'
            is_diversified = 0

        topic = name[2]

        for line in f:
            line = line.strip()

            if line not in queries[system]:
                print "{0},{1},{2},{3}".format(len(line.split(' ')), is_diversified, topic, line)
                queries[system].append(line)