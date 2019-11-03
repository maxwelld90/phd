import sys
import os
from datetime import datetime

def setup_django_env(path_to_treconomics_project):
    '''
    Sets up the Django environment so the Django ORM can be used to query the database.
    '''
    sys.path.append(path_to_treconomics_project)
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'treconomics_project.settings')
    
    import django
    django.setup()

    
def get_query_result_performance(qrels, results, topic_num):
    """
    :param qrels: ifind.seeker.trec_qrel_handler.TrecQrelHandler
    :param results:
    :param topic_num:
    :return:
    """
    i = 0
    rels_found = 0
    for r in results:
        i = i + 1
        val = qrels.get_value(topic_num, r.docid)
        if val > 0:
            rels_found = rels_found + 1
    return [rels_found, i]


def get_topic_relevant_count(qrels, topic_num):
    """
    :param qrels: ifind.seeker.trec_qrel_handler.TrecQrelHandler
    Returns the number of documents considered relevant for topic topic_num.
    """
    count = 0

    for document in qrels.get_doc_list(topic_num):
        if qrels.get_value(topic_num, document) > 0:
            count = count + 1

    return count


def is_relevant(qrels, topic_num, docid):
    """
    :param qrels: ifind.seeker.trec_qrel_handler.TrecQrelHandler
    :param topic_num:
    :param docid:
    :return: 1 is relevant, 0 if not relevant
    """
    qrel_value = qrels.get_value_if_exists(topic_num, docid)
    
    if qrel_value is None:
        return -1  # No judgement
    
    return qrel_value
    # if qrels.get_value_if_exists(topic_num, docid) > 0:
    #     return 1
    # else:
    #     return 0


def calculate_precision(qrels, results, topic_num, k):
    """
    Returns a float representing the precision @ k for a given topic, topic_num, and set of results, results.
    """
    results = results[0:k]
    no_relevant = get_query_result_performance(qrels, results, topic_num)[0]
    return round(no_relevant / float(k),3)


def get_query_performance_metrics(qrels, results, topic_num):
    """
    Returns performance metrics for a given list of results, results, and a TREC topic, topic_num.
    List returned is in the format [p@1, p@2, p@3, p@4, p@5, p@10, p@15, p@20, p@125, p@30, p@40, p@50, Rprec, total rel. docs]
    """

    atk = [1,2,3,4,5,10,15,20,25,30,40,50]

    patk = []

    for k in atk:
        p =  str(calculate_precision(qrels, results, topic_num, k))
        patk.append(p)

    """
    p_at_1 = str(calculate_precision(qrels, results, topic_num, 1))
    p_at_2 = str(calculate_precision(qrels, results, topic_num, 2))
    p_at_3 = str(calculate_precision(qrels, results, topic_num, 3))
    p_at_4 = str(calculate_precision(qrels, results, topic_num, 4))
    p_at_5 = str(calculate_precision(qrels, results, topic_num, 5))
    p_at_10 = str(calculate_precision(qrels, results, topic_num, 10))
    p_at_15 = str(calculate_precision(qrels, results, topic_num, 15))
    p_at_20 = str(calculate_precision(qrels, results, topic_num, 20))
    p_at_25 = str(calculate_precision(qrels, results, topic_num, 25))
    p_at_30 = str(calculate_precision(qrels, results, topic_num, 30))
    p_at_40 = str(calculate_precision(qrels, results, topic_num, 40))
    p_at_50 = str(calculate_precision(qrels, results, topic_num, 50))
    """

    total_relevant_docs = get_topic_relevant_count(qrels, topic_num)
    r_prec = str(calculate_precision(qrels, results, topic_num, total_relevant_docs))

    patk.append(r_prec)
    patk.append(str(total_relevant_docs))

    return patk


def get_time_diff(past,present):
    FMT = "%Y-%m-%d %H:%M:%S,%f"

    if past == 0:
        return 0.0

    if past > present:
        return 0.0
    else:
        diff = ((datetime.strptime(str(present),FMT)-datetime.strptime(str(past),FMT)))
        #print diff.seconds, diff.microseconds
        t = float(diff.seconds) + (float(diff.microseconds) / 1000000)
        return round(t,2)