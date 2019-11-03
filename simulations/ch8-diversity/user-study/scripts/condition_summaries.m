d = dataset('file', '../data/summaries.csv', 'delimiter', ',');
g = grpstats(d, {'diversity'});

export(g, 'File', '../data/interface-summaries.csv', 'Delimiter', ',');
d = dataset('file', '../data/interface-summaries.csv', 'delimiter', ',');

d.Observations = [];
d.GroupCount = [];
d.mean_user = [];
d.mean_order = [];
d.mean_topic = [];

export(d, 'File', '../data/interface-summaries.csv', 'Delimiter', ',');