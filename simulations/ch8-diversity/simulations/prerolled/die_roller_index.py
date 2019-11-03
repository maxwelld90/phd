import sys
from whoosh.index import open_dir

def roll_die(probability):
    """
    Returns a boolean value corresponding to whether the action should be undertaken or not dependant upon the provided probability.
    """
    val = random.random()
    
    if val > probability:
        return False
    else:
        return True

def determine_actions(index_path, prob_nonrel):
    """
    Extracts each document in the index, and works out probabilities for interacting with it.
    """
    index = open_dir(index_path)
    documents = index.searcher().documents()
    
    for doc in documents:
        print "0 0 {0} {1}".format(doc['docid'], 1 if roll_die(prob_nonrel) else 0)
    
    index.close()

def usage(script_name):
    """
    Sends the usage to stdout and terminates.
    
    Given the path to a Whoosh document index, retrieves each document from the index and provides a probability for it.
    Remember, this is the fallback probability file - we only need a probability if the document is not clicked (judgement == 0)
    """
    print "Usage: {0} <index_path> <prob_nonrel> <seed> <seed_base_value>".format(script_name)
    sys.exit(-1)

if __name__ == '__main__':
    if len(sys.argv) == 5:
        index_path = sys.argv[1]
        prob_nonrel = float(sys.argv[2])
        seed = int(sys.argv[3]) + int(sys.argv[4])
    else:
        usage(sys.argv[0])  # Terminates process if called
    
    import random
    random.seed(seed)
    determine_actions(index_path, prob_nonrel)
    
    