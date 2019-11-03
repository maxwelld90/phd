function [] = comparisons_stat_tests(comp_mse_path, interface, ss_best, ss_other)
%COMPARISONS_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the bets approximations, and uses the
%MSE values for the stat tests.
    d = dataset('file', comp_mse_path, 'delimiter', ',');
    
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
        filteredDS = inputDS(inputDS.interface == interface,:);
        filteredDS = filteredDS(filteredDS.ss == ss,:);
        
        if (ss == 1)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_d==18,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_d==15,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_d==18,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_d==18,:);
            end
        elseif (ss == 2)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            end
        elseif (ss == 3)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==6,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            end
        elseif (ss == 4)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            end
        elseif (ss == 5)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_r==8,:);
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            end
        elseif (ss == 6)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.65,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.65,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==0.60,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.65,:);
            end
         elseif (ss == 7)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==5.0,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==4.50,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==4.50,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==5.00,:);
            end
          elseif (ss == 8)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            end
        elseif (ss == 9)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            end
        elseif (ss == 10)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            end
        elseif (ss == 11)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
                filteredDS = filteredDS(filteredDS.u_r==10,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
                filteredDS = filteredDS(filteredDS.u_r==6,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
                filteredDS = filteredDS(filteredDS.u_r==6,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
                filteredDS = filteredDS(filteredDS.u_r==8,:);
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
            end
        end
end

