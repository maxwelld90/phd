function [] = comparisons_best_table_session(mse_session_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE session table.
%   Blah blah
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    snip_len = 2;
    ses = [0 2 1];
    decision_maker = 1;
    
    filtered = d(d.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(ses,2))
        se = ses(i);
        
        fprintf('SE%d\n', se);
        filteredLoop = filtered(filtered.se==se,:);
        
        if (ss == 1)
             thresholds = unique(filteredLoop.u_d);
        elseif (ss == 2 || ss == 3)
            thresholds = unique(filteredLoop.u_n);
        elseif (ss == 4)
            thresholds = unique(filteredLoop.u_r);
        elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
            thresholds = unique(filteredLoop.u_t);
        elseif (ss == 8)
            thresholds = unique(filteredLoop.u_g);
        elseif (ss == 12)
            thresholds = unique(filteredLoop.u_p);
        end
        
        lowestMSEClick = 0;
        lowestDQClick = 0;
        lowestThreshClick = 0;
        lowestCG = 0;
        lowestSaved = 0;
        
        for (k=1:size(thresholds,1))
            threshold = thresholds(k);
            
            if (ss == 1)
                filteredThresh = filteredLoop(filteredLoop.u_d==threshold,:);
            elseif (ss == 2 || ss == 3)
                filteredThresh = filteredLoop(filteredLoop.u_n==threshold,:);
            elseif (ss == 4)
                filteredThresh = filteredLoop(filteredLoop.u_r==threshold,:);
            elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                filteredThresh = filteredLoop(filteredLoop.u_t==threshold,:);
            elseif (ss == 8)
                filteredThresh = filteredLoop(filteredLoop.u_g==threshold,:);
            elseif (ss == 12)
                filteredThresh = filteredLoop(filteredLoop.u_p==threshold,:);
            end
            
            g = grpstats(filteredThresh, {'snip_len', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t'});
            
            meanMSE = g.mean_mse_click_depth;
            meanDQ = g.mean_mean_mean_click_depth;
            meanCG = g.mean_sum_mean_cg;
            meanSaved = g.mean_sum_mean_saved_trec_rel;
            
            if (meanMSE < lowestMSEClick || lowestMSEClick == 0)
                lowestMSEClick = meanMSE;
                lowestDQ = meanDQ;
                lowestThreshClick = threshold;
                lowestCG = meanCG;
                lowestSaved = meanSaved;
            end
            
        end
        
        fprintf('\tThresh: %3.2f\n', lowestThreshClick);
        fprintf('\tMSE: %3.2f\n', lowestMSEClick);
        
    end
end

