import sys
import utils

def usage(script_name):
    """
    Prints the usage to stdout and terminates.
    """
    print "From a given start point, finds all simulation configuration XML files and displays their absolute paths."
    print "Usage:"
    print "    {0} <base_dir>".format(script_name)
    print "Where:"
    print "    <base_dir> The directory from which to start from. This is recursive from the base directory."
    
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        usage(sys.argv[0])
    
    sim_list = utils.get_simulation_configs(sys.argv[1])
    
    for entry in sim_list:
        print entry
    
    sys.exit(0)