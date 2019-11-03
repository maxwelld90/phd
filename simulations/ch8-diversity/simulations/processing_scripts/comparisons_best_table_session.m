function [] = comparisons_best_table_session(mse_session_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE session table.
%   Blah blah
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    interfaces = [1 2 3 4 5];
    se = 0;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        fprintf('SS%d\n\t', ss);
        fprintf('\\RS & \\lbluecell\\small\\textbf{SS%d} & ', ss);
        
        for (j=1:size(interfaces,2))
            interface = interfaces(j);
            filteredLoop = filtered(filtered.ss==ss,:);
            
            if interface < 5
                filteredSnipLoop = filteredLoop(filteredLoop.interface==interface,:);
            else
                filteredSnipLoop = filteredLoop;
            end
            
            if (ss == 1)
                 thresholds = unique(filteredSnipLoop.u_d);
            elseif (ss == 2 || ss == 3)
                thresholds = unique(filteredSnipLoop.u_n);
            elseif (ss == 4)
                thresholds = unique(filteredSnipLoop.u_r);
            elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                thresholds = unique(filteredSnipLoop.u_t);
            elseif (ss == 8)
                thresholds = unique(filteredSnipLoop.u_g);
            elseif (ss == 12)
                thresholds = unique(filteredSnipLoop.u_p);
            end
            
            lowestMSEClick = 0;
            lowestDQClick = 0;
            lowestThreshClick = 0;
            lowestCG = 0;
            lowestSaved = 0;
            
            for (k=1:size(thresholds,1))
                threshold = thresholds(k);
                
                if (ss == 1)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_d==threshold,:);
                elseif (ss == 2 || ss == 3)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_n==threshold,:);
                elseif (ss == 4)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_r==threshold,:);
                elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_t==threshold,:);
                elseif (ss == 8)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_g==threshold,:);
                elseif (ss == 12)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_p==threshold,:);
                end
                
                if (interface < 5)
                    g = grpstats(filteredThresh, {'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
                else
                    g = grpstats(filteredThresh, {'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
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
                end
            end
            
            fprintf('\\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\small \\hspace*{-1.5mm} %3.2f ', lowestThreshClick, lowestMSEClick); 
            
            if (interface ~= 4)
                fprintf(' & ');
            elseif (interface == 4)
                fprintf(' \\\\\n');
            end
        end
    end
end

