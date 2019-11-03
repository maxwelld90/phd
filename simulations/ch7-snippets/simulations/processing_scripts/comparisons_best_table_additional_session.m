function [] = comparisons_best_table_additional_session(mse_comp_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_comp_path, 'delimiter', ',');
    
    snip_lens = unique(d.snip_len);
    se = 0;
    %sss = unique(d.ss);
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filteredLoop = filtered(filtered.ss==ss,:);
    
    for (i=1:size(snip_lens,1))
        snip_len = snip_lens(i);
        filteredSnipLen = filteredLoop(filteredLoop.snip_len==snip_len,:);
        
        if (ss == 1)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==24,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==24,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==21,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_d==21,:);
            end
        elseif (ss == 2)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==18,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==15,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==15,:);
            end
        elseif (ss == 3)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==9,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==7,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==6,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==6,:);
            end
        elseif (ss == 4)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==4,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==5,:);
            end
        elseif (ss == 5)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==6,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==24,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==8,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==6,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==21,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==6,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_n==24,:);
            end
        elseif (ss == 6)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.90,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.70,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.70,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==0.65,:);
            end
         elseif (ss == 7)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==4.00,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==4.50,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==4.50,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==4.00,:);
            end
          elseif (ss == 8)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.002,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.002,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.004,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_g==0.004,:);
            end
        elseif (ss == 9)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==120,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==150,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==150,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==150,:);
            end
        elseif (ss == 10)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==40,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==40,:);
            end
        elseif (ss == 11)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==9,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==40,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==10,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==30,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==8,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_t==50,:);
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_r==2,:);
            end
        elseif (ss == 12)
            if (snip_len == 0)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (snip_len == 1)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (snip_len == 2)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            elseif (snip_len == 4)
                filteredSnipLen = filteredSnipLen(filteredSnipLen.u_p==0.99,:);
            end
        end
        
        %g = grpstats(filteredSnipLen, {'userid', 'topic', 'snip_len', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
        
        fprintf('T%d\n', snip_len);
        fprintf('\tDQ: %3.2f\n', mean(filteredSnipLen.mean_mean_click_depth));
        fprintf('\tCG: %3.2f\n', mean(filteredSnipLen.sum_mean_cg));
        fprintf('\tSaved: %3.2f\n', mean(filteredSnipLen.sum_mean_saved_trec_rel));
    end
end

