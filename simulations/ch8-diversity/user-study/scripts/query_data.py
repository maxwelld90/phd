import os
import sys
from datetime import datetime, timedelta
from ifind.seeker.trec_qrel_handler import TrecQrelHandler
from ifind.seeker.trec_diversity_qrel_handler import EntityQrelHandler
from ifind.search.engines.whooshtrec import Whooshtrec
from ifind.search import Query, Response

from exp_time_log_reader import ExpTimeLogReader
from diversify import diversify_results
from utils import get_query_performance_metrics, get_time_diff, is_relevant, get_entity_performance, get_new_entities

PAGE_SIZE = 10

# For the diversifying algorithm
LAM = 0.7  # Diversifying lambda value
KDIV = 30  # DIversifying cutoff value

# key:
# username condition interface diversity taskid topic actions no_pages doc_count doc_depth doc_rel_count doc_rel_depth hover_count hover_trec_rel_count hover_trec_nonrel_count hover_depth doc_trec_rel_count doc_trec_nonrel_count doc_clicked_trec_rel_count doc_clicked_trec_nonrel_count abandoned_serps_count query_time document_time new_total_serp mark_time mark_time_limited serp_examination_time serp_examination_time_limited session_time pat1 pat2 pat3 pat4 pat5 pat10 pat15 pat20 pat25 pat30 pat40 pat50 rprec total_trec_rel_docs doc_trec_unjudged_count new_at_1 new_at_5 new_at_10 new_at_20 aDCG_5 aDCG_10 doc_marked_entity_count doc_marked_entity_count_new observed_entity_count doc_marked_entity_depth doc_marked_entity_depth_new task_view_clicks

class QueryLogEntry(object):
    
    def __init__(self, key, vals, qrel_handler, ranking_diversity_qrel_handler, evaluation_diversity_qrel_handler, engine=None, query_time=0):
        self.key = key
        self.qrel_handler = qrel_handler
        self.ranking_diversity_qrel_handler = ranking_diversity_qrel_handler
        self.evaluation_diversity_qrel_handler = evaluation_diversity_qrel_handler
        
        # Get the query terms -- we need these to run the query again and get performance.
        self.query = vals[10:]
        
        if self.query == '':
            # There's quote marks at the start and end of the query, remove them
            self.query[0] = self.query[0][1:]
            self.query[-1] = self.query[-1][:-1]
        
        self.topic = vals[8]
        self.event_count = 0
        self.doc_count = 0
        self.doc_depth = 0
        self.hover_count = 0  # Added by David
        self.hover_depth = 0  # Added by David
        self.hover_trec_rel_count = 0
        self.hover_trec_nonrel_count = 0
        self.doc_rel_count = 0
        self.doc_marked_list = []
        self.doc_unmarked_list = []
        self.doc_rel_depth = 0
        self.doc_trec_rel_count = 0  # Records documents MARKED that are trec rel
        self.doc_trec_nonrel_count = 0  # Records documents MARKED that are not trec rel
        self.doc_trec_unjudged_count = 0 # Records documents MARKED that are UNJUDGED in the trec qrels
        self.pages = 0
        self.curr_page = 1
        self.session_start_time = '{date} {time}'.format(date=vals[0],time=vals[1])
        self.session_end_time = None
        self.query_time = query_time
        self.session_time = 0.0
        self.snippet_time = 0.0
        self.document_time = 0.0
        self.view_serp_time = 0
        self.last_serp_view_time = None  # Added by David
        self.curr_event = None
        self.last_event = None
        self.last_interaction_event = None
        self.last_interaction_time = None
        self.last_last_event = None
        self.doc_click_time = False
        self.task_view_clicks = 0
        
        # Entity values, added by David (2018-01-13)
        self.observed_entities = []  # A list of entities found in documents marked relevant for the query.
        self.doc_marked_entity_count = 0  # The number of documents that were marked relevant containing one or more entities.
        self.doc_marked_entity_count_new = 0  # The number of documents that were marked relevant, containing one or more new entities -- that is, an entity that was unseen in the previous rankings for the query.
        self.entities_found = 0  # The number of entities that were found in documents marked relevant.
        self.doc_marked_entity_depth = 0  # What depth was the last document marked when an entitiy was in it?
        self.doc_marked_entity_depth_new = 0 # Same as above, but for a document containing at least one UNSEEN entity in the query.
        
        # Probability variables, added by David (2016-11-30)
        self.doc_clicked_trec_rel_count = 0
        self.doc_clicked_trec_nonrel_count = 0
        
        self.query_response = None  # Stores the results for parsing later on.
        
        # Testing by David for new SERP
        self.last_serp_event = None
        self.new_total_serp = 0.0
        
        # Additional attributes to store details on system lag and imposed delays
        self.serp_lag_calculated_for = []  # Added by David, list of times for the queries we've worked out lag for!
        self.serp_lag = 0.0  # Added by David
        
        # Added by David (2017-05-06) for CIKM 2017
        self.mark_time = 0.0
        self.mark_time_limited = 0.0
        self.serp_examination_time = 0.0
        self.serp_examination_time_limited = 0.0
        self.abandoned_serps_count = 0
        
        self.last_query_delay_time = None
        self.imposed_query_delay = 0.0
        self.system_query_delay = 0.0
        self.total_query_duration = 0.0
        self.last_document_delay_time = None
        self.imposed_document_delay = 0.0
        self.document_lag = 0.0
        
        # issue query to whoosh and get performance values
        self.p = []
        self.perf = ['0.0  ' * 14]
        
        if engine:
            q = Query(' '.join(self.query))
            q.skip = 1
            q.top = 1000
            (un,cond,interface,diversity,taskid,topicnum) = key.split(' ')
            #print "Issuing {0}".format(q.terms)
            
            diversity = int(diversity)
            response = engine.search(q)  # Search using BM25.
            
            # Added by David -- an additional extra step to diversify content if the query was issued by the
            # diversifying system (either 1 or 3)
            if diversity in [1,3]:
                response = diversify_results(self.ranking_diversity_qrel_handler, response, topicnum, to_rank=KDIV, lam=LAM)
            
            self.perf = get_query_performance_metrics(self.qrel_handler, response.results, topicnum)
            self.diversity_perf = get_entity_performance(self.qrel_handler, self.evaluation_diversity_qrel_handler, response.results, topicnum)
            self.query_response = response
            
        self.last_event='QUERY_ISSUED'
        self.last_time = '{date} {time}'.format(date=vals[0],time=vals[1])
    
    def __str__(self):
        q = ' '.join(self.query)
        
        performances = ' '.join(self.perf)
        serp_time = self.view_serp_time + self.snippet_time
        
        counts = "{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10} {11} {12} {13}".format(
            self.pages,
            self.doc_count,
            self.doc_depth,
            self.doc_rel_count,
            self.doc_rel_depth,
            self.hover_count,
            self.hover_trec_rel_count,
            self.hover_trec_nonrel_count,
            self.hover_depth,
            self.doc_trec_rel_count,
            self.doc_trec_nonrel_count,
            self.doc_clicked_trec_rel_count,
            self.doc_clicked_trec_nonrel_count,
            self.abandoned_serps_count
        )
        
        """
        times = "{0} {1} {2} {3} {4} {5} {6} {7} {8}".format(
            self.query_time, self.session_time, self.document_time, serp_time,
            self.serp_lag, self.imposed_query_delay, self.engine_query_delay, self.imposed_document_delay, "0.0"
        )
        """
        # times = "{0} {1} {2} {3} {4} {5}".format(
        #     self.query_time,
        #     self.system_query_delay,
        #     self.session_time,
        #     self.document_time,
        #     self.serp_lag,
        #     self.new_total_serp
        # )
        times = "{0} {1} {2} {3} {4} {5} {6} {7}".format(
            self.query_time,
            self.document_time,
            self.new_total_serp,
            self.mark_time,
            self.mark_time_limited,
            self.serp_examination_time,
            self.serp_examination_time_limited,
            self.session_time,
            # self.system_query_delay,
            # self.session_time,
            # self.document_time,
            # self.serp_lag,
            # self.new_total_serp
        )
        
        
        diversity_perf_str = " ".join(map(str, self.diversity_perf))
        
        entities_str = "{0} {1} {2} {3} {4}".format(self.doc_marked_entity_count, self.doc_marked_entity_count_new, len(self.observed_entities), self.doc_marked_entity_depth, self.doc_marked_entity_depth_new)
        task_view_str = str(self.task_view_clicks)
        
        s = "{0} {1} {2} {3} {4} {5} {6}".format(counts, times, performances, self.doc_trec_unjudged_count, diversity_perf_str, entities_str, task_view_str)
        return s

    def update_times(self, curr_time):

        #print curr_time, self.last_time, get_time_diff(self.last_time, curr_time)

        if self.curr_event == 'DELAY_RESULTS_PAGE':
            self.serp_lag = get_time_diff(self.session_start_time, curr_time)
            self.last_query_delay_time = curr_time

        if self.curr_event == 'QUERY_COMPLETE':  # Was VIEW_SEARCH_RESULTS_PAGE
            if self.last_event == 'DELAY_RESULTS_PAGE':
                self.imposed_query_delay = get_time_diff(self.last_query_delay_time, curr_time)
            #if self.last_event == 'QUERY_END':  # Was QUERY_ISSUED
            #    self.serp_lag = get_time_diff(self.session_start_time, curr_time)
        
        if self.system_query_delay == 0.0 and self.curr_event == 'QUERY_END' and self.last_event == 'QUERY_START':
            self.system_query_delay = self.system_query_delay + get_time_diff(self.last_time, curr_time)

        if self.curr_event == 'DOCUMENT_DELAY_VIEW':
            # Document delay occurred, so track the time this happened at.
            self.last_document_delay_time = curr_time
            self.view_serp_time = self.view_serp_time + get_time_diff(self.last_time, curr_time)

        if self.curr_event == 'DOC_MARKED_VIEWED':
            if self.last_document_delay_time:
                if get_time_diff(self.last_document_delay_time, curr_time) < 10.0:
                    self.imposed_document_delay += get_time_diff(self.last_document_delay_time, curr_time)
                else:
                    self.view_serp_time += get_time_diff(self.last_time, curr_time)
            else:
                self.view_serp_time += get_time_diff(self.last_time, curr_time)
        
        if self.last_event == 'DOC_MARKED_RELEVANT':
            difference = get_time_diff(self.last_time, curr_time)
            self.mark_time = self.mark_time + difference
            
            # Add in a limited time difference, too, to avoid the erroneous times.
            # If the difference is greater than five seconds, ignore the difference.
            if difference > 5.0:
                difference = 0.0
            
            self.mark_time_limited = self.mark_time_limited + difference
        
        if self.last_event == 'VIEW_SEARCH_RESULTS_PAGE':
            difference = get_time_diff(self.last_time, curr_time)
            self.serp_examination_time = self.serp_examination_time + difference
            
            if difference > 5.0:
                difference = 0.0
            
            self.serp_examination_time_limited = self.serp_examination_time_limited + difference
            
            if 'QUERY' in self.curr_event:
                self.abandoned_serps_count = self.abandoned_serps_count + 1
        
        if self.curr_event in ['DOCUMENT_HOVER_OUT', 'DOCUMENT_HOVER_IN', 'QUERY_FOCUS','VIEW_SAVED_DOCS','VIEW_TASK' ]:
            self.view_serp_time = self.view_serp_time + get_time_diff(self.last_time, curr_time)
	
	# This could be more robust.
	# What if the searcher were to view the list of documents marked, or view the task, whilst viewing a document?
	# Maybe this functionality should be disabled while a document is being viewed.
	# Commented out by DMAX on June 8th 2016 - replaced with more robust document time measures (see below).        
	#if self.last_event in ['DOC_MARKED_VIEWED','DOC_MARKED_RELEVANT','DOC_MARKED_NONRELEVANT']:
        #    self.document_time = self.document_time + get_time_diff(self.last_time, curr_time)
	
	# DMAX - Added new document time measures (June 8th 2016)
	# self.doc_click_time contains the document click time. Set to False otherwise.
	if not self.doc_click_time and self.curr_event == 'DOC_CLICKED':
	    self.doc_click_time = curr_time
	
	# Added in VIEW_SAVED_DOCS to cater for the event where a searcher flips to the saved document screen instead.
	if self.doc_click_time and self.curr_event in ['QUERY_START', 'VIEW_SAVED_DOCS', 'PRACTICE_SEARCH_TASK_COMPLETED','TASK_ENDED','SESSION_COMPLETED','EXPERIMENT_TIMEOUT','SNIPPET_POSTTASK_SURVEY_STARTED','SEARCH_TASK_COMPLETED']:
	    self.document_time = self.document_time + get_time_diff(self.doc_click_time, curr_time)
	    self.doc_click_time = False
	# DMAX - End new document time measures
	
	# DMAX - Adding in new SERP details
	if not self.last_serp_event and self.curr_event == 'VIEW_SEARCH_RESULTS_PAGE':
	    self.last_serp_event = curr_time
	#elif self.last_serp_event and self.curr_event == 'QUERY_FOCUS':
	#    print 'QF', curr_time
	elif self.last_serp_event and self.curr_event not in ['DOCUMENT_HOVER_IN', 'DOCUMENT_HOVER_OUT']:
	    self.new_total_serp = self.new_total_serp + get_time_diff(self.last_serp_event, curr_time)
	    self.last_serp_event = None
	# DMAX - End new SERP details
	
	# DMAX - Updated SERP lag time
	if self.curr_event == 'QUERY_END' and self.last_event == 'QUERY_START':
	    self.serp_lag = self.serp_lag + get_time_diff(self.last_time, curr_time)
	# DMAX - End updated SERP lag time
	

    def end_query_session(self,end_time):
        # DMAX added in this condition to take the first event only.
        # Subsequent events add overhead to the time - that isn't strictly part of the session.
        if self.session_end_time is None:
                
                # Added by David on December 13, 2016
                # Last events (e.g. EXPERIMENT_TIMEOUT) should not be considered as the final session event.
                # Some people in the experiment walk away (or something) for several minutes, meaning that times are way out.
                # In this case, we roll back to the last interaction event - where the event is not EXPERIMENT_TIMEOUT or SESSION_COMPLETED.
                end_time = self.last_interaction_time
                self.session_end_time = end_time
                
                # print "END EVENT: {0}".format(self.last_interaction_event)
                # print "END TIME: {0}".format(self.last_interaction_time)
                
                self.session_time = get_time_diff(self.session_start_time, end_time)
            #print "session time", self.session_time
        
                self.update_times(end_time)
            #if self.last_event == 'VIEW_SEARCH_RESULTS_PAGE':
            #    self.snippet_time = self.snippet_time + get_time_diff(self.view_serp_time, end_time)
        
        # Adding some code to work out probabilities for clicking!
        relevant_count = 0
        
        for i in range(0, self.hover_depth):
            if self.hover_depth > len(self.query_response.results):
                continue
        
            if self.qrel_handler.get_value(self.topic, self.query_response.results[i].docid) > 0:
                relevant_count = relevant_count + 1
            
        for i in range(0, self.hover_depth):
            docid_at_rank = self.query_response.results[i].docid
            qrel_judgement = is_relevant(self.qrel_handler, self.topic, docid_at_rank)
            
            if qrel_judgement >= 1:
                self.hover_trec_rel_count = self.hover_trec_rel_count + 1
            else:
                self.hover_trec_nonrel_count = self.hover_trec_nonrel_count + 1
            
            # if is_relevant(self.qrel_handler, self.topic, docid_at_rank) <= 0:
            #     self.hover_trec_nonrel_count = self.hover_trec_nonrel_count + 1
            # else:
            #     self.hover_trec_rel_count = self.hover_trec_rel_count + 1
     
    def process(self, vals):
        self.event_count = self.event_count + 1
        self.curr_event = vals[9]
        self.update_times('{date} {time}'.format(date=vals[0],time=vals[1]))
        
        if 'VIEW_SEARCH_RESULTS_PAGE' in vals:
            n = 1
            if len(vals) == 11:
                n = int(vals[10])
            
            if self.pages < n:
                self.pages = n
            self.curr_page = n
        
        # When the "View Task" link is pushed.
        if 'VIEW_TASK' in vals:
            self.task_view_clicks += 1

        if 'DOC_MARKED_VIEWED' in vals:
            m = int(vals[14])
            #n = (self.curr_page - 1)* PAGE_SIZE + m
            if self.doc_depth < m:
                self.doc_depth = m

            self.doc_count = self.doc_count + 1
            qrel_judgement = is_relevant(self.qrel_handler, vals[8], vals[11])
            
            if qrel_judgement >= 1:
                self.doc_clicked_trec_rel_count = self.doc_clicked_trec_rel_count + 1
            else:
                self.doc_clicked_trec_nonrel_count = self.doc_clicked_trec_nonrel_count + 1
            
            # if is_relevant(self.qrel_handler, vals[7], vals[10]) <= 0:
            #     self.doc_clicked_trec_nonrel_count = self.doc_clicked_trec_nonrel_count + 1
            # else:
            #     self.doc_clicked_trec_rel_count = self.doc_clicked_trec_rel_count + 1
        
        if 'DOCUMENT_HOVER_IN' in vals:
            m = int(vals[-1])
            #print vals
            #print m
            
            #n = (self.curr_page - 1)* PAGE_SIZE + m
            self.hover_count += 1
            
            if m > self.hover_depth:
                self.hover_depth = m
             
        if 'DOC_MARKED_RELEVANT' in vals:
            r = int(vals[13])
            
            if r > 0:
                self.doc_rel_count = self.doc_rel_count + 1
                self.doc_marked_list.append(vals[11])
                qrel_judgement = is_relevant(self.qrel_handler, vals[8], vals[11])
                m = int(vals[14]) # The ranking depth
                
                # Entity calculations
                if qrel_judgement >= 1:
                    document_entities = self.evaluation_diversity_qrel_handler.get_mentioned_entities_for_doc(self.topic, vals[11])
                    new_entities = get_new_entities(self.evaluation_diversity_qrel_handler, self.observed_entities, document_entities)
                    
                    if len(document_entities) > 0:
                        self.doc_marked_entity_count = self.doc_marked_entity_count + 1
                        
                        if self.doc_marked_entity_depth < m:
                            self.doc_marked_entity_depth = m
                    
                    if len(document_entities) > 0 and len(new_entities) > 0:
                        self.doc_marked_entity_count_new = self.doc_marked_entity_count_new + 1
                        
                        if self.doc_marked_entity_depth_new < m:
                            self.doc_marked_entity_depth_new = m
                    
                    if len(new_entities) > 0:
                        self.observed_entities = self.observed_entities + new_entities
                # End entity calculations
                
                if qrel_judgement >= 1:
                    self.doc_trec_rel_count = self.doc_trec_rel_count + 1
                else:
                    self.doc_trec_nonrel_count = self.doc_trec_nonrel_count + 1
                    
                    if qrel_judgement == -1:
                        self.doc_trec_unjudged_count = self.doc_trec_unjudged_count + 1
                
                if self.doc_rel_depth < m:
                    self.doc_rel_depth = m
        
        if 'DOC_MARKED_NONRELEVANT' in vals:
            self.doc_unmarked_list.append(vals[11])
                    
        self.last_last_event = self.last_event
        self.last_event = vals[9]
        self.last_time = '{date} {time}'.format(date=vals[0], time=vals[1])
        
        if (vals[8] not in ['DIVERSITY_POSTTASK_SURVEY_STARTED', 'TASK_COMPLETED', 'PRACTICE_SEARCH_TASK_COMPLETED']):
            self.last_interaction_event = vals[9]
            self.last_interaction_time = '{date} {time}'.format(date=vals[0], time=vals[1])

class ExpLogEntry(object):

    def __init__(self, key, qrel_handler, ranking_diversity_qrel_handler, evaluation_diversity_qrel_handler, engine=None):
        self.qrel_handler = qrel_handler
        self.ranking_diversity_qrel_handler = ranking_diversity_qrel_handler
        self.evaluation_diversity_qrel_handler = evaluation_diversity_qrel_handler
        self.key = key
        self.title = ''
        self.state = ''
        self.event_count = 0
        self.queries = []
        self.current_query = None
        self.last_event_time = None
        self.last_query_focus_time = None
        self.engine = engine
        self.query_ended_previously = False

    def __str__(self):
        
        s = ""
        for q in self.queries:
            sq = "%s %d %s\n" % (self.key, self.event_count, str(q))
            if len(sq) > 5:
                s = s + sq
        return s.strip()

    def getTitle(self):
        return self.title

    def getState(self):
        return self.state

    def setState(self, state):
        self.state = state
        

    def process(self, vals):
        self.event_count = self.event_count + 1

        #self.last_event_time
        # We want to measure query time from the last QUERY_FOCUS event.
        # We could do it from the first, but we decided this could be too unreliable...
        # So every time we see a new QUERY_FOCUS, we override what we have before and update the time accordingly.
        
        # Commented out this line so that this is overwritten
        #if self.last_query_focus_time is None:

        if ('QUERY_FOCUS' in vals):
            self.last_query_focus_time = '{date} {time}'.format(date=vals[0],time=vals[1])

        if self.last_query_focus_time is None:
            if ('VIEW_SEARCH_BOX' in vals):
                self.last_query_focus_time = '{date} {time}'.format(date=vals[0],time=vals[1])
        
        # End de-dentation

        
        if ('QUERY_ISSUED' in vals):
            # new query, create a query log entry
            if self.current_query:
                if self.last_query_focus_time:
                    lqft = self.last_query_focus_time
                else:
                    lqft = self.last_event_time  # We didn't see a FOCUS or VIEW_SEARCH_BOX, so fallback to last event time.

                self.current_query.end_query_session(lqft)

            #print "QUERY ISSUED:", vals[8:]
            #print self.last_query_focus_time, ':::', vals[1], ':::', get_time_diff(self.last_query_focus_time, vals[1])
            #print
            if self.last_query_focus_time is None:
                self.last_query_focus_time = self.last_event_time
            
            self.current_query = QueryLogEntry(self.key, vals, self.qrel_handler, self.ranking_diversity_qrel_handler, self.evaluation_diversity_qrel_handler, self.engine, get_time_diff(self.last_query_focus_time, '{date} {time}'.format(date=vals[0],time=vals[1])))
            self.last_query_focus_time = None
            self.query_ended_previously = False
            self.queries.append(self.current_query)
        else:
            if self.current_query:
                # process result under this query object
                self.current_query.process(vals)
        
        # probably should put a condition on this (start task, doc viewed, view serp, etc, ) not all/any
        self.last_event_time = '{date} {time}'.format(date=vals[0],time=vals[1])

        event = vals[9]
        if event in ['PRACTICE_SEARCH_TASK_COMPLETED','TASK_COMPLETED','DIVERSITY_POSTTASK_SURVEY_STARTED']:
            #print 'search task complete - event'
            if self.current_query and not self.query_ended_previously:
                #print "end of search session"
                self.current_query.end_query_session('{date} {time}'.format(date=vals[0],time=vals[1]))
                self.query_ended_previously = True
        
        # Code for removing documents that were previously marked, but are then reselected as non-relevant.
        all_docs_unmarked = []
        
        for query_object in self.queries:
            all_docs_unmarked = all_docs_unmarked + query_object.doc_unmarked_list
            query_object.doc_unmarked_list = []
        
        topic = self.key.split(' ')[5]
        
        for query_object in self.queries:
            for docid in all_docs_unmarked:
                if docid in query_object.doc_marked_list:
                    query_object.doc_marked_list.remove(docid)
            
            query_object.doc_rel_count = len(query_object.doc_marked_list)
            query_object.doc_trec_unjudged_count = 0
            query_object.doc_trec_nonrel_count = 0
            query_object.doc_trec_rel_count = 0
            
            for docid in query_object.doc_marked_list:
                qrel_judgement = is_relevant(self.qrel_handler, topic, docid)
                
                if qrel_judgement >= 1:
                    query_object.doc_trec_rel_count = query_object.doc_trec_rel_count + 1
                else:
                    query_object.doc_trec_nonrel_count = query_object.doc_trec_nonrel_count + 1
                    
                    if qrel_judgement == -1:
                        query_object.doc_trec_unjudged_count = query_object.doc_trec_unjudged_count + 1
                
                # if is_relevant(self.qrel_handler, topic, docid) <= 0:
                #     query_object.doc_trec_nonrel_count = query_object.doc_trec_nonrel_count + 1
                # else:
                #     query_object.doc_trec_rel_count = query_object.doc_trec_rel_count + 1
            
        
        # for query_object in self.queries:
        #     for docid in all_docs_unmarked:
        #         if docid in query_object.doc_marked_list:
        #             topic = self.key.split(' ')[4]
        #
        #             query_object.doc_marked_list.remove(docid)
        #             query_object.doc_rel_count = query_object.doc_rel_count - 1
        #
        #             if is_relevant(self.qrel_handler, topic, docid) == 0:
        #                 query_object.doc_clicked_trec_nonrel_count = query_object.doc_clicked_trec_nonrel_count - 1
        #             else:
        #                 query_object.doc_clicked_trec_rel_count = query_object.doc_clicked_trec_rel_count - 1
            
def main():
    if len(sys.argv) == 7:
        filename = sys.argv[1]
        qrels = TrecQrelHandler(sys.argv[2])
        ranking_diversity_qrels = EntityQrelHandler(sys.argv[3])
        evaluation_diversity_qrels = EntityQrelHandler(sys.argv[4])
        my_whoosh_doc_index_dir = sys.argv[5]
        stopword_file = sys.argv[6]
        
        bm25 = Whooshtrec(whoosh_index_dir=my_whoosh_doc_index_dir, stopwords_file=stopword_file, model=1, newschema=True)
        elr = ExpTimeLogReader(ExpLogEntry, qrels, ranking_diversity_qrels, evaluation_diversity_qrels, bm25)
        elr.process(filename)
        elr.report(False)
    else:
        print "{0} <logfile> <qrelsfile> <ranking_diversity_qrels> <evaluation_diversity_qrels> <indexpath> <stopwordsfile>".format(sys.argv[0])

if __name__ == "__main__":
    sys.exit(main())
