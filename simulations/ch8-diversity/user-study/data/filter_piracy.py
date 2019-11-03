f = open('experiment.log', 'r')

for line in f:
    line = line.strip().split(' ')
    topic = line[8]
    
    if topic == '367':
        continue
    
    print ' '.join(line)