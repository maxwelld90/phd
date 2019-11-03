function [] = check_perf(summary_path, snip_len, ss)

    d = dataset('file', summary_path, 'delimiter', ',');
    
    se = 0;
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    
    filteredGrp = grpstats(filtered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
    
    maxCG = max(filteredGrp.mean_cg);
    maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
    dq = maxRow.mean_depth_per_query;
    thresh = 0;
    
    if (ss == 1)
        thresh = maxRow.u_d;
    elseif (ss == 2 || ss == 3)
        thresh = maxRow.u_n;
    elseif (ss == 4)
        thresh = maxRow.u_r;
    elseif (ss == 6 || ss == 7)
        thresh = maxRow.u_t;
    elseif (ss == 8)
        thresh = maxRow.u_g;
    elseif (ss == 9 || ss == 10)
        thresh = maxRow.u_t;
    elseif (ss == 12)
        thresh = maxRow.u_p;
    end
    
    if (ss == 5 || ss == 11)
        nVals = unique(filtered.u_n);
        nHighest = 0;
        nHighestCG = 0;
        nHighestDQ = 0;
        nHighestOther = 0;
        
        for (i=1:size(nVals,1))
            nVal = nVals(i);
            multipleFiltered = filtered(filtered.u_n==nVal,:);
            filteredGrp = grpstats(multipleFiltered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
            
            maxCG = max(filteredGrp.mean_cg);
            
            if (maxCG > nHighestCG)
                nHighestCG = maxCG;
                maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
                nHighestDQ = maxRow.mean_depth_per_query;
                nHighest = maxRow.u_n;
                
                if (ss == 5)
                    nHighestOther = maxRow.u_r;
                else
                    nHighestOther = maxRow.u_t;
                end
            end
        end
        
        nHighestCG
        nHighestDQ
        nHighest
        nHighestOther
        
    else
        
    end

end

