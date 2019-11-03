import os
import re
import sys
import utils
from ifind.seeker.trec_qrel_handler import TrecQrelHandler

SEPARATOR = ","

SIM_OUTPUT_FIELDS = {
    'out': [
        'runid',
        'num_q',
        'num_ret',
        'num_rel',
        'num_rel_ret',
        'map',
        'gm_map',
        'rprec',
        'bpref',
        'recip_rank',
        'iprec_at_recall_0.00',
        'iprec_at_recall_0.10',
        'iprec_at_recall_0.20',
        'iprec_at_recall_0.30',
        'iprec_at_recall_0.40',
        'iprec_at_recall_0.50',
        'iprec_at_recall_0.60',
        'iprec_at_recall_0.70',
        'iprec_at_recall_0.80',
        'iprec_at_recall_0.90',
        'iprec_at_recall_1.00',
        'p_5',
        'p_10',
        'p_15',
        'p_20',
        'p_30',
        'p_100',
        'p_200',
        'p_500',
        'p_1000'],
    'log': ['total_queries_issued',
            'total_snippets_examined',
            'total_documents_examined',
            'total_documents_marked_relevant'],
    'calculatable': [
        'accuracy',
        'wellness',
        'cg',
        'dcg',
        'total_time',
        'depth_query',
        'marked_trec_rel'
    ],
}

def strip_xml_file(config_file_path):
    """
    Takes the /simulation.xml part from the given path.
    """
    last_separator_pos = config_file_path.rfind(os.sep)
    path = config_file_path[:last_separator_pos]
    
    return path


def get_path_components(base_directory, experiment_path, expected_path_parameters):
    """
    Returns information related to the path up to the simulation configuration file.
    """
    experiment_path = experiment_path[len(base_directory):]
    experiment_path_parameters = experiment_path.split(os.sep)
    experiment_path_parameters = filter(None, experiment_path_parameters)
    
    if (len(experiment_path_parameters) != len(expected_path_parameters)):
        print "WARNING: Path parameters length doesn't equal the given path."
    
    i = 0
    return_dict = {}
    
    for parameter in expected_path_parameters:
        path_name = parameter['path_name']
        value_type = parameter['type']
        output_value = parameter['output_value']
        
        path_value = experiment_path_parameters[i]
        
        if experiment_path_parameters[i].startswith(path_name):
            path_value = path_value[len(path_name):]
            cast_value = value_type(path_value)
            
            if path_name in return_dict:
                print "WARNING: {path_name} already exists".format(path_name=path_name)
            
            return_dict[output_value] = cast_value
        
        i = i + 1
    
    return return_dict

def get_log_data(simulation_output_path, base_filename):
    return_dict = {'total_queries_issued': 0,
                   'total_snippets_examined': 0,
                   'total_documents_examined': 0,
                   'total_documents_marked_relevant': 0,
                   'total_attractive_serp_impressions': 0,
                   'total_unattractive_serp_impressions': 0}
    
    path = os.path.join(simulation_output_path, base_filename)
    path = "{path}.log".format(path=path)
    
    f = open(path, 'r')
    
    for line in f:
        line = line.strip().split(' ')
        
        if line[0] == 'INFO':
            if len(line) != 3:
                continue
            
            line[1] = line[1].lower()
            return_dict[line[1]] = int(line[2])
    
    f.close()
    
    return return_dict


def get_trec_eval_data(simulation_output_path, base_filename):
    return_dict = {#'num_q': 0,
                   # 'num_ret': 0,
                   # 'num_rel': 0,
                   # 'num_rel_ret': 0,
                   'map': 0,
                   # 'gm_map': 0,
                   'rprec': 0,
                   # 'bpref': 0,
                   # 'recip_rank': 0,
                   # 'iprec_at_recall_0.00': 0,
                   # 'iprec_at_recall_0.10': 0,
                   # 'iprec_at_recall_0.20': 0,
                   # 'iprec_at_recall_0.30': 0,
                   # 'iprec_at_recall_0.40': 0,
                   # 'iprec_at_recall_0.50': 0,
                   # 'iprec_at_recall_0.60': 0,
                   # 'iprec_at_recall_0.70': 0,
                   # 'iprec_at_recall_0.80': 0,
                   # 'iprec_at_recall_0.90': 0,
                   # 'iprec_at_recall_1.00': 0,
                   # 'p_5': 0,
                   'p_10': 0,
                   # 'p_15': 0,
                   # 'p_20': 0,
                   # 'p_30': 0,
                   'p_100': 0,
                   # 'p_200': 0,
                   # 'p_500': 0,
                   'p_1000': 0,}
    
    path = os.path.join(simulation_output_path, base_filename)
    path = "{path}.out".format(path=path)
    
    f = open(path, 'r')
    
    for line in f:
        if line.startswith('runid'):
            continue
        
        line = line.strip().split('\t')
        key = line[0].strip().lower()
        
        if key in return_dict.keys():
            return_dict[key] = float(line[2])
    
    return return_dict


def get_simulation_output_components(simulation_output_path, qrel_handler):
    """
    
    """
    all_output_files = [f for f in os.listdir(simulation_output_path) if os.path.isfile(os.path.join(simulation_output_path, f))]
    
    if 'COMPLETED' not in all_output_files:
        print "WARNING: Experiment not completed"
    
    # Remove guff files from list
    all_output_files.pop(all_output_files.index('COMPLETED'))
    all_output_files.pop(all_output_files.index('CREATED'))
    
    observed_users = []
    return_list = []
    
    no_extension_list = []
    
    for filename in all_output_files:
        no_ext = filename[:filename.rfind('.')]
        
        if no_ext not in no_extension_list:
            no_extension_list.append(no_ext) # This needs to be done before the loop starts.
    
    for filename_noextension in no_extension_list:
        # Get the base filename without extension.
        filename_noextension_path = os.path.join(simulation_output_path, filename_noextension)
        
        if filename_noextension not in observed_users:
            observed_users.append(filename_noextension)
            
            # Get data from experiment output files.
            log_data = get_log_data(simulation_output_path, filename_noextension)
            trec_eval_data = get_trec_eval_data(simulation_output_path, filename_noextension)
            
            # Get the user's parameters.
            user_parameters = {}
            filename_split = filename_noextension.split('-u-')
            #print filename_noextension_path
            #print filename_split[0].split('-')[2]
            topic = filename_split[0].split('-')[2]
            #print filename_split
            params = filename_split[1]
            
            pattern = re.compile("([a-z][0-9.]+)")
            matches = pattern.findall(params)
            
            for match_string in matches:
                match_parameter = match_string[0]
                match_value = match_string[1:]
            
                user_parameters[match_parameter] = match_value
            
            # Calculate additional interesting measures.
            ranking_judgements = utils.get_ranking_judgments(qrel_handler, topic, filename_noextension_path)
            
            calculated = {}
            calculated['marked_trec_rel'] = utils.calculate_marked_trec_rel(qrel_handler, filename_noextension_path, topic)
            calculated['accuracy'] = utils.calculate_accuracy(filename_noextension_path, calculated['marked_trec_rel'], log_data['total_documents_marked_relevant'])
            calculated['wellness'] = utils.calculate_wellness(filename_noextension_path, calculated['marked_trec_rel'], log_data['total_documents_marked_relevant'], qrel_handler, topic)
            calculated['cg'] = utils.calculate_cg(qrel_handler, topic, filename_noextension_path)
            calculated['dcg'] = utils.calculate_dcg(qrel_handler, topic, filename_noextension_path)
            calculated['total_time'] = utils.calculate_total_time(filename_noextension_path)
            calculated['depth_per_query'] = utils.calculate_depth_query(filename_noextension_path)
            calculated['serp_view_probability'] = log_data['total_attractive_serp_impressions'] / float(log_data['total_queries_issued'])
            calculated['serp_abandon_probability'] = log_data['total_unattractive_serp_impressions'] / float(log_data['total_queries_issued'])
            
            # Whack everything into a dictionary for processing.
            
            #print user_parameters
            return_list.append({'user_parameters': user_parameters, 'log_data': log_data, 'trec_eval_data': trec_eval_data, 'calculated': calculated, 'topic': topic})
    
    return return_list


def get_order_lists(qrel_handler, config_list, expected_path_parameters):
    lists = {'path': [], 'user': [], 'calculated': [], 'trec_eval': [], 'log_data': []}
    
    for entry in expected_path_parameters:
        lists['path'].append(entry['output_value'])
    
    for config_file_path in config_list:
        experiment_path = strip_xml_file(config_file_path)
        experiment_output_path = os.path.join(experiment_path, 'out')
        experiment_components = get_simulation_output_components(experiment_output_path, qrel_handler)
        
        lists['calculated'] = experiment_components[0]['calculated'].keys()  # The same for every experiment
        lists['trec_eval'] = experiment_components[0]['trec_eval_data'].keys()  # The same
        lists['log_data'] = experiment_components[0]['log_data'].keys()  # And again
        
        # THIS IS SLOW, BUT IDC
        for config in experiment_components:
            for k in config['user_parameters']:
                if k not in lists['user']:
                    lists['user'].append(k)
        
        #break
    
    return lists


def generate_experiment_line(orders, path_components, topic, user_parameters, log_data, trec_eval_data, calculated):
    """
    path, user, log_data, trec_eval, calculated
    """
    return_str = ""
    #print path_components
    for val in orders['path']:
        return_str = "{return_str},{val}".format(return_str=return_str, val=path_components[val])
    
    return_str = "{return_str},{topic}".format(return_str=return_str, topic=topic)
    
    # This is where a parameter might not exist; so we replace it with a big fat zero.
    # Should be aware of this when analysing the data.
    for val in orders['user']:
        if val not in user_parameters:
            use_val = 0
        else:
            use_val = user_parameters[val]
        
        return_str = "{return_str},{val}".format(return_str=return_str, val=use_val)
    
    for val in orders['log_data']:
        return_str = "{return_str},{val}".format(return_str=return_str, val=log_data[val])
    
    for val in orders['trec_eval']:
        return_str = "{return_str},{val}".format(return_str=return_str, val=trec_eval_data[val])
    
    for val in orders['calculated']:
        return_str = "{return_str},{val}".format(return_str=return_str, val=calculated[val])
    
    return return_str[1:]

def main(base_directory, qrels_path):
    """
    Does the magic.
    """
    config_list = utils.get_simulation_configs(base_directory)
    
    ######
    ###### Different for each experiment ######
    ######
    
    expected_path_parameters = [{'path_name': 'u', 'type': int, 'output_value': 'userid'},
                                {'path_name': 't', 'type': int, 'output_value': 'snip_len'},
                                {'path_name': 'se', 'type': int, 'output_value': 'se'},
                                {'path_name': 'ser', 'type': int, 'output_value': 'serp_run'},
                                {'path_name': 'ti', 'type': int, 'output_value': 'time_limit'},
                                {'path_name': 'ss', 'type': int, 'output_value': 'ss'},
                                {'path_name': 'ssr', 'type': int, 'output_value': 'ss_run'},
                                {'path_name': 'dm', 'type': int, 'output_value': 'decision_maker'},
                                {'path_name': 'dmr', 'type': int, 'output_value': 'decision_maker_run'},
                                {'path_name': 'qs', 'type': int, 'output_value': 'qs'}]
    
    ######
    ###### End section ######
    ######
    
    qrel_handler = TrecQrelHandler(qrels_path)
    
    # Inefficent, but I do this twice to get the list of parameters that are used to construct an output file.
    orders = get_order_lists(qrel_handler, config_list, expected_path_parameters)

    # Print the header line
    order_str = ""

    for val in orders['path']:
        order_str = "{order_str},{val}".format(order_str=order_str, val=val)

    order_str = "{order_str},topic".format(order_str=order_str)

    for val in orders['user']:
        order_str = "{order_str},u_{val}".format(order_str=order_str, val=val)

    for val in orders['log_data']:
        order_str = "{order_str},{val}".format(order_str=order_str, val=val)

    for val in orders['trec_eval']:
        order_str = "{order_str},{val}".format(order_str=order_str, val=val)

    for val in orders['calculated']:
        order_str = "{order_str},{val}".format(order_str=order_str, val=val)

    print order_str[1:]
    
    for config_file_path in config_list:
        experiment_path = strip_xml_file(config_file_path)
        experiment_output_path = os.path.join(experiment_path, 'out')
        path_components = get_path_components(base_directory, experiment_path, expected_path_parameters)
        experiment_components = get_simulation_output_components(experiment_output_path, qrel_handler)
        
        #print experiment_path
        
        
        for comb in experiment_components:
           print generate_experiment_line(orders, path_components, comb['topic'], comb['user_parameters'], comb['log_data'], comb['trec_eval_data'], comb['calculated'])
        
        #break

if __name__ == '__main__':
    base_directory = sys.argv[1]
    qrels_path = sys.argv[2]
    main(base_directory, qrels_path)
