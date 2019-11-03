function [] = comparisons_stat_tests_session(comp_session_mse_path, interface, ss_best, ss_other)
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
    bestFiltered = filterBySS(bestFiltered, interface, ss_best);
    bestMSE = bestFiltered.mse_click_depth;
    
    otherFiltered = filtered;
    otherFiltered = filterBySS(otherFiltered, interface, ss_other);
    otherMSE = otherFiltered.mse_click_depth;
    
    mean(bestMSE)
    mean(otherMSE)
    
    [h,p] = ttest2(bestMSE, otherMSE);
    
    fprintf('T%d: comparing SS%d against SS%d over MSE Click Depths\n', interface, ss_best, ss_other);
    fprintf('p value: %3.4f\n', p);
    
    if p < 0.05
        fprintf('WHITE BACKGROUND CELL!!!!!!!!!!!!!!!\n');
    else
        fprintf('LIGHT BLUE CELL\n');
    end
end

function [filteredDS] = filterBySS(inputDS, interface, ss)
        if (interface == 5)
            filteredDS = inputDS;
        else
            filteredDS = inputDS(inputDS.interface == interface,:);
        end
        
        filteredDS = filteredDS(filteredDS.ss == ss,:);
        
        if (ss == 1)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_d==21,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            end
        elseif (ss == 2)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            end
        elseif (ss == 3)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==9,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==9,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            end
        elseif (ss == 4)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            end
        elseif (ss == 5)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            end
        elseif (ss == 6)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==0.85,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.65,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            end
         elseif (ss == 7)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==3.5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==3.0,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==3.0,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==3.0,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_t==3.0,:);
            end
          elseif (ss == 8)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.002,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_g==0.002,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            end
        elseif (ss == 9)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            end
        elseif (ss == 10)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            end
        elseif (ss == 11)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==7,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            end
        elseif (ss == 12)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 5)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            end
        end
end

