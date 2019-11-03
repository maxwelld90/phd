function [] = comparisons_bar(summary_path, snip_len)
%PERFORMANCE_BAR Uses the thresholds with the lowest reported MSE.
%   Detailed explanation goes here
    d = dataset('file', summary_path, 'delimiter', ',');

    se = 0;
    time_limit = 360;
    qs = 13;
    sss = unique(d.ss);
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    hold all;
    rwCG = 0;
    bestDataset = dataset([],[],'VarNames',{'ss', 'maxCG'});
    
    if snip_len == 0
        rwCG = 1.10;
    elseif snip_len == 1
        rwCG = 1.14;
    elseif snip_len == 2
        rwCG = 1.17;
    elseif snip_len == 4
        rwCG = 1.21;
    end
    
    cellObs = {'ss','maxCG';
              'RW', rwCG;};  % 0 is the real-world observation
    bestDataset = [bestDataset; cell2dataset(cellObs)];
    
    for (i=1:size(sss,1))
        ss = sss(i);
        filteredLoop = filtered(filtered.ss==ss,:);
        filteredSS = filterBySS(inputDS, snip_len, ss)
        
        filteredGrp = grpstats(filteredSS, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
        filteredGrp
        
        %fprintf('SS%d: %3.2f\n', ss, filteredGrp.mean_cg);
        
        % Add to the dataset.
        cellObs = {'ss','maxCG';
               sprintf('SS%d', ss), filteredGrp.mean_cg;};
        bestDataset = [bestDataset; cell2dataset(cellObs)];
    end
    
    bestDataset = sortrows(bestDataset, 'maxCG');
    
    x = categorical(bestDataset.ss);
    x = reordercats(x);
    y = bestDataset.maxCG;
    
    bar(x, y);

end

function [filteredDS] = filterBySS(inputDS, snip_len, ss)
        filteredDS = inputDS(inputDS.snip_len == snip_len,:);
        filteredDS = filteredDS(filteredDS.ss == ss,:);
        
        if (ss == 1)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_d==21,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_d==18,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_d==15,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_d==18,:);
            end
        elseif (ss == 2)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==10,:);
            end
        elseif (ss == 3)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_n==3,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_n==4,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_n==4,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_n==3,:);
            end
        elseif (ss == 4)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==3,:);
            end
        elseif (ss == 5)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_r==8,:);
                filteredDS = filteredDS(filteredDS.u_n==15,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==21,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_r==4,:);
                filteredDS = filteredDS(filteredDS.u_n==18,:);
            end
        elseif (ss == 6)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==0.70,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==0.60,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==0.60,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==0.60,:);
            end
         elseif (ss == 7)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==5.0,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==5.50,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==4.50,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==4.00,:);
            end
          elseif (ss == 8)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_g==0.004,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_g==0.006,:);
            end
        elseif (ss == 9)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==120,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==90,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==120,:);
            end
        elseif (ss == 10)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
            end
        elseif (ss == 11)
            if (snip_len == 0)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==5,:);
            elseif (snip_len == 1)
                filteredDS = filteredDS(filteredDS.u_t==40,:);
                filteredDS = filteredDS(filteredDS.u_r==8,:);
            elseif (snip_len == 2)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
                filteredDS = filteredDS(filteredDS.u_r==9,:);
            elseif (snip_len == 4)
                filteredDS = filteredDS(filteredDS.u_t==30,:);
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
