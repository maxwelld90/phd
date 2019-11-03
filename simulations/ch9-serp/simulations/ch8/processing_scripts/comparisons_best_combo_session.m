function [] = comparisons_best_combo_session(mse_session_path, ss)
%COMPARISONS_BEST_COMBO What is the lowest MSE for the combination stopping
%strategies? Use this script to find out.
%   
%   mse_path = comparisons_session_mse.csv
%   ss = 5 or 11
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    interface = 4;
    ses = [0 2 1];
    decision_maker = 1;
    
    filtered = d(d.ss==ss,:);
    filtered = filtered(filtered.interface==interface,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(ses,2))
        se = ses(i);
        
        fprintf('SE%d\n', se);
        filteredLoop = filtered(filtered.se==se,:);
        thresholdVals = unique(filteredLoop.u_r);
        
        lowestMSEClick = 0;
        lowestDQClick = 0;
        lowestThreshClick = 0;
        lowestCG = 0;
        lowestSaved = 0;
        lowestRVal = 0;
        lowestOtherVal = 0;
        
        for (j=1:size(thresholdVals, 1))
            threshold = thresholdVals(j);
            
            if (ss == 5)
                otherThresholdVals = unique(filteredLoop.u_n);
            elseif (ss == 11)
                otherThresholdVals = unique(filteredLoop.u_t);
            end
            
            for (k=1:size(otherThresholdVals, 1))
                otherThreshold = otherThresholdVals(k);
                threshFiltered = filteredLoop(filteredLoop.u_r == threshold,:);
                
                if (ss == 5)
                    threshFiltered = threshFiltered(threshFiltered.u_n == otherThreshold,:);
                elseif (ss == 11)
                    threshFiltered = threshFiltered(threshFiltered.u_t == otherThreshold,:);
                end
                
                g = grpstats(threshFiltered, {'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t'});
                
                meanMSE = g.mean_mse_click_depth;
                meanDQ = g.mean_mean_click_depth_per_query;
                meanCG = g.mean_mean_cg;
                meanSaved = g.mean_mean_marked_trec_rel;
                
                if (meanMSE < lowestMSEClick || lowestMSEClick == 0)
                    lowestMSEClick = meanMSE;
                    lowestDQ = meanDQ;
                    lowestThreshClick = threshold;
                    lowestCG = meanCG;
                    lowestSaved = meanSaved;
                    lowestRVal = threshold;
                    lowestOtherVal = otherThreshold;
                end
            end
        end
        
        fprintf('\tr=%d\n', lowestRVal);
        fprintf('\tother=%d\n', lowestOtherVal);
        fprintf('\tMSE=%3.2f\n', lowestMSEClick);
        fprintf('\tDQ=%3.2f\n', lowestDQ);
        fprintf('\tCG=%3.2f\n', lowestCG);
    end
end

