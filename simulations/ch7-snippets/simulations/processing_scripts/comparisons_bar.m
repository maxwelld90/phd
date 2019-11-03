function [] = comparisons_bar(comparisons_summarised_path, snip_len)
%COMPARISONS_BAR Given the comp persession summary file, produces a bar
%chart of the levels of CG (mean) that are attained across each stopping
%strategy, with RW values.
    d = dataset('file', comparisons_summarised_path, 'delimiter', ',');
    
    se = 0;
    sss = unique(d.ss);
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    bestDataset = dataset([],[],'VarNames',{'ss', 'maxCG'});
    rwCG = 0;
    
    if snip_len == 0
        rwCG = 1.87;
    elseif snip_len == 1
        rwCG = 1.83;
    elseif snip_len == 2
        rwCG = 2.36;
    elseif snip_len == 4
        rwCG = 1.87;
    end
    
    cellObs = {'ss','maxCG';
               'RW', rwCG;};
    bestDataset = [bestDataset; cell2dataset(cellObs)];
    
    for (i=1:size(sss,1))
        ss = sss(i);
        filteredSS = filterBySS(filtered, snip_len, ss);
        ssCG = mean(filteredSS.sum_mean_cg);  % Given the fact we filter by threshold, this is the highest CG on average.
        
        % Add to the dataset.
        cellObs = {'ss','maxCG';
                   sprintf('SS%d', ss), ssCG;};
        bestDataset = [bestDataset; cell2dataset(cellObs)];
    end
    
    bestDataset = sortrows(bestDataset, 'maxCG');  % Sort by CG, in ascending order
    x = categorical(bestDataset.ss);
    x = reordercats(x, bestDataset.ss);
    y = bestDataset.maxCG;
    bar(x, y);
    set(gca,'xticklabel', bestDataset.ss)
    
    ylim([0 2.5]);
    xlabel('Result Summary Level Stopping Strategy');
    ylabel('Mean Cumulative Gain (CG)');
    
    bestDataset
end

function [filteredDS] = filterBySS(inputDS, snip_len, ss)
        filteredDS = inputDS(inputDS.snip_len == snip_len,:);
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