function [  ] = performance_best_table(summary_path, ss)
%PERFORMANCE_BEST_TABLE Spits out performance values for each strategy.
% For every stopping strategy/interface, returns the CG, D/Q and threshold.
% For SS5 and SS11 with two thresholds, all values are returned.

% This is used for the performance table 7.8 in the thesis.
% Change the ss parameter to get an output line for the corresponding ss.
% 1-12 are acceptable values as these are the only ones in the summary!

% summary_path = ../summaries/performance.csv
% ss = Pick 1 to 12

    d = dataset('file', summary_path, 'delimiter', ',');
    
    interfaces = unique(d.interface);
    se = 0;
    time_limit = 500;
    qs = 13;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        fprintf('SS%d\n\t', ss);
        fprintf('\\RS & \\lbluecell\\small\\textbf{SS%d} & ', ss);
        
        for (j=1:size(interfaces,1))
            interface = interfaces(j);
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredLoop = filteredLoop(filteredLoop.interface==interface,:);
            
            filteredGrp = grpstats(filteredLoop, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
            
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
            
            if (ss == 5)
                nVals = unique(filteredLoop.u_n);
                nHighest = 0;
                nHighestCG = 0;
                nHighestDQ = 0;
                nHighestT = 0;
                nNew = 0;
                
                for (k=1:size(nVals,1))
                    nVal = nVals(k);
                    multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
                    
                    filteredGrp = grpstats(multipleFiltered, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
                    maxCG = max(filteredGrp.mean_cg);
                    
                    if (maxCG > nHighestCG)
                        nHighestCG = maxCG;
                        maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
                        nHighestDQ = maxRow.mean_depth_per_query;
                        nHighestT = maxRow.u_r;
                        nHighest = maxRow.u_n;
                        nNew = maxRow.mean_new_docs_with_entities;
                    end
                end
                
                if ~isscalar(nHighestDQ)
                    nHighestDQ = nHighestDQ(1);
                    nHighestT = nHighestT(1);
                    nHighest = nHighest(1);
                    nNew = nNew(1);
                end
                
                fprintf('\\cell \\small \\hspace*{-1mm} %3.2f,%3.2f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', nHighest, nHighestT, nHighestDQ, nHighestCG); 
                
            elseif (ss == 11)
                nVals = unique(filteredLoop.u_n);
                nHighest = 0;
                nHighestCG = 0;
                nHighestDQ = 0;
                nHighestT = 0;
                
                for (k=1:size(nVals,1))
                    nVal = nVals(k);
                    multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
                    
                    filteredGrp = grpstats(multipleFiltered, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
                    maxCG = max(filteredGrp.mean_cg);
                    
                    if (maxCG > nHighestCG)
                        nHighestCG = maxCG;
                        maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
                        nHighestDQ = maxRow.mean_depth_per_query;
                        nHighestT = maxRow.u_t;
                        nHighest = maxRow.u_r;
                    end
                end
                
                if isscalar(nHighestT) == 0
                    nHighestT = nHighestT(1);
                    nHighest = nHighest(1);
                    dq = dq(1);
                end
                
                fprintf('\\cell \\small \\hspace*{-1mm} %3.2f,%3.2f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', nHighestT, nHighest, nHighestDQ, nHighestCG); 
                
            else
                
                if isscalar(thresh) == 0
                    thresh = thresh(1);
                    dq = dq(1);
                end
                
                fprintf('\\cell \\small \\hspace*{-1mm} %3.3f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', thresh, dq, maxCG); 
            end
            
            if (interface ~= 4)
                fprintf(' & ');
            elseif (interface == 4)
                fprintf(' \\\\\n');
            end
            
            % \RS\lbluecell\small\textbf{SS1} & \cell \small \hspace*{-1mm}xx.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx \\
            
        end
        
        fprintf('\n\n');
    end
end

