import os
import errno
import fnmatch
from math import log

def get_topics_str(topics, use_background=False):
    if use_background:
        f = open('base_files/topic_withbackground.xml')
    else:
        f = open('base_files/topic.xml')
    
    base_str = f.read()
    complete_str = ""
    f.close()
    
    for topic in topics:
        topic_str = base_str
        
        topic_str = topic_str.format(topicID=topic,
                                     topicFilename=topics[topic]['filename'],
                                     topicQrels=topics[topic]['qrelsFilename'])
        
        complete_str = "{complete_str}{topic_str}".format(complete_str=complete_str, topic_str=topic_str)
    
    return complete_str


def make_attribute_string(attribute, **kwargs):
    f = open('base_files/attribute.xml', 'r')
    attribute_base = f.read()
    f.close()
    
    attr = attribute_base.format(name=attribute['name'],
                                 attribute_type=attribute['type'],
                                 value=attribute['value'],
                                 is_argument=attribute['is_argument'])
    
    return attr


def replace_string_values(base_str, replace_dict):
    """
    Does the second pass string replacement.
    This function looks for those strings wrapped in double curly braces, like {{viewport_size}}.
    """
    modified_str = base_str
    
    for key in replace_dict.keys():
        match_str = "{{{{{key}}}}}".format(key=key)
        replace_value = str(replace_dict[key])
        
        modified_str = modified_str.replace(match_str, replace_value)
    
    return modified_str


def mkdir_p(path):
    """
    http://stackoverflow.com/a/600612
    """
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

def get_simulation_configs(base_dir):
    """
    Returns a list of all the simulation configuration files found from the base directory.
    This function walks from the base directory - it is recursive, and looks through all children.
    
    Solution from: http://stackoverflow.com/a/2186565/997985 (2015-02-07)
    """
    return_list = []
    
    for root, dirnames, filenames in os.walk(base_dir):
        for filename in fnmatch.filter(filenames, 'simulation.xml'):
            return_list.append(os.path.join(root, filename))
    
    return return_list

def calculate_marked_trec_rel(qrel_handler, base_filename, topic):
    """
    Works out how many documents marked were TREC relevant.
    """
    log_filename = '{0}.log'.format(base_filename)
    count = 0
    
    f = open(log_filename, 'r')
    
    for line in f:
        line = line.strip().split()
        
        if line[1] == 'MARK':
            docid = line[5]
            judgement = qrel_handler.get_value(topic, docid)
            
            if judgement > 0:
                count = count + 1
    
    f.close()
    return count

def calculate_accuracy(base_filename, num_marked_rel, num_marked):
    """
    Given the base filename, calculates the accuracy for the simulated user over the given run.
    """
    # num_marked_rel = float(process_calculatable_field('marked_trec_rel', base_filename))
    # num_marked = float(process_log_field('total_documents_marked_relevant', base_filename))
    #
    # print num_marked_rel
    # print num_marked
    # print
    if num_marked == 0:
        return 0.0
    
    return "{0:.3f}".format(num_marked_rel / float(num_marked))

def calculate_wellness(base_filename, num_marked_rel, num_marked, qrel_handler, topic):
    """
    Calculates the Max(wellness) score.
    """
    equation = 0.0 if num_marked == 0 else num_marked_rel / float(num_marked)
    cg = calculate_cg(qrel_handler, topic, base_filename)
    return cg * equation


def get_ranking_judgments(qrel_handler, topic, base_filename, use_snippets=False, relevant_only=False):
    """
    Used for cumulative gain and discounted cumulative gain calculations.
    Returns the TREC relevance judgments for the SERPs that are returned.
    
    use_snippets:  If True, uses snippets - else documents.
    relevant_only: Only uses gain for documents/snippets considered relevant.
    
    """
    log_file = open('{0}.log'.format(base_filename), 'r')
    
    serp_judgments = []
    
    for line in log_file:
        line = line.strip()
        line = line.split()
        
        if line[0] == 'ACTION':
            action = line[1]
            #if action == 'SNIPPET' or action =='DOC':
            #    print topic
            #    print line
            #    print
            
            if use_snippets and action == 'SNIPPET':
                if line[4] == 'SNIPPET_RELEVANT':
                    serp_judgments[-1].append(qrel_handler.get_value(topic, line[5]))
                else:
                    if relevant_only:
                        serp_judgments[-1].append(0)
                    else:
                        serp_judgments[-1].append(qrel_handler.get_value(topic, line[5]))
            elif not use_snippets and action == 'MARK':
                if line[4] == 'CONSIDERED_RELEVANT':
                    serp_judgments[-1].append(qrel_handler.get_value(topic, line[5]))
                else:
                    if relevant_only:
                        serp_judgments[-1].append(0)
                    else:
                        serp_judgments[-1].append(qrel_handler.get_value(topic, line[5]))
            
            if action == 'QUERY':
                serp_judgments.append([])
                documents = []
    
    log_file.close()
    return serp_judgments

def calculate_cg(qrel_handler, topic, base_filename):
    """
    Given the base filename, calculates the cumulative gain for the simulated user over the given run.
    """
    judgments = get_ranking_judgments(qrel_handler, topic, base_filename, relevant_only=True)
    total_gain = 0
    
    if len(judgments) == 0:
        return 0
    
    for query in judgments:
        total_gain = total_gain + cumulative_gain(query)
    
    return total_gain

def calculate_dcg(qrel_handler, topic, base_filename):
    """
    Given the base filename, calculates the discounted cumulative gain for the simulated user over the given run.
    """
    judgments = get_ranking_judgments(qrel_handler, topic, base_filename, relevant_only=True)
    total_gain = 0
    
    for query in judgments:
        total_gain = total_gain + discounted_cumulative_gain(query)
    
    return total_gain / float(len(judgments))

def cumulative_gain(rankings):
    """
    Implementation of cumulative gain.
    Returns the cumulative gain of a ranked list of judgments. The ranking used is the length of the list.
    """
    gain = 0
    rank = len(rankings)
    
    for i in range(0, rank):
        gain = gain + rankings[i]
    
    return gain

def discounted_cumulative_gain(rankings):
    """
    Implementation of discounted cumlative gain.
    Returns the discounted cumulative gain of a ranked list of judgments. The ranking used is the length of the list.
    """
    gain = 0
    rank = len(rankings)
    
    if rank == 0:
        return 0
    
    for i in range(1, rank):
        gain = gain + (rankings[i] / log((i + 1), 2))
    
    return rankings[0] + gain

def calculate_total_time(base_filename):
    """
    Given the base filename, returns the amount of time the simulated user spent on the given run.
    """
    log_filename = '{0}.log'.format(base_filename)
    log_file = open(log_filename, 'r')
    
    first_line = True
    prev_line = []
    
    for line in log_file:
        line = line.strip()
        line = line.split()
        
        if first_line and line[0] == 'INFO' and line[1] == 'OUT_OF_QUERIES':
            return 0
        
        if line[0] == 'INFO' and prev_line[0] == 'ACTION':
            log_file.close()
            return float(prev_line[3])
        
        prev_line = line
        first_line = False
    
    log_file.close()
    return 0

def calculate_depth_query(base_filename):
    """
    Given the base filename, returns the average depth reached per query.
    This is in turn averaged out over the total number of issued queries.
    """
    log_filename = '{0}.log'.format(base_filename)
    log_file = open(log_filename, 'r')
    
    first_line = True
    query_depths = [0]
    depth = 0
    
    for line in log_file:
        line = line.strip()
        line = line.split()
        
        if first_line and line[0] == 'INFO' and line[1] == 'OUT_OF_QUERIES':
            return 0
        
        if line[0] == 'ACTION':
            action = line[1]
            
            if action == 'QUERY':
                if len(query_depths) > 0:
                    query_depths[-1] = depth
                
                query_depths.append(0)
                depth = 0
            
            if action == 'SNIPPET':
                depth += 1
        
        if line[0] == 'INFO':
            query_depths[-1] = depth
            break
        
        first_line = False
    
    log_file.close()
    return sum(query_depths) / float(len(query_depths))