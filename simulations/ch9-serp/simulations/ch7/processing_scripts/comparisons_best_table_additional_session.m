function [] = comparisons_best_table_additional_session(mse_comp_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_comp_path, 'delimiter', ',');
    
    snip_len = 2;
    ses = [0 2 1];
    decision_maker = 1;
    
    filtered = d(d.ss==ss,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filteredLoop = filtered(filtered.snip_len==snip_len,:);
    
    for (i=1:size(ses,2))
        se = ses(i);
        filteredSE = filteredLoop(filteredLoop.se==se,:);
        
        if (ss == 1)
            if (se == 0)
                filteredSE = filteredSE(filteredSE.u_d==21,:);
            elseif (se == 1)
                filteredSE = filteredSE(filteredSE.u_d==24,:);
            elseif (se == 2)
                filteredSE = filteredSE(filteredSE.u_d==24,:);
            end
        elseif (ss == 2)
            if (se == 0)
                filteredSE = filteredSE(filteredSE.u_n==15,:);
            elseif (se == 1)
                filteredSE = filteredSE(filteredSE.u_n==18,:);
            elseif (se == 2)
                filteredSE = filteredSE(filteredSE.u_n==21,:);
            end
        elseif (ss == 5)
            if (se == 0)
                filteredSE = filteredSE(filteredSE.u_r==6,:);
                filteredSE = filteredSE(filteredSE.u_n==21,:);
            elseif (se == 1)
                filteredSE = filteredSE(filteredSE.u_r==7,:);
                filteredSE = filteredSE(filteredSE.u_n==21,:);
            elseif (se == 2)
                filteredSE = filteredSE(filteredSE.u_r==10,:);
                filteredSE = filteredSE(filteredSE.u_n==21,:);
            end
        end
        
        fprintf('SE%d\n', se);
        fprintf('\tDQ: %3.2f\n', mean(filteredSE.mean_mean_click_depth));
        fprintf('\tCG: %3.2f\n', mean(filteredSE.sum_mean_cg));
        fprintf('\tSaved: %3.2f\n', mean(filteredSE.sum_mean_saved_trec_rel));
    end
end

