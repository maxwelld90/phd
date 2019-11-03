function [] = comparisons_best_table_additional_session(mse_comp_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_comp_path, 'delimiter', ',');
    
    interfaces = unique(d.interface);
    se = 0;
    %sss = unique(d.ss);
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filteredLoop = filtered(filtered.ss==ss,:);
    
    for (i=1:size(interfaces,1))
        interface = interfaces(i);
        filteredSnipLen = filteredLoop(filteredLoop.interface==interface,:);
        
        if (ss == 1)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==24,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==24,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==24,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==21,:);
            end
        elseif (ss == 2)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==18,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==18,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==18,:);
            end
        elseif (ss == 3)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==9,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==9,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==10,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==8,:);
            end
        elseif (ss == 4)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==3,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==4,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==3,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==3,:);
            end
        elseif (ss == 5)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==3,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==24,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==6,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==24,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            end
        elseif (ss == 6)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.70,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.70,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.85,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.65,:);
            end
         elseif (ss == 7)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==3.50,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==3.00,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==3.00,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==3.00,:);
            end
          elseif (ss == 8)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.002,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.004,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.002,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.004,:);
            end
        elseif (ss == 9)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==90,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==90,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==90,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==90,:);
            end
        elseif (ss == 10)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            end
        elseif (ss == 11)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==7,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            end
        elseif (ss == 12)
            if (interface == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (interface == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (interface == 3)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (interface == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            end
        end
        
        %g = grpstats(filteredSnipLen, {'userid', 'topic', 'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
        
        fprintf('I%d\n', interface);
        fprintf('\tDQ: %3.2f\n', mean(filteredSnipLen.mean_click_depth_per_query));
        fprintf('\tCG: %3.2f\n', mean(filteredSnipLen.mean_cg));
        fprintf('\tSaved: %3.2f\n', mean(filteredSnipLen.mean_marked_trec_rel));
        fprintf('\tNew: %3.2f\n', mean(filteredSnipLen.mean_docs_with_new_entities));
    end
end

