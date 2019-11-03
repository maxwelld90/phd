function [] = performance_stat_tests(summary_path, interface, ss_best, ss_other)
%PERFORMANCE_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the highest performance, and uses the
%CG values for the stat tests.
    d = dataset('file', summary_path, 'delimiter', ',');
    
    se = 0;
    time_limit = 500;
    qs = 13;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestFiltered = filtered;
    bestFiltered = filterBySS(bestFiltered, interface, ss_best);
    bestCG = bestFiltered.cg;
    
    otherFiltered = filtered;
    otherFiltered = filterBySS(otherFiltered, interface, ss_other);
    otherCG = otherFiltered.cg;
    
    [h,p] = ttest2(bestCG, otherCG);
    
    fprintf('I%d: comparing SS%d against SS%d over CG\n', interface, ss_best, ss_other);
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
                filteredDS = filteredDS(filteredDS.u_d==7,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_d==7,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            end
        elseif (ss == 2)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==9,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            end
        elseif (ss == 3)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_n==4,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_n==4,:);
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
                filteredDS = filteredDS(filteredDS.u_r==3,:);
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
                filteredDS = filteredDS(filteredDS.u_n==7,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_r==6,:);
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            end
        elseif (ss == 6)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.30,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.55,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==0.30,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.55,:);
            end
         elseif (ss == 7)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==5.5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==6.5,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==5.5,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==6.5,:);
            end
          elseif (ss == 8)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.008,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.008,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.010,:);
            end
        elseif (ss == 9)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            end
        elseif (ss == 10)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            end
        elseif (ss == 11)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==6,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==6,:);
            end
        elseif (ss == 12)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_p==0.95,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_p==0.99,:);
            end
        end
end

