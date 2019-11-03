function [ ] = get_session_time(summaries_csv, snip_len)
%GET_SESSION_TIME For the conclusion of the thesis, pulls out session
%times.
    d = dataset('file', summaries_csv, 'delimiter', ',');
    f = d(d.snippet_len==snip_len,:);
    
    summed = f.query_time + f.serp_time + f.doc_time + f.mark_time_limited;
    fprintf('%3.2f$\\pm$%3.2f\n', mean(summed), std(summed));

end

