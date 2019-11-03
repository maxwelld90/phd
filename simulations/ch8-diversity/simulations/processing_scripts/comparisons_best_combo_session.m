function [] = comparisons_best_combo_session(mse_session_path, ss)
%COMPARISONS_BEST_COMBO What is the lowest MSE for the combination stopping
%strategies? Use this script to find out.
%   
%   mse_path = comparisons_session_mse.csv
%   ss = 5 or 11
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    interfaces = [1 2 3 4 5];
    se = 0;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    userids = unique(d.userid);
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        for (j=1:size(interfaces,2))
            interface = interfaces(j);
            filteredLoop = filtered(filtered.ss==ss,:);
            
            if interface < 5
                filteredSnipLoop = filteredLoop(filteredLoop.interface==interface,:);
            else
                filteredSnipLoop = filteredLoop;
            end
            
            thresholdVals = unique(filteredSnipLoop.u_r);
            
            lowestMSEClick = 0;
            lowestDQClick = 0;
            lowestThreshClick = 0;
            lowestCG = 0;
            lowestSaved = 0;
            lowestRVal = 0;
            lowestOtherVal = 0;
            
            for (k=1:size(thresholdVals, 1))
                threshold = thresholdVals(k);
                
                if (ss == 5)
                    otherThresholdVals = unique(filteredSnipLoop.u_n);
                elseif (ss == 11)
                    otherThresholdVals = unique(filteredSnipLoop.u_t);
                end
                
                for (l=1:size(otherThresholdVals, 1))
                    otherThreshold = otherThresholdVals(l);
                    threshFiltered = filteredSnipLoop(filteredSnipLoop.u_r == threshold,:);
                    
                    if (ss == 5)
                        threshFiltered = threshFiltered(threshFiltered.u_n == otherThreshold,:);
                    elseif (ss == 11)
                        threshFiltered = threshFiltered(threshFiltered.u_t == otherThreshold,:);
                    end
                    
                    if (interface < 5)
                        g = grpstats(threshFiltered, {'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
                    else
                        g = grpstats(threshFiltered, {'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
                    end
                    
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
            
            fprintf('I%d\n', interface);
            fprintf('\tr=%d\n', lowestRVal);
            fprintf('\tother=%d\n', lowestOtherVal);
            fprintf('\tMSE=%3.2f\n', lowestMSEClick);
            fprintf('\tDQ=%3.2f\n', lowestDQ);
            
        end
    end
end

