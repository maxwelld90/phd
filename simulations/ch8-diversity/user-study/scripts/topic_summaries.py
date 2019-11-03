import re
import os
import sys
from ifind.seeker.trec_qrel_handler import TrecQrelHandler
from utils import setup_django_env

SELECTED_TOPIC = 'ALL'
OUTPUT_KEYS = [
    'interface',
    'diversity',
    'order',
    'topic',
    
    'query_count',
    
    'pages',
    'pages_per_query',
    'doc_count',
    'doc_count_per_query',
    'doc_depth_per_query',
    'doc_rel_count',
    'doc_rel_depth_per_query',
    'doc_rel_depth_per_serp',
    'hover_count_per_query',
    'hover_depth_per_query',
    'hover_trec_rel_count',
    'hover_trec_nonrel_count',
    'rels_found',
    'nrels_found',
    'clicked_rel',
    'clicked_nrel',
    'abandoned_serps',
    
    'query_time',
    'serp_time',
    'doc_time',
    'mark_time',
    'mark_time_limited',
    'serp_examination_time',
    'serp_examination_time_limited',
    
    'time_per_query',
    'time_per_doc',
    'time_per_serp',
    'time_per_snippet',
    'time_per_mark',
    'time_per_mark_limited',
    'time_per_serp_examination',
    'time_per_serp_examination_limited',
    
    'pmr',
    'pmn',
    'pcr',
    'pcn',
]


def create_user_dict():
    '''
    Returns a new dictionary object, consisting with keys
    '''
    return_dict = {}

    for key in OUTPUT_KEYS:
        return_dict[key] = 0.0
    
    return_dict['user_id'] = 0
    return_dict['snippet_len'] = 0
    return_dict['query_count'] = 0.0
    return_dict['pages'] = 0.0
    return_dict['doc_count'] = 0.0
    return_dict['doc_depth'] = []
    return_dict['doc_rel_count'] = 0.0
    return_dict['doc_rel_depth'] = []
    return_dict['hover_count'] = 0.0
    return_dict['hover_trec_rel_count'] = 0.0
    return_dict['hover_trec_nonrel_count'] = 0.0
    return_dict['hover_depth'] = []
    return_dict['rels_found'] = 0.0
    return_dict['nrels_found'] = 0.0
    return_dict['clicked_rel'] = 0.0
    return_dict['clicked_nrel'] = 0.0
    return_dict['abandoned_serps'] = 0
    
    return_dict['query_time'] = 0.0
    return_dict['serp_time'] = 0.0
    return_dict['doc_time'] = 0.0
    return_dict['mark_time'] = 0.0
    return_dict['mark_time_limited'] = 0.0
    return_dict['serp_examination_time'] = 0.0
    return_dict['serp_examination_time_limited'] = 0.0
    
    return return_dict

def generate_output(summaries, separator=' ', include_header=True):
    '''
    Creates an output string, consisting of the user account, followed by the values in the order or OUTPUT_KEYS.
    Each user's details are separated by a newline, courtesy of os.linesep.
    Optional parameter separator allows you to specify the separator - could be a comma, tab (\t) or simply a space.
    Can also specify whether to include a header line with the include_header parameter.
    '''
    output_str = ''

    if len(summaries) == 0:
        output_str = 'NO USERS FOUND'
    else:
        if include_header:
            output_str = 'user{0}'.format(separator)

            for key in OUTPUT_KEYS:
                output_str += '{0}{1}'.format(key, separator)

            output_str = output_str[:-1]
            output_str += os.linesep

        for user in summaries:
            for topic in summaries[user]:
                topic_str = '{0}{1}'.format(user, separator)
                
                for key in OUTPUT_KEYS:
                    val_to_disp = summaries[user][topic][key]
                
                    if type(val_to_disp) == float:
                        val_to_disp = '{0:3.2f}'.format(val_to_disp)
                
                    topic_str += '{0}{1}'.format(val_to_disp, separator)

                topic_str = topic_str[:-1]
                topic_str += os.linesep
                output_str += topic_str

    return output_str

def generate_user_summaries(input_file):
    '''
    Generates a list of user details with related information about each account from the given input file.
    '''
    summaries = {}
    user_id_index = 0
    user_id_mappings = {}
    
    for line in input_file:
        if line.startswith('username ') or line.startswith('userid '):
            continue
        
        split_line = line.split(' ')
        user = split_line[0]
        
        if user not in user_id_mappings:
            user_id_mappings[user] = user_id_index
            user_id_index = user_id_index + 1
        
        user_id = user_id_mappings[user]
        diversity = int(split_line[3])
        topic = split_line[5]
        order = split_line[4]
        
        if user not in summaries:
            summaries[user] = {}
        
        if topic not in summaries[user]:
            summaries[user][topic] = create_user_dict()
            summaries[user][topic]['order'] = order
            summaries[user][topic]['topic'] = topic
            summaries[user][topic]['diversity'] = diversity
        
        summaries[user][topic]['user_id'] = user_id
        summaries[user][topic]['diversity'] = diversity
        summaries[user][topic]['query_count'] += 1
        summaries[user][topic]['pages'] += int(split_line[7])
        summaries[user][topic]['doc_count'] += int(split_line[8])
        summaries[user][topic]['doc_depth'].append(int(split_line[9]))
        summaries[user][topic]['doc_rel_count'] += int(split_line[10])
        summaries[user][topic]['doc_rel_depth'].append(int(split_line[11]))
        summaries[user][topic]['hover_count'] += int(split_line[12])
        summaries[user][topic]['hover_trec_rel_count'] += int(split_line[13])
        summaries[user][topic]['hover_trec_nonrel_count'] += int(split_line[14])
        
        summaries[user][topic]['hover_depth'].append(int(split_line[15]))
        summaries[user][topic]['rels_found'] += int(split_line[16])
        summaries[user][topic]['nrels_found'] += int(split_line[17])
        summaries[user][topic]['clicked_rel'] += int(split_line[18])
        summaries[user][topic]['clicked_nrel'] += int(split_line[19])
        
        summaries[user][topic]['abandoned_serps'] += int(split_line[20])
        
        summaries[user][topic]['query_time'] += float(split_line[21])
        summaries[user][topic]['doc_time'] += float(split_line[22])
        summaries[user][topic]['serp_time'] += float(split_line[23])
        summaries[user][topic]['mark_time'] += float(split_line[24])
        summaries[user][topic]['mark_time_limited'] += float(split_line[25])
        summaries[user][topic]['serp_examination_time'] += float(split_line[26])
        summaries[user][topic]['serp_examination_time_limited'] += float(split_line[27])
        
    for user in summaries:
        for topic in summaries[user]:
            q = float(summaries[user][topic]['query_count'])
            d = float(summaries[user][topic]['doc_count'])
            p = float(summaries[user][topic]['pages'])
        
            if d < 1.0:
                d = 1.0
            if q < 1.0:
                q = 1.0
            
            summaries[user][topic]['pages_per_query'] = float(summaries[user][topic]['pages']) / q
            summaries[user][topic]['doc_count_per_query'] = float(summaries[user][topic]['doc_count']) / q
            summaries[user][topic]['doc_depth_per_query'] = float(sum(summaries[user][topic]['doc_depth'])) / q
            summaries[user][topic]['doc_rel_depth_per_query'] = float(sum(summaries[user][topic]['doc_rel_depth'])) / q
            summaries[user][topic]['doc_rel_depth_per_serp'] = float(sum(summaries[user][topic]['doc_rel_depth'])) / p
            
            summaries[user][topic]['hover_count_per_query'] = float(summaries[user][topic]['hover_count']) / q
            summaries[user][topic]['hover_depth_per_query'] = float(sum(summaries[user][topic]['hover_depth']) ) / q
            summaries[user][topic]['time_per_query'] = summaries[user][topic]['query_time'] / q
            summaries[user][topic]['time_per_serp'] = summaries[user][topic]['serp_time'] / p
            summaries[user][topic]['time_per_doc'] = summaries[user][topic]['doc_time'] / d
            
            # # Fix an anomaly where a user marked a document, but then subsequently retracted that judgement.
            # if user == 'AK2C9AX5QJWUU' and topic == '341':
            #     summaries[user][topic]['doc_rel_count'] = 1
            
            m = float(summaries[user][topic]['doc_rel_count'])
            
            if summaries[user][topic]['mark_time'] == 0.0:
                summaries[user][topic]['time_per_mark'] = 0.0
                summaries[user][topic]['time_per_mark_limited'] = 0.0
            else:
                summaries[user][topic]['time_per_mark'] = float(summaries[user][topic]['mark_time']) / m
                summaries[user][topic]['time_per_mark_limited'] = float(summaries[user][topic]['mark_time_limited']) / m
            
            summaries[user][topic]['time_per_serp_examination'] = float(summaries[user][topic]['serp_examination_time']) / p
            summaries[user][topic]['time_per_serp_examination_limited'] = float(summaries[user][topic]['serp_examination_time_limited']) / p
            
            # Time per snippet - not too sure about this.
            # We take the total number of recorded hover events for the given user/topic combination, and divide the SERP time spent by that value.
            
            if summaries[user][topic]['hover_count'] == 0:
                summaries[user][topic]['time_per_snippet'] = 0.0
            else:
                summaries[user][topic]['time_per_snippet'] = summaries[user][topic]['serp_time'] / summaries[user][topic]['hover_count']
            
            summaries[user][topic]['pmr'] = 0.0
            summaries[user][topic]['pmn'] = 0.0
            summaries[user][topic]['pcr'] = 0.0
            summaries[user][topic]['pcn'] = 0.0
            
            if summaries[user][topic]['clicked_rel'] > 0:
                summaries[user][topic]['pmr'] = summaries[user][topic]['rels_found'] / summaries[user][topic]['clicked_rel']
            
            if summaries[user][topic]['clicked_nrel'] > 0:
                summaries[user][topic]['pmn'] = summaries[user][topic]['nrels_found'] / summaries[user][topic]['clicked_nrel']
            
            if summaries[user][topic]['hover_trec_rel_count'] > 0:
                summaries[user][topic]['pcr'] = summaries[user][topic]['clicked_rel'] / summaries[user][topic]['hover_trec_rel_count']
            
            if summaries[user][topic]['hover_trec_nonrel_count'] > 0:
                summaries[user][topic]['pcn'] = summaries[user][topic]['clicked_nrel'] / summaries[user][topic]['hover_trec_nonrel_count']
            
    return summaries

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'Usage: {0} <query_summary_file>'.format(sys.argv[0])
    else:
        try:
            f = open(sys.argv[1], 'r')
        except IOError:
            print 'Input file \'{0}\' not found or could not be opened.'.format(sys.argv[1])
            sys.exit(1)
        
        user_summaries = generate_user_summaries(f)
        print generate_output(user_summaries, separator=',')