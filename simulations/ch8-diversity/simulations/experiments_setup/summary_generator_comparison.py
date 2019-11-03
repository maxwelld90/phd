import re
import os
import sys
import utils
import pandas
from ifind.seeker.trec_qrel_handler import TrecQrelHandler
from ifind.seeker.trec_diversity_qrel_handler import EntityQrelHandler

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


def get_log_data(simulation_output_path, base_filename, qrels_handler, diversity_qrels_handler, topic):
    """
    Returns data from the log file on a per-query basis.
    """
    path = os.path.join(simulation_output_path, base_filename)
    path = "{path}.log".format(path=path)
    query_details = []
    observed_entities = []
    observed_entities_doc = []
    
    f = open(path, 'r')
    
    for line in f:
        line = line.strip().split(' ')
        action = line[1]
        
        if action == 'QUERY':
            query_details.append({'terms': ' '.join(line[4:]), 'hover_depth': 0, 'click_depth': 0, 'cg': 0, 'new_entities': 0, 'entities_docs': 0, 'saved_trec_rel': 0})
        
        if action == 'SNIPPET':
            query_details[-1]['hover_depth'] = query_details[-1]['hover_depth'] + 1
        
        if action == 'DOC' and line[4] == 'EXAMINING_DOCUMENT':
            query_details[-1]['click_depth'] = query_details[-1]['hover_depth']
        
        if action == 'MARK' and line[4] == 'CONSIDERED_RELEVANT':
            document_gain = qrels_handler.get_value(topic, line[5])
            query_details[-1]['cg'] = query_details[-1]['cg'] + document_gain
            
            if qrels_handler.get_value(topic, line[5]) > 0:
                query_details[-1]['saved_trec_rel'] = query_details[-1]['saved_trec_rel'] + 1
            
            entities_in_doc = diversity_qrels_handler.get_mentioned_entities_for_doc(topic, line[5])
            
            for entity in entities_in_doc:
                if entity not in observed_entities:
                    query_details[-1]['new_entities'] = query_details[-1]['new_entities'] + 1
            
            for entity in entities_in_doc:
                if entity not in observed_entities_doc:
                    query_details[-1]['entities_docs'] = query_details[-1]['entities_docs'] + 1
                    break
            
    
    f.close()
    return query_details
    

def get_simulation_output_components(simulation_output_path, qrels_handler, diversity_qrels_handler):
    """
    Collate data on a per-query basis from the log files in the given simulation output path.
    SO FRIGGING CONFUSING SOMETIMES
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
            no_extension_list.append(no_ext)
    
    for filename_noextension in no_extension_list:
        # Get the base filename without extension.
        filename_noextension_path = os.path.join(simulation_output_path, filename_noextension)
        
        if filename_noextension not in observed_users:
            observed_users.append(filename_noextension)
            
            # User parameters (from the simulation user, confusing terminology I know)
            user_parameters = {}
            filename_split = filename_noextension.split('-u-')
            topic = filename_split[0].split('-')[2]
            params = filename_split[1]
            
            # Get the data from experiment output files.
            log_data = get_log_data(simulation_output_path, filename_noextension, qrels_handler, diversity_qrels_handler, topic)
            
            pattern = re.compile("([a-z][0-9.]+)")
            matches = pattern.findall(params)
            
            for match_string in matches:
                match_parameter = match_string[0]
                match_value = match_string[1:]
                
                user_parameters[match_parameter] = match_value
            
            return_list.append({'query_data': log_data, 'user_parameters': user_parameters, 'topic': topic})
    
    return return_list


def apply_queryids(path_components, experiment_components, rw_queries):
    """
    Loops through the experiment combinations, applying the correct queryid to all the queries.
    """
    userid = path_components['userid']
    
    for comb in experiment_components:
        topic = comb['topic']
        query_data = comb['query_data']
        filtered_rw_queries = rw_queries[(rw_queries['userid'] == int(userid)) & (rw_queries['topic'] == int(topic))]
        
        for query in query_data:
            terms = query['terms']
            filtered_rw_terms = filtered_rw_queries[filtered_rw_queries['query_terms'] == terms]
            queryid = filtered_rw_terms.iloc[0]['queryid']
            
            query['queryid'] = queryid
    
    return experiment_components
    

def generate_combination_output(path_components, combination):
    """
    Returns a string that can be used as output for a given combination.
    Will include more than a single line per user combination -- each line represents a single query.
    """
    return_str = ''
    
    for query in combination['query_data']:
        if 'n' not in combination['user_parameters']:
            n = 0
        else:
            n = combination['user_parameters']['n']
        
        if 'd' not in combination['user_parameters']:
            d = 0
        else:
            d = combination['user_parameters']['d']
        
        if 'r' not in combination['user_parameters']:
            r = 0
        else:
            r = combination['user_parameters']['r']
        
        if 't' not in combination['user_parameters']:
            t = 0
        else:
            t = combination['user_parameters']['t']
        
        if 'g' not in combination['user_parameters']:
            g = 0
        else:
            g = combination['user_parameters']['g']
        
        if 'p' not in combination['user_parameters']:
            p = 0
        else:
            p = combination['user_parameters']['p']
        
        return_str = '{return_str}{userid},{queryid},{topic},{interface},{se},{ser},{ss},{ssr},{decision_maker},{decision_maker_run},{u_n},{u_d},{u_r},{u_t},{u_g},{u_p},{click_depth},{hover_depth},{cg},{new_entities},{entities_docs},{saved_trec_rel}{linesep}'.format(
            return_str=return_str,
            userid=path_components['userid'],
            queryid=query['queryid'],
            topic=combination['topic'],
            interface=path_components['interface'],
            se=path_components['se'],
            ser=path_components['serp_run'],
            ss=path_components['ss'],
            ssr=path_components['ss_run'],
            decision_maker=path_components['decision_maker'],
            decision_maker_run=path_components['decision_maker_run'],
            u_n=n,
            u_d=d,
            u_r=r,
            u_t=t,
            u_g=g,
            u_p=p,
            click_depth=query['click_depth'],
            hover_depth=query['hover_depth'],
            cg=query['cg'],
            new_entities=query['new_entities'],
            entities_docs=query['entities_docs'],
            saved_trec_rel=query['saved_trec_rel'],
            linesep=os.linesep
        )
    
    return return_str.strip()
    
    

def main(base_directory, rw_queries_path, qrels_handler, diversity_qrels_handler):
    """
    Does the magic.
    """
    config_list = utils.get_simulation_configs(base_directory)
    rw_queries = pandas.read_csv(rw_queries_path, sep=',')
    
    
    ######
    ###### Different for each experiment ######
    ######
    
    expected_path_parameters = [{'path_name': 'u', 'type': int, 'output_value': 'userid'},
                                {'path_name': 'i', 'type': int, 'output_value': 'interface'},
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
    
    # Manually written the order string -- ensure that generate_combination_output() produces a string of the same values.
    order_str = 'userid,queryid,topic,interface,se,ser,ss,ssr,decision_maker,decision_maker_run,u_n,u_d,u_r,u_t,u_g,u_p,click_depth,hover_depth,cg,new_entities,docs_with_new_entity,saved_trec_rel'
    print order_str
    
    for config_file_path in config_list:
        experiment_path = strip_xml_file(config_file_path)
        experiment_output_path = os.path.join(base_directory, experiment_path, 'out')
        path_components = get_path_components(base_directory, experiment_path, expected_path_parameters)
        
        experiment_components = get_simulation_output_components(experiment_output_path, qrels_handler, diversity_qrels_handler)
        experiment_components = apply_queryids(path_components, experiment_components, rw_queries)
        
        for comb in experiment_components:
            print generate_combination_output(path_components, comb)
    

if __name__ == '__main__':
    base_directory = sys.argv[1]
    rw_queries_path = sys.argv[2]
    qrels_path = sys.argv[3]
    eval_diversity_qrels_path = sys.argv[4]
    
    qrels_handler = TrecQrelHandler(qrels_path)
    diversity_qrels_handler = EntityQrelHandler(eval_diversity_qrels_path)
    
    main(base_directory, rw_queries_path, qrels_handler, diversity_qrels_handler)