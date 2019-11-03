from ifind.seeker.trec_qrel_handler import TrecQrelHandler
from ifind.search.engines.whooshtrec import Whooshtrec
from ifind.search import Query, Response
from utils import calculate_precision

fn = '/Users/david/Workspace/phd/supplementary/ch7-snippets/simulations/queries/queries.csv'
qrels_fn = 'trec2005.qrels'
index = '/Users/david/Workspace/indexes/aquaint_whoosh/'

qrels = TrecQrelHandler(qrels_fn)
bm25 = Whooshtrec(whoosh_index_dir=index, stopwords_file='stopwords.txt', model=1, newschema=True)

f = open(fn, 'r')

print 'no_terms,topic,p1,p5,p10,p20'

for line in f:
    line = line.strip().split(',')
    
    if line[0] == 'no_terms':
        continue
    
    no_terms = line[0]
    topic = line[1]
    terms = line[2]
    
    q = Query(terms)
    q.skip = 1
    q.top = 1000
    
    response = bm25.search(q)
    
    p1 = calculate_precision(qrels, response.results, topic, 1)
    p5 = calculate_precision(qrels, response.results, topic, 5)
    p10 = calculate_precision(qrels, response.results, topic, 10)
    p20 = calculate_precision(qrels, response.results, topic, 20)
    
    print '{0},{1},{2},{3},{4},{5}'.format(no_terms, topic, p1, p5, p10, p20)
    
    # issue.