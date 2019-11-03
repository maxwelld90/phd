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
    
    ses = [0 2 1];
    time_limit = 500;
    qs = 13;
    decision_maker = 1;
    interface = 4;
    
    filtered = d(d.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.interface==interface,:);
    
    for (i=1:size(ses,2))
        se = ses(i);
        filteredLoop = filtered(filtered.se==se,:);
        filteredGrp = grpstats(filteredLoop, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
        
        maxCG = max(filteredGrp.mean_cg);
        maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
        dq = maxRow.mean_depth_per_query;
        thresh = 0;
        
        if (ss == 1)
            thresh = maxRow.u_d;
        elseif (ss == 2)
            thresh = maxRow.u_n;
        end
        
        if (ss == 11)
            nVals = unique(filteredLoop.u_n);
            nHighest = 0;
            nHighestCG = 0;
            nHighestDQ = 0;
            nHighestT = 0;

            for (k=1:size(nVals,1))
                nVal = nVals(k);
                multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
                filteredGrp = grpstats(multipleFiltered, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
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
            
            fprintf('SE %d\n', se);
            fprintf('\tThreshold (time): %d\n', nHighestT);
            fprintf('\tThreshold (satisfaction): %d\n', nHighest);
            fprintf('\tD/Q: %3.2f\n', nHighestDQ);
            fprintf('\tCG: %3.2f\n', nHighestCG);
        elseif (ss == 5)
            nVals = unique(filteredLoop.u_n);
            nHighest = 0;
            nHighestCG = 0;
            nHighestDQ = 0;
            nHighestT = 0;

            for (k=1:size(nVals,1))
                nVal = nVals(k);
                multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
                filteredGrp = grpstats(multipleFiltered, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
                maxCG = max(filteredGrp.mean_cg);
            
                if (maxCG > nHighestCG)
                    nHighestCG = maxCG;
                    maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
                    nHighestDQ = maxRow.mean_depth_per_query;
                    nHighestT = maxRow.u_n;
                    nHighest = maxRow.u_r;
                end
            end
            
            if isscalar(nHighestT) == 0
                nHighestT = nHighestT(1);
                nHighest = nHighest(1);
                dq = dq(1);
            end
            
            fprintf('SE %d\n', se);
            fprintf('\tThreshold (non-rel): %d\n', nHighestT);
            fprintf('\tThreshold (satisfaction): %d\n', nHighest);
            fprintf('\tD/Q: %3.2f\n', nHighestDQ);
            fprintf('\tCG: %3.2f\n', nHighestCG);
        else
            if isscalar(thresh) == 0
                thresh = thresh(1);
                dq = dq(1);
            end
            
            fprintf('SE %d\n', se);
            fprintf('\tThreshold: %3.2f\n', thresh);
            fprintf('\tD/Q: %3.2f\n', dq);
            fprintf('\tCG: %3.2f\n', maxCG);
        end
        
    end
end

