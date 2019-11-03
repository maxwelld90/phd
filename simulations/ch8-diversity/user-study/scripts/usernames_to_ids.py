import sys


def get_mappings(mappings_path):
    """
    Gets the mappings, reads them into a dictionary, and returns said dictionary.
    """
    f = open(mappings_path, 'r')
    mappings = {}
    
    for line in f:
        line = line.strip().split(',')
        mappings[line[0]] = line[1]
    
    f.close()
    return mappings

def main(src_path, mappings_path, delimiter):
    """
    Does the magic.
    """
    mappings = get_mappings(mappings_path)
    f = open(src_path, 'r')
    
    for line in f:
        line = line.strip()
        
        for amtid in mappings.keys():
            replace_with = mappings[amtid]
            line = line.replace(amtid, replace_with)
        
        print line
    
    f.close()

def usage(script_name):
    """
    Prints the usage of the script to stdout.
    """
    print "Finds instances of user IDs in a mappings file."
    print "Replaces those instances with the ID in the mappings file."
    print "Edited file is dumped to stdout."
    print
    print "Usage:"
    print "{0} <src_path> <mappings_path> <src_delimiter>".format(script_name)
    print
    print "Where:"
    print "    <src_path>      Path to source file to change"
    print "    <mappings_path> Mappings file (AMTID,ID)"
    print "    <src_delimiter> What filetype? Specify the separator character (leave for space)"

if __name__ == '__main__':
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        usage(sys.argv[0])
        sys.exit(1)
    
    src_path = sys.argv[1]
    mappings_path = sys.argv[2]
    src_delimiter = ' '
    
    if len(sys.argv) == 4:
        src_delimiter = sys.argv[3]
    
    main(src_path, mappings_path, src_delimiter)