function [] = comparisons_stat_tests_session(comp_session_mse_path, ss, se_best, se_other)
%COMPARISONS_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the bets approximations, and uses the
%MSE values for the stat tests.
    d = dataset('file', comp_session_mse_path, 'delimiter', ',');
    
    decision_maker = 1;
    interface = 4;
    
    filtered = d(d.ss==ss,:);
    filtered = filtered(filtered.interface==interface,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestFiltered = filtered;
    bestFiltered = filterBySS(bestFiltered, ss, se_best);
    bestMSE = bestFiltered.mse_click_depth;
    
    mean(bestMSE)
    
    otherFiltered = filtered;
    otherFiltered = filterBySS(otherFiltered, ss, se_other);
    otherMSE = otherFiltered.mse_click_depth;
    
    [h,p,ci,stats] = ttest2(bestMSE, otherMSE);
    fprintf('T%d: comparing SE%d against SE%d over CG\n', interface, se_best, se_other);
    fprintf('p value: %3.4f\n', p);
    
	if p < 0.05
        fprintf('SIGNIFICANT DIFFERENCE EXISTS\n');
        
        fprintf('\tSD = %3.2f\n', stats.sd);
        fprintf('\tt(%d) = %3.2f, p = %3.4f\n', stats.df, stats.tstat, p);
        
    else
        fprintf('No Significant Difference.\n');
    end
end

function [filteredDS] = filterBySS(inputDS, ss, se)
        filteredDS = inputDS(inputDS.se == se,:);
        
        if (ss == 1)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_d==21,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            end
        elseif (ss == 2)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            end
        elseif (ss == 5)
            if (se == 0)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (se == 1)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (se == 2)
                filteredDS = filteredDS(filteredDS.u_r==8,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            end
        end
end

