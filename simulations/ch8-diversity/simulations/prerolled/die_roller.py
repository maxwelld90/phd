import os
import sys
from ifind.seeker.trec_qrel_handler import TrecQrelHandler

def roll_die(probability):
    """
    Returns a boolean value corresponding to whether the action should be undertaken or not dependant upon the provided probability.
    """
    val = random.random()
    
    if val > probability:
        return False
    else:
        return True

def determine_actions(qrels_filename, prob_rel, prob_nonrel):
    """
    Going through the QRELS, determines the action that should be taken for each.
    """
    qrels = open(qrels_filename, 'r')
    
    for line in qrels:
        line = line.strip()
        line = line.split()
        
        if int(line[3]) == 0:
            judgment = roll_die(prob_nonrel)
        else:
            judgment = roll_die(prob_rel)
        
        print "{0} {1} {2} {3}".format(line[0], line[1], line[2], 1 if judgment else 0)
    
    qrels.close()

def usage(script_name):
    """
    Sends the usage to stdout and terminates.
    
    Takes a QRELS file, and two parameters - the probability if the document/snippet is relevant, and if it is non-relevant.
    Then rolls the die with those probabilities.
    """
    print "Usage: {0} <qrels_file> <prob_rel> <prob_nonrel> <seed> <seed_base_value>".format(script_name)
    sys.exit(-1)

if __name__ == '__main__':
    if len(sys.argv) == 6:
        qrels_filename = sys.argv[1]
        prob_rel = float(sys.argv[2])
        prob_nonrel = float(sys.argv[3])
        seed = int(sys.argv[4]) + int(sys.argv[5])
    else:
        usage(sys.argv[0])  # Terminates process if called
    
    import random
    random.seed(seed)
    determine_actions(qrels_filename, prob_rel, prob_nonrel)