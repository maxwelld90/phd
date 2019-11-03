import os
import sys
import string
import tempfile
import subprocess
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


def calculate_precision(qrels, results, topic_num, k):
    """
    Returns a float representing the precision @ k for a given topic, topic_num, and set of results, results.
    """
    results = results[0:k]
    no_relevant = get_query_result_performance(qrels, results, topic_num)[0]
    return round(no_relevant / float(k),3)