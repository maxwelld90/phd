import sys
from ifind.seeker.trec_diversity_qrel_handler import EntityQrelHandler
from ifind.seeker.trec_qrel_handler import TrecQrelHandler
from ifind.search.engines.whooshtrec import Whooshtrec
from ifind.search import Query, Response
from utils import calculate_precision, get_entity_performance
from diversify import diversify_results

fn = 'queries.csv'
qrels_fn = 'trec2005.qrels'
eval_diversity_qrels_fn = '/Users/david/Workspace/phd/supplementary/ch8-diversity/simulations/simulated_queries/rels.diversity.qrels'
ranking_diversity_qrels_fn = 'combined.diversity.qrels'
index = '/Users/david/Workspace/indexes/aquaint_whoosh/'

qrels = TrecQrelHandler(qrels_fn)
eval_diversity_qrels = EntityQrelHandler(eval_diversity_qrels_fn)
ranking_diversity_qrels = EntityQrelHandler(ranking_diversity_qrels_fn)
bm25 = Whooshtrec(whoosh_index_dir=index, stopwords_file='stopwords.txt', model=1, newschema=True)

f = open(fn, 'r')

print 'is_diversified,no_terms,topic,p1,p5,p10,p20,aDCG5,aDCG10,ar5,ar10'

for line in f:
    line = line.strip().split(',')
    
    if line[0] == 'no_terms':
        continue
    
    no_terms = line[0]
    is_diversified = line[1]
    topic = line[2]
    terms = line[3]
    
    q = Query(terms)
    q.skip = 1
    q.top = 1000
    
    response = bm25.search(q)
    
    if is_diversified == '1':
        # Overwrite response with the updated results object that has been diversified.
        response = diversify_results(ranking_diversity_qrels, response, topic, to_rank=30, lam=0.7)
    
    p1 = calculate_precision(qrels, response.results, topic, 1)
    p5 = calculate_precision(qrels, response.results, topic, 5)
    p10 = calculate_precision(qrels, response.results, topic, 10)
    p20 = calculate_precision(qrels, response.results, topic, 20)
    e_perf = get_entity_performance(qrels, eval_diversity_qrels, response.results, topic)
    
    print '{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}'.format(is_diversified, no_terms, topic, p1, p5, p10, p20, e_perf[4], e_perf[5], e_perf[1] / 5.0, e_perf[2] / 10.0)