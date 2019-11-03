# Uses the TREC QREL reader to work out how many relevant documents there are per topic.

from ifind.seeker.trec_qrel_handler import TrecQrelHandler

handler = TrecQrelHandler('trec2005.qrels')
topics = handler.get_topic_list()

print "topic,total_assessed,total_nonrel,total_somewhat,total_definitely,total_rel"

for topic in topics:
    docs = handler.get_doc_list(topic)
    rel_count = 0
    somewhat_count = 0
    definitely_count = 0
    nonrel_count = 0
    total_count = 0
    
    for doc in docs:
        if docs[doc] == 0:
            nonrel_count += 1
        elif docs[doc] > 0:
            rel_count += 1
            
            if docs[doc] == 1:
                somewhat_count += 1
            else:
                definitely_count += 1
        
        total_count += 1
    
    print "{topic},{total_count},{nonrel_count},{somewhat_count},{definitely_count},{rel_count}".format(
        topic=topic,
        total_count=total_count,
        nonrel_count=nonrel_count,
        somewhat_count=somewhat_count,
        definitely_count=definitely_count,
        rel_count=rel_count,
    )