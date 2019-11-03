function [] = performance_stat_tests(summary_path, ss, best_se, other_se)
%PERFORMANCE_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the highest performance, and uses the
%CG values for the stat tests.
    d = dataset('file', summary_path, 'delimiter', ',');
    
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    snip_len = 2;
    
    filtered = d(d.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestFiltered = filtered;
    bestFiltered = filterBySE(bestFiltered, ss, best_se);
    bestCG = bestFiltered.cg;
    
    otherFiltered = filtered;
    otherFiltered = filterBySE(otherFiltered, ss, other_se);
    otherCG = otherFiltered.cg;

    [h,p,ci,stats] = ttest2(bestCG, otherCG);
    fprintf('T%d: comparing SE%d against SE%d over CG\n', snip_len, best_se, other_se);
    fprintf('p value: %3.4f\n', p);
    
	if p < 0.05
        fprintf('SIGNIFICANT DIFFERENCE EXISTS\n');
        
        fprintf('\tSD = %3.2f\n', stats.sd);
        fprintf('\tt(%d) = %3.2f, p = %3.4f\n', stats.df, stats.tstat, p);
        
    else
        fprintf('No Significant Difference.\n');
    end
end

function [filteredDS] = filterBySE(inputDS, ss, se)
        filteredDS = inputDS(inputDS.se == se,:);
        
        if (ss == 1)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            end
        elseif (ss == 2)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_n==7,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            end
        elseif (ss == 5)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_r==7,:);
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_r==9,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            end
        end
end

