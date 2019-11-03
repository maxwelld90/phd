function [] = comparisons_stat_tests_session(comp_session_mse_path, snip_len, ss_best, ss_other)
%COMPARISONS_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the bets approximations, and uses the
%MSE values for the stat tests.
    d = dataset('file', comp_session_mse_path, 'delimiter', ',');
    
    se = 0;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestFiltered = filtered;
    bestFiltered = filterBySS(bestFiltered, snip_len, ss_best);
    bestMSE = bestFiltered.mse_click_depth;
    
    otherFiltered = filtered;
    otherFiltered = filterBySS(otherFiltered, snip_len, ss_other);
    otherMSE = otherFiltered.mse_click_depth;
    
    mean(bestMSE)
    
    [h,p] = ttest2(bestMSE, otherMSE);
    
    fprintf('T%d: comparing SS%d against SS%d over MSE Click Depths\n', snip_len, ss_best, ss_other);
    fprintf('p value: %3.4f\n', p);
    
    if p < 0.05
        fprintf('WHITE BACKGROUND CELL!!!!!!!!!!!!!!!\n');
    else
        fprintf('LIGHT BLUE CELL\n');
    end
end

function [filteredDS] = filterBySS(inputDS, snip_len, ss)
        if (snip_len == 5)
            filteredDS = inputDS;
        else
            filteredDS = inputDS(inputDS.snip_len == snip_len,:);
        end
        
        filteredDS = filteredDS(filteredDS.ss == ss,:);
        
        if (ss == 1)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_d==21,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_d==21,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            end
        elseif (ss == 2)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            end
        elseif (ss == 3)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==9,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==7,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==6,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==6,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_n==6,:);
            end
        elseif (ss == 4)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            end
        elseif (ss == 5)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==8,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            end
        elseif (ss == 6)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==0.90,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.65,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            end
         elseif (ss == 7)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==4.0,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==4.50,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==4.50,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==4.00,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_t==4.00,:);
            end
          elseif (ss == 8)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_g==0.002,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.002,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            end
        elseif (ss == 9)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==120,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==150,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==150,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==150,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_t==120,:);
            end
        elseif (ss == 10)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==40,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==40,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            end
        elseif (ss == 11)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==9,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==40,:);
                filteredDS = filteredDS(filteredDS.u_r==10,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==8,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==50,:);
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_t==40,:);
                filteredDS = filteredDS(filteredDS.u_r==9,:);
            end
        elseif (ss == 12)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (snip_len == 5)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            end
        end
end

