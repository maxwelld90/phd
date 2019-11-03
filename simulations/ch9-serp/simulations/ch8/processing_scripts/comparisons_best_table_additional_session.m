function [] = comparisons_best_table_additional_session(mse_comp_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_comp_path, 'delimiter', ',');
    
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
        
        if (ss == 1)
            if (se == 0)
                filteredThreshLoop = filteredLoop(filteredLoop.u_d==21,:);
            elseif (se == 2)
                filteredThreshLoop = filteredLoop(filteredLoop.u_d==24,:);
            elseif (se == 1)
                filteredThreshLoop = filteredLoop(filteredLoop.u_d==24,:);
            end
        elseif (ss == 2)
            if (se == 0)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==18,:);
            elseif (se == 2)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==24,:);
            elseif (se == 1)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==21,:);
            end
        elseif (ss == 5)
            if (se == 0)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==21,:);
                filteredThreshLoop = filteredThreshLoop(filteredThreshLoop.u_r==5,:);
            elseif (se == 2)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==24,:);
                filteredThreshLoop = filteredThreshLoop(filteredThreshLoop.u_r==8,:);
            elseif (se == 1)
                filteredThreshLoop = filteredLoop(filteredLoop.u_n==21,:);
                filteredThreshLoop = filteredThreshLoop(filteredThreshLoop.u_r==5,:);
            end
        end
        
        fprintf('\tDQ: %3.2f\n', mean(filteredThreshLoop.mean_click_depth_per_query));
        fprintf('\tCG: %3.2f\n', mean(filteredThreshLoop.mean_cg));
        fprintf('\tSaved: %3.2f\n', mean(filteredThreshLoop.mean_marked_trec_rel));
        fprintf('\tNew: %3.2f\n', mean(filteredThreshLoop.mean_docs_with_new_entities));
    end
end

