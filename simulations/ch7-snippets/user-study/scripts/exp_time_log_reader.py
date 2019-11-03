import os

class ExpTimeLogReader(object):

    def __init__(self, log_entry_reader, qrel_handler=None, engine=None):
        self.log_entry_reader = log_entry_reader
        self.qrel_handler = qrel_handler
        self.engine = engine
        self.entries = {}

    def process(self, filename):

        if os.path.exists( filename ):
            infile = open( filename, 'r' )

            while infile:
                line = infile.readline()
                vals = line.split()
                if len(vals) == 0:
                    break  #end of file??? clean up???
                else:
                    username = vals[3]
                    condition = vals[4]
                    interface = vals[5]
                    order = vals[6]
                    topic = vals[7]
                    key = "%s %s %s %s %s" % (username,condition,interface,order,topic)
                    
                    entry =  None
                    
                    if vals[8] == 'VIEW_PERFORMANCE':
                        # Don't care about this line (at present)
                        continue
                    
                    if key in self.entries.keys():
                        entry = self.entries[key]
                    else:
                        entry = self.log_entry_reader(key, self.qrel_handler, self.engine)
                        
                    entry.process(vals)
                    self.entries[key] = entry
        else:
            print 'Filename: %s  does not exist.' % (filename)

    def report(self,showtitles=False):
        if showtitles:
           for u in self.entries.keys():
                print self.entries[u].getTitle()
                break
        for u in self.entries.keys():
            e = str(self.entries[u])
            if len(e) > 5:
                #pass
                print e.strip()