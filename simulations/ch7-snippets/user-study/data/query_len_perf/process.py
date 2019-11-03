f = open('raw.csv', 'r')

mapping = {
    '1': '2',
    '2': '0',
    '3': '1',
    '4': '4',
}

for line in f:
    line = line.strip().split(',')
    
    if line[0].startswith('interface'):
        line[0] = 'snip_len'
        line[3] = 'query_length'
        print ','.join(line)
        continue
    
    line[0] = mapping[line[0]]
    line[3] = str(len(line[3].split('_')))
    
    print ','.join(line)


f.close()