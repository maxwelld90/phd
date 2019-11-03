import sys
import utils
import itertools

interfaces = {

              'i4': {'id': 4,

                     'frag_type': 1,
                     'surround': 40,
                     'snip_size': 2,

                     'interface': 'WhooshSearchInterface',

                     'pcr': 0.31,
                     'pcn': 0.17,
                     'pmr': 0.67,
                     'pmn': 0.65,

                     'q': 8.69,
                     'serp': 5.79,
                     'snip': 1.71,
                     'doc': 15.09,
                     'mark': 1.68,

                     'viewport': 7,
                 },

               }

serp_impressions = {'fixed':      {'runs': 1,
                                   'id': 0,
                                   'className': 'SimpleSERPImpression',
                                   'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{aux_dir}/trec2005.qrels', 'is_argument': 'true'}, 
                                                  {'name': 'host', 'type': 'string', 'value': 'localhost', 'is_argument': 'true', 'ignore': True},
                                                  {'name': 'port', 'type': 'integer', 'value': '6379', 'is_argument': 'true', 'ignore': True},],
                                              },
                   }

decision_makers = {'stochastic': {'id': 1, 'runs': 10}, 'perfect': {'id': 2, 'runs': 1}}

snippet_decision_makers = {
                          'stochastic':       {'className': 'StochasticInformedTrecTextClassifier',
                                               'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{aux_dir}/prerolled/i{{interfaceID}}-{{dmRun}}-click.qrels', 'is_argument': 'true'}, 
                                                              {'name': 'rprob', 'type': 'float', 'value': '{{pcr}}', 'is_argument': 'true'}, 
                                                              {'name': 'nprob', 'type': 'float', 'value': '{{pcn}}', 'is_argument': 'true'},
                                                              {'name': 'base_seed', 'type': 'integer', 'value': '{{dmRun}}', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'host', 'type': 'string', 'value': 'localhost', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'port', 'type': 'integer', 'value': '6379', 'is_argument': 'true', 'ignore': True},],
                          },
                          'perfect':          {'className': 'PerfectTrecTextClassifier',
                                               'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{aux_dir}/trec2005.qrels', 'is_argument': 'true'},
                                                              {'name': 'host', 'type': 'string', 'value': 'localhost', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'port', 'type': 'integer', 'value': '6379', 'is_argument': 'true', 'ignore': True},],
                          },
                  }

document_decision_makers = {
                          'stochastic':       {'className': 'StochasticInformedTrecTextClassifier',
                                               'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{aux_dir}/prerolled/i{{interfaceID}}-{{dmRun}}-mark.qrels', 'is_argument': 'true'}, 
                                                              {'name': 'rprob', 'type': 'float', 'value': '{{pmr}}', 'is_argument': 'true'}, 
                                                              {'name': 'nprob', 'type': 'float', 'value': '{{pmn}}', 'is_argument': 'true'},
                                                              {'name': 'base_seed', 'type': 'integer', 'value': '{{dmRun}}', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'host', 'type': 'string', 'value': 'localhost', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'port', 'type': 'integer', 'value': '6379', 'is_argument': 'true', 'ignore': True},],
                          },
                          'perfect':          {'className': 'PerfectTrecTextClassifier',
                                               'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{aux_dir}/trec2005.qrels', 'is_argument': 'true'},
                                                              {'name': 'host', 'type': 'string', 'value': 'localhost', 'is_argument': 'true', 'ignore': True},
                                                              {'name': 'port', 'type': 'integer', 'value': '6379', 'is_argument': 'true', 'ignore': True},],
                          },
                  }

querying_strategies = {
                       'QSREAL': {'id': 0,
                                'className': 'PredeterminedQueryGenerator',
                                 'attributes': [{'name': 'stopword_file', 'type': 'string', 'value': '{aux_dir}/terms/stopwords.txt', 'is_argument': 'true'},
                                                {'name': 'query_file', 'type': 'string', 'value': '{aux_dir}/queries-i{{interfaceID}}.csv', 'is_argument': 'true'},
                                                {'name': 'user', 'type': 'string', 'value': '{{userID}}', 'is_argument': 'true'},]
                               },
                        
                      }

stopping_strategies = {
                        'SS1':   {'runs': 1,
                                 'id': 1,
                                 'className': 'FixedDepthDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'depth', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '15', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '18', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '21', 'is_argument': 'true'},
                                                {'name': 'depth', 'type': 'integer', 'value': '24', 'is_argument': 'true'},]
                                               },

                        'SS2':   {'runs': 1,
                                 'id': 2,
                                 'className': 'TotalNonrelDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '15', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '18', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '21', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '24', 'is_argument': 'true'},]
                                               },

                        'SS3':   {'runs': 1,
                                 'id': 3,
                                 'className': 'SequentialNonrelDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '15', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '18', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '21', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '24', 'is_argument': 'true'},]
                                               },

                        'SS4':   {'runs': 1,
                                 'id': 4,
                                 'className': 'TimeLimitedSatisfactionDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'relevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '300', 'is_argument': 'true'},]
                                               },

                        'SS5':   {'runs': 1,
                                 'id': 5,
                                 'className': 'SatisfactionFrustrationCombinationDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'timeout_threshold', 'type': 'integer', 'value': '300', 'is_argument': 'true'},
                                                
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},

                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '15', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '18', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '21', 'is_argument': 'true'},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '24', 'is_argument': 'true'},]
                                               },

                        'SS6':   {'runs': 1,
                                 'id': 6,
                                 'className': 'DifferenceDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'stopword_file', 'type': 'string', 'value': '{{aux_dir}}/terms/stopwords.txt', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'decision_maker', 'type': 'string', 'value': 'term_overlap', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'query_based', 'type': 'boolean', 'value': 'true', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'nonrel_only', 'type': 'boolean', 'value': 'false', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.05', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.1', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.15', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.2', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.25', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.3', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.35', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.4', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.45', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.55', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.6', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.65', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.7', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.75', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.8', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.85', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.9', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '0.95', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '1.0', 'is_argument': 'true'},]
                                               },

                        'SS7':   {'runs': 1,
                                 'id': 7,
                                 'className': 'DifferenceDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'stopword_file', 'type': 'string', 'value': '{{aux_dir}}/terms/stopwords.txt', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'decision_maker', 'type': 'string', 'value': 'kl', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'query_based', 'type': 'boolean', 'value': 'true', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'nonrel_only', 'type': 'boolean', 'value': 'false', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'threshold', 'type': 'float', 'value': '3.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '3.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '4.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '4.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '5.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '5.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '6.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '6.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '7.0', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '7.5', 'is_argument': 'true'},
                                                {'name': 'threshold', 'type': 'float', 'value': '8.0', 'is_argument': 'true'},]
                                               },

                        'SS8':   {'runs': 1,
                                 'id': 8,
                                 'className': 'IftBasedDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'rank_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'query_time', 'type': 'float', 'value': '{{queryCost}}', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'doc_time', 'type': 'float', 'value': '{{documentCost}}', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'discount', 'type': 'float', 'value': '0.5', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.002', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.004', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.006', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.008', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.010', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.012', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.014', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.016', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.018', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.020', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.022', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.024', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.026', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.028', 'is_argument': 'true'},
                                                {'name': 'gain_threshold', 'type': 'float', 'value': '0.030', 'is_argument': 'true'},]
                                               },

                        'SS9':   {'runs': 1,
                                 'id': 9,
                                 'className': 'TimeDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'timeout_threshold', 'type': 'integer', 'value': '30', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '60', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '90', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '120', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '150', 'is_argument': 'true'},]
                                               },

                        'SS10':  {'runs': 1,
                                 'id': 10,
                                 'className': 'TimeSinceRelevancyDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'on_mark', 'type': 'boolean', 'value': 'true', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '20', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '30', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '40', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '50', 'is_argument': 'true'},]
                                               },

                        'SS11':  {'runs': 1,
                                 'id': 11,
                                 'className': 'PatchCombinationSimplifiedDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'qrel_file', 'type': 'string', 'value': '{{aux_dir}}/trec2005.qrels', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'nonrelevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'serp_size', 'type': 'integer', 'value': '{{viewportSize}}', 'is_argument': 'true', 'ignore': True},
                                                {'name': 'on_mark', 'type': 'boolean', 'value': 'true', 'is_argument': 'true', 'ignore': True},
                                                
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '20', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '30', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '40', 'is_argument': 'true'},
                                                {'name': 'timeout_threshold', 'type': 'integer', 'value': '50', 'is_argument': 'true'},
                                                 
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '1', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '2', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '3', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '4', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '5', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '6', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '7', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '8', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '9', 'is_argument': 'true'},
                                                {'name': 'relevant_threshold', 'type': 'integer', 'value': '10', 'is_argument': 'true'},]
                                               },

                        'SS12':  {'runs': 10,
                                 'id': 12,
                                 'className': 'RBPDecisionMaker',
                                 'relevanceRevision': False,
                                 'querying': {'QSREAL': querying_strategies['QSREAL']},
                                 'decision_makers': {'stochastic': decision_makers['stochastic'], 'perfect': decision_makers['perfect']},
                                 'attributes': [{'name': 'patience', 'type': 'float', 'value': '0.8', 'is_argument': 'true'},
                                                {'name': 'patience', 'type': 'float', 'value': '0.85', 'is_argument': 'true'},
                                                {'name': 'patience', 'type': 'float', 'value': '0.9', 'is_argument': 'true'},
                                                {'name': 'patience', 'type': 'float', 'value': '0.9087', 'is_argument': 'true'},
                                                {'name': 'patience', 'type': 'float', 'value': '0.95', 'is_argument': 'true'},
                                                {'name': 'patience', 'type': 'float', 'value': '0.99', 'is_argument': 'true'},

                                                {'name': 'base_seed', 'type': 'integer', 'value': '{{ssRun}}', 'is_argument': 'true', 'ignore': True},]
                                               },
                                               
                       }

topics = {'341': {'filename':      '{aux_dir}/topics/topic.341',
                  'qrelsFilename': '{aux_dir}/trec2005.qrels'},

          '347': {'filename':      '{aux_dir}/topics/topic.347',
                  'qrelsFilename': '{aux_dir}/trec2005.qrels'},

          '408': {'filename':      '{aux_dir}/topics/topic.408',
                  'qrelsFilename': '{aux_dir}trec2005.qrels'},

          '435': {'filename':      '{aux_dir}/topics/topic.435',
                  'qrelsFilename': '{aux_dir}/trec2005.qrels'},
         }

logger = {'className': 'FixedCostLoggerNoTime',
          'attributes': [{'name': 'query_cost', 'type': 'float', 'value': '{{queryCost}}', 'is_argument': 'true'},
                         {'name': 'document_cost', 'type': 'float', 'value': '{{documentCost}}', 'is_argument': 'true'},
                         {'name': 'snippet_cost', 'type': 'float', 'value': '{{snippetCost}}', 'is_argument': 'true'},
                         {'name': 'serp_results_cost', 'type': 'float', 'value': '{{serpResultsCost}}', 'is_argument': 'true'},
                         {'name': 'mark_document_cost', 'type': 'float', 'value': '{{markDocumentCost}}', 'is_argument': 'true'},],
         }


##########################


def make_user_string(serp_impression, serp_impression_run, time_limit, querying_strategy, ss, ss_run, logger, dm, dm_run, snippet_dm, document_dm):
    f = open('base_files/user.xml', 'r')
    user_base = f.read()
    f.close()
    
    # Snippet Classifier
    snippet_attributes = ''
    
    for attribute in snippet_dm['attributes']:
        snippet_attributes = "{previous}{new}".format(previous=snippet_attributes,new=utils.make_attribute_string(attribute))
    
    #for attribute in snippet_decision_makers[]
    
    # Document Classifier
    document_attributes = ''
    
    for attribute in document_dm['attributes']:
        document_attributes = "{previous}{new}".format(previous=document_attributes,new=utils.make_attribute_string(attribute))
    
    # Logger
    logger_attributes = ''
    
    for attribute in logger['attributes']:
        logger_attributes = "{previous}{new}".format(previous=logger_attributes,new=utils.make_attribute_string(attribute))
    
    # Stopping Strategy
    stopping_strategy_attributes = ''
    
    for attribute in ss['attributes']:
        stopping_strategy_attributes = "{previous}{new}".format(previous=stopping_strategy_attributes,new=utils.make_attribute_string(attribute))
    
    stopping_strategy_attributes = stopping_strategy_attributes.format(ssRun=ss_run)
    stopping_strategy_attributes = stopping_strategy_attributes.replace('{', '{{')
    stopping_strategy_attributes = stopping_strategy_attributes.replace('}', '}}')
    
    # Querying Strategy
    querying_strategy_attributes = ''
    
    for attribute in querying_strategy['attributes']:
        querying_strategy_attributes = "{previous}{new}".format(previous=querying_strategy_attributes,new=utils.make_attribute_string(attribute))
    
    
    # SERP Impression
    serp_impression_attributes = ''
    
    for attribute in serp_impression['attributes']:
        serp_impression_attributes = "{previous}{new}".format(previous=serp_impression_attributes,new=utils.make_attribute_string(attribute))
    
    # SS Threshold ID
    ss_params = ''
    
    for attribute in ss['attributes']:
        if 'ignore' in attribute and attribute['ignore']:
            continue
        
        value = str(attribute['value'])
        value = value.replace('-', '9')
        value = value.replace('+', '8')
        #value = value.replace('.', '')
        
        if type(value) == bool:
            if value:
                value = '1'
            else:
                value = '0'
        
        ss_params = "{ss_params}{attribute}{value}".format(ss_params=ss_params, attribute=attribute['name'][:1], value=value)
    
    
    # ID String
    # id_string = 'serpex{serpex}-ser{serpex_run:02d}-t{time_limit}-ss{ss_id}-ssr{ss_run:02d}-dm{dm_id}-dmr{dm_run:02d}-qs{qs}-u-{ssvals}'.format(serpex=serp_impression['id'],
    #                                                       serpex_run=serp_impression_run,
    #                                                       time_limit=time_limit,
    #                                                       dm_id=decision_makers[dm]['id'],
    #                                                       dm_run=dm_run,
    #                                                       ss_id=ss['id'],
    #                                                       ss_run=ss_run,
    #                                                       qs=querying_strategy['id'],
    #                                                       ssvals = ss_params)
    id_string = '{ssvals}'.format(ssvals = ss_params)
    
    # Final munge-up
    user_base = user_base.format(userID=id_string,
                                 queryGeneratorClass=querying_strategy['className'],
                                 queryGeneratorAttributes=querying_strategy_attributes,
                                 snippetClassifierClass=snippet_dm['className'],
                                 snippetClassifierAttributes=snippet_attributes,
                                 documentClassifierClass=document_dm['className'],
                                 documentClassifierAttributes=document_attributes,
                                 stoppingDecisionMakerClass=ss['className'],
                                 stoppingDecisionMakerAttributes=stopping_strategy_attributes,
                                 loggerClass=logger['className'],
                                 loggerAttributes=logger_attributes,
                                 serpImpressionClass=serp_impression['className'],
                                 serpImpressionAttributes=serp_impression_attributes)
    
    return (id_string, ss_params, user_base)


def main(output_dir, experiment_base_dir, aux_dir, index_dir, queries_file):
    total = 0
    
    # Build up the user ID list.
    queries_file = open(queries_file, 'r')
    userids = []
    
    for line in queries_file:
        line = line.strip().split(',')
        userid = int(line[1])
        
        if userid not in userids:
            userids.append(userid)
    
    # Build up/replace this dictionary with keys/values that can replace {{values}}.
    # For example, a KVP here of <viewport_size,5> would replace {{viewport_size}} with 5.
    replace_dict = {}
    
    # Modify the following loops to tweak the output required.
    # The outermost loop corresponds to the outermost directory.
    for userid in userids:
        replace_dict['userID'] = userid
        
        for interface in interfaces:
            replace_dict['interfaceID'] = interfaces[interface]['id']
            replace_dict['viewportSize'] = interfaces[interface]['viewport']
            #replace_dict['patchThresh'] = interfaces[interface]['patch_thresh']
            #replace_dict['viewportPrecisionThreshold'] = interfaces[interface]['viewport_precision_theshold']

            replace_dict['pcr'] = interfaces[interface]['pcr']
            replace_dict['pcn'] = interfaces[interface]['pcn']
            replace_dict['pmr'] = interfaces[interface]['pmr']
            replace_dict['pmn'] = interfaces[interface]['pmn']

            #replace_dict['goodAbandon'] = interfaces[interface]['good_abandon']
            #replace_dict['badAbandon'] = interfaces[interface]['bad_abandon']

            replace_dict['queryCost'] = interfaces[interface]['q']
            replace_dict['documentCost'] = interfaces[interface]['doc']
            replace_dict['snippetCost'] = interfaces[interface]['snip']
            replace_dict['serpResultsCost'] = interfaces[interface]['serp']
            replace_dict['markDocumentCost'] = interfaces[interface]['mark']

            for serp_impression in serp_impressions:
                serp_impression_runs = serp_impressions[serp_impression]['runs']

                for i in range(0, serp_impression_runs):
                    replace_dict['serpRun'] = "{serp_run:02d}".format(serp_run=i+1)

                    for timeout in [0]:
                        replace_dict['timeLimit'] = '0'

                        for ss in stopping_strategies:
                            ss_runs = stopping_strategies[ss]['runs']

                            # Don't like this, but it will do.
                            if stopping_strategies[ss]['relevanceRevision']:
                                replace_dict['relevanceRevision'] = '1'
                            else:
                                replace_dict['relevanceRevision'] = '0'

                            # Stopping Strategy runs
                            for k in range(0, ss_runs):
                                replace_dict['ssRun'] = "{ss_run:02d}".format(ss_run=k+1)

                                # Decision Makers (limited to decision makers for stopping strategies)
                                for dm in stopping_strategies[ss]['decision_makers']:
                                    dm_runs = decision_makers[dm]['runs']

                                    for j in range(0, dm_runs):
                                        replace_dict['dmRun'] = "{dm_run:02d}".format(dm_run=j+1)

                                        # Querying Strategy
                                        for querying_strategy in stopping_strategies[ss]['querying']:
                                            base_path = "/u{userid}/i{interface}/se{serp_impression}/ser{serp_impression_run:02d}/ti{timeout}/ss{ss}/ssr{ssr}/dm{dm}/dmr{dmr:02d}/qs{qs}/".format(
                                                userid=userid,
                                                interface=interfaces[interface]['id'],
                                                serp_impression=serp_impressions[serp_impression]['id'],
                                                serp_impression_run=i,
                                                timeout=timeout,
                                                dm=decision_makers[dm]['id'],
                                                dmr=j,
                                                ss=stopping_strategies[ss]['id'],
                                                ssr=k,
                                                qs=querying_strategies[querying_strategy]['id']
                                            )

                                            experiment_id = "exp-u{userid}_i{interface}_se{serp_impression}_ser{serp_impression_run:02d}_ti{timeout}_ss{ss}_ssr{ssr}_dm{dm}_dmr{dmr:02d}_qs{qs}".format(
                                                userid=userid,
                                                interface=interfaces[interface]['id'],
                                                serp_impression=serp_impressions[serp_impression]['id'],
                                                serp_impression_run=i,
                                                timeout=timeout,
                                                dm=decision_makers[dm]['id'],
                                                dmr=j,
                                                ss=stopping_strategies[ss]['id'],
                                                ssr=k,
                                                qs=querying_strategies[querying_strategy]['id']
                                            )

                                            experiment_path = "{exp_root}{base_path}".format(exp_root=experiment_base_dir, base_path=base_path)
                                            create_path = "{output_dir}{base_path}".format(output_dir=output_dir, base_path=base_path)
                                            out_path = "{output_dir}{base_path}/out/".format(output_dir=output_dir, base_path=base_path)

                                            utils.mkdir_p(create_path)
                                            utils.mkdir_p(create_path)
                                            utils.mkdir_p(out_path)

                                            user_files = []

                                            attribute_categories = {}
                                            attribute_categories_nested = []

                                            for attribute in stopping_strategies[ss]['attributes']:
                                                if attribute['name'] not in attribute_categories.keys():
                                                    attribute_categories[attribute['name']] = []

                                                attribute_categories[attribute['name']].append(attribute)

                                            for attribute_category in attribute_categories.keys():
                                                attribute_categories_nested.append(attribute_categories[attribute_category])

                                            combinations = list(itertools.product(*attribute_categories_nested))
                                            
                                            for comb in combinations:
                                                individual_stopping_strat = stopping_strategies[ss].copy()
                                                new_attributes = []
                                            
                                                for item in comb:
                                                    new_attributes.append(item)
                                                
                                                individual_stopping_strat['attributes'] = new_attributes
                                            
                                                user_val = make_user_string(serp_impressions[serp_impression],
                                                                            i,
                                                                            timeout,
                                                                            querying_strategies[querying_strategy],
                                                                            individual_stopping_strat,
                                                                            k,
                                                                            logger,
                                                                            dm,
                                                                            j,
                                                                            snippet_decision_makers[dm],
                                                                            document_decision_makers[dm],
                                                                            )

                                                user_id = utils.replace_string_values(user_val[0], replace_dict)
                                                ss_id = utils.replace_string_values(user_val[1], replace_dict)
                                                user_str = utils.replace_string_values(user_val[2], replace_dict)

                                                ss_id = ss_id.replace('-', '9')
                                                ss_id = ss_id.replace('+', '8')
                                                #ss_id = ss_id.replace('.', '')
                                            
                                                # Create the user and ss id
                                                ss_id = 'u{userid}{ss_id}'.format(userid=userid,ss_id=ss_id)

                                                user_file_create_path = "{create_path}{ss_id}.xml".format(create_path=create_path, ss_id=ss_id)
                                                user_file_experiment_path = "{experiment_path}{ss_id}.xml".format(experiment_path=experiment_path, ss_id=ss_id)
                                                user_files.append(user_file_experiment_path)

                                                user_str = user_str.replace('{{aux_dir}}', aux_dir)
                                                user_str = user_str.replace('{aux_dir}', aux_dir)

                                                f = open(user_file_create_path, 'w')
                                                f.write(user_str)
                                                f.close()

                                                total = total + 1
                                            
                                            diversity_qrels = ''
                                            lam = ''
                                            to_rank = ''
                                            
                                            if 'diversity_qrels' in interfaces[interface]:
                                                diversity_qrels = interfaces[interface]['diversity_qrels']
                                            
                                            if 'lam' in interfaces[interface]:
                                                lam = interfaces[interface]['lam']
                                            
                                            if 'to_rank' in interfaces[interface]:
                                                to_rank = interfaces[interface]['to_rank']
                                            
                                            sim_file = create_simulation_file(experiment_id,
                                                                   experiment_path,
                                                                   index_dir,
                                                                   frag_type=interfaces[interface]['frag_type'],
                                                                   frag_size=interfaces[interface]['snip_size'],
                                                                   frag_surround=interfaces[interface]['surround'],
                                                                   interface=interfaces[interface]['interface'],
                                                                   diversity_qrels=diversity_qrels,
                                                                   lam=lam,
                                                                   to_rank=to_rank,
                                                                   users=user_files,
                                                                   aux_dir=aux_dir,
                                                                   queries_file=queries_file,
                                                                   userid=userid)

                                            simulation_filepath = "{create_path}simulation.xml".format(create_path=create_path)

                                            f = open(simulation_filepath, 'w')
                                            f.write(sim_file)
                                            f.close()

                                            f = open(out_path + "/CREATED", 'w')
                                            f.close()

                                        total = total + 1
                    
                                    # COMMENT THIS FOR REAL
                                    # For debugging -- comment out for real
                                    if total <= 1:
                                        sys.exit(0)
    print total
    queries_file.close()


def create_simulation_file(experiment_id, experiment_path, index_dir, frag_type, frag_size, frag_surround, interface, diversity_qrels, lam, to_rank, users, aux_dir, queries_file, userid):
    f = open('base_files/simulation.xml', 'r')
    base = f.read()
    f.close()
    
    f = open('base_files/user_entry.xml', 'r')
    user_base = f.read()
    f.close()
    
    user_str = ''
    
    for user in users:
        user_str = '{user_str}{new}'.format(user_str=user_str, new=user_base.format(configPath=user))
    
    queries_file.seek(0)
    
    topic_query_count = {}
    userid = str(userid)
    
    for line in queries_file:
        line = line.strip().split(',')
        line_topic = line[2]
        line_userid = line[1]
        
        if line_userid == userid:
            if line_topic not in topic_query_count:
                topic_query_count[line_topic] = 0
        
            topic_query_count[line_topic] = topic_query_count[line_topic] + 1
    
    selected_topics = {}
    
    for picked_topic in topic_query_count:
        selected_topics[picked_topic] = topics[picked_topic]
    
    if interface == 'WhooshDiversifiedInterface':
        diversified_str = '<attribute name="qrels_diversity_file" type="string" value="{diversityQRELS}" is_argument="true" /><attribute name="lam" type="float" value="{lam}" is_argument="true" /><attribute name="to_rank" type="integer" value="{toRank}" is_argument="true" />'.format(diversityQRELS=diversity_qrels, lam=lam, toRank=to_rank)
    else:
        diversified_str = ''
    
    base = base.format(experimentID=experiment_id,
                       experimentBaseDir=experiment_path,
                       searchInterface=interface,
                       diversifiedStr = diversified_str,
                       indexDir=index_dir,
                       fragType=frag_type,
                       fragSize=frag_size,
                       fragSurround=frag_surround,
                       topics=utils.get_topics_str(selected_topics, use_background=False),
                       users=user_str)
    
    base = base.format(aux_dir=aux_dir)
    return base

def usage(script_name):
    print "Usage: {script_name} <output_dir> <experiments_base_dir> <aux_dir> <index_dir> <queries_file (for reading only)>".format(script_name=script_name)

if __name__ == '__main__':
    if len(sys.argv) != 6:
        usage(sys.argv[0])
        sys.exit(1)
    
    output_dir = sys.argv[1]
    experiment_base_dir = sys.argv[2]
    aux_dir = sys.argv[3]
    index_dir = sys.argv[4]
    queries_file = sys.argv[5]
    
    sys.exit(main(output_dir, experiment_base_dir, aux_dir, index_dir, queries_file))