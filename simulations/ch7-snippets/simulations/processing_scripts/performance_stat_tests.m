function [] = performance_stat_tests(summary_path, snip_len, ss_best, ss_other)
%PERFORMANCE_STAT_TESTS Given a snippet len condition, the SS to compare
%from, and a SS to compare to, reports the p value for the comparison
%between the two. If greater than 0.05, the difference is not significant,
%and therefore the other stopping strategy's performance is similar to the
%first one. Uses the thresholds for the highest performance, and uses the
%CG values for the stat tests.
    d = dataset('file', summary_path, 'delimiter', ',');
    
    se = 0;
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestFiltered = filtered;
    bestFiltered = filterBySS(bestFiltered, snip_len, ss_best);
    bestCG = bestFiltered.cg;
    
    otherFiltered = filtered;
    otherFiltered = filterBySS(otherFiltered, snip_len, ss_other);
    otherCG = otherFiltered.cg;
    
    std(bestCG)
    
    [h,p] = ttest2(bestCG, otherCG);
    
    fprintf('T%d: comparing SS%d against SS%d over CG\n', snip_len, ss_best, ss_other);
    fprintf('p value: %3.4f\n', p);
    
    if p < 0.05
        fprintf('WHITE BACKGROUND CELL!!!!!!!!!!!!!!!\n');
    else
        fprintf('LIGHT BLUE CELL\n');
    end
end

function [filteredDS] = filterBySS(inputDS, snip_len, ss)
        filteredDS = inputDS(inputDS.snip_len == snip_len,:);
        filteredDS = filteredDS(filteredDS.ss == ss,:);
        
        if (ss == 1)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_d==24,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_d==10,:);
            end
        elseif (ss == 2)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==7,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==6,:);
            end
        elseif (ss == 3)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==4,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==5,:);
            end
        elseif (ss == 4)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==2,:);
            end
        elseif (ss == 5)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==8,:);
                filteredDS = filteredDS(filteredDS.u_n==24,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==8,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
                filteredDS = filteredDS(filteredDS.u_n==9,:);
            end
        elseif (ss == 6)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==0.55,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.35,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.55,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.55,:);
            end
         elseif (ss == 7)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==3.5,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==6.0,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==6.0,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==6.0,:);
            end
          elseif (ss == 8)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_g==0.002,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            end
        elseif (ss == 9)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==120,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==60,:);
            end
        elseif (ss == 10)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==20,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            end
        elseif (ss == 11)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==8,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==10,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==10,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==10,:);
                filteredDS = filteredDS(filteredDS.u_r==10,:);
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
            end
        end
end

