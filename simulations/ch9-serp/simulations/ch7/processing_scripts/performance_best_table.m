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
    
    snip_lens = unique(d.snip_len);
    ses = [0 2 1];
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    snip_len = 2;
    
    filtered = d(d.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    
    for (i=1:size(ses,2))
        se = ses(i);
        filteredLoop = filtered(filtered.se==se,:);
        filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
        
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
                filteredGrp = grpstats(multipleFiltered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
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
                filteredGrp = grpstats(multipleFiltered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
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
            fprintf('\tThreshold (non-relevant): %d\n', nHighestT);
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
    
%     for (i=1:size(sss,1))
%         ss = sss(i);
%         
%         fprintf('SS%d\n\t', ss);
%         fprintf('\\RS & \\lbluecell\\small\\textbf{SS%d} & ', ss);
%         
%         for (j=1:size(snip_lens,1))
%             snip_len = snip_lens(j);
%             
%             filteredLoop = filtered(filtered.ss==ss,:);
%             filteredLoop = filteredLoop(filteredLoop.snip_len==snip_len,:);
%             
%             filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
%             
%             maxCG = max(filteredGrp.mean_cg);
%             maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
%             dq = maxRow.mean_depth_per_query;
%             thresh = 0;
%             
%             if (ss == 1)
%                 thresh = maxRow.u_d;
%             elseif (ss == 2 || ss == 3)
%                 thresh = maxRow.u_n;
%             elseif (ss == 4)
%                 thresh = maxRow.u_r;
%             elseif (ss == 6 || ss == 7)
%                 thresh = maxRow.u_t;
%             elseif (ss == 8)
%                 thresh = maxRow.u_g;
%             elseif (ss == 9 || ss == 10)
%                 thresh = maxRow.u_t;
%             elseif (ss == 12)
%                 thresh = maxRow.u_p;
%             end
%             
%             if (ss == 5)
%                 nVals = unique(filteredLoop.u_n);
%                 nHighest = 0;
%                 nHighestCG = 0;
%                 nHighestDQ = 0;
%                 nHighestT = 0;
%                 
%                 for (k=1:size(nVals,1))
%                     nVal = nVals(k);
%                     multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
%                     
%                     filteredGrp = grpstats(multipleFiltered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
%                     maxCG = max(filteredGrp.mean_cg);
%                     
%                     if (maxCG > nHighestCG)
%                         nHighestCG = maxCG;
%                         maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
%                         nHighestDQ = maxRow.mean_depth_per_query;
%                         nHighestT = maxRow.u_r;
%                         nHighest = maxRow.u_n;
%                     end
%                 end
%                 
%                 fprintf('\\cell \\small \\hspace*{-1mm} %3.2f,%3.2f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', nHighest, nHighestT, nHighestDQ, nHighestCG); 
%                 
%             elseif (ss == 11)
%                 nVals = unique(filteredLoop.u_n);
%                 nHighest = 0;
%                 nHighestCG = 0;
%                 nHighestDQ = 0;
%                 nHighestT = 0;
%                 
%                 for (k=1:size(nVals,1))
%                     nVal = nVals(k);
%                     multipleFiltered = filteredLoop(filteredLoop.u_n==nVal,:);
%                     
%                     filteredGrp = grpstats(multipleFiltered, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
%                     maxCG = max(filteredGrp.mean_cg);
%                     
%                     if (maxCG > nHighestCG)
%                         nHighestCG = maxCG;
%                         maxRow = filteredGrp(filteredGrp.mean_cg==maxCG,:);
%                         nHighestDQ = maxRow.mean_depth_per_query;
%                         nHighestT = maxRow.u_t;
%                         nHighest = maxRow.u_r;
%                     end
%                 end
%                 
%                 if isscalar(nHighestT) == 0
%                     nHighestT = nHighestT(1);
%                     nHighest = nHighest(1);
%                     dq = dq(1);
%                 end
%                 
%                 fprintf('\\cell \\small \\hspace*{-1mm} %3.2f,%3.2f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', nHighestT, nHighest, nHighestDQ, nHighestCG); 
%                 
%             else
%                 
%                 if isscalar(thresh) == 0
%                     thresh = thresh(1);
%                     dq = dq(1);
%                 end
%                 
%                 fprintf('\\cell \\small \\hspace*{-1mm} %3.3f & \\cell \\small \\hspace*{-1mm} %3.2f & \\cell \\hspace*{-1mm} \\small %3.2f', thresh, dq, maxCG); 
%             end
%             
%             if (snip_len ~= 4)
%                 fprintf(' & ');
%             elseif (snip_len == 4)
%                 fprintf(' \\\\\n');
%             end
%             
%             % \RS\lbluecell\small\textbf{SS1} & \cell \small \hspace*{-1mm}xx.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx & \cell \small x.xx \\
%             
%         end
%         
%         fprintf('\n\n');
%     end
end

