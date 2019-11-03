function [] = comparisons_bar(comparisons_summarised_path, interface)
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
    
    if interface == 1
        rwCG = 4.09;
    elseif interface == 2
        rwCG = 3.35;
    elseif interface == 3
        rwCG = 4.12;
    elseif interface == 4
        rwCG = 3.49;
    end
    
    cellObs = {'ss','maxCG';
               'RW', rwCG;};
    bestDataset = [bestDataset; cell2dataset(cellObs)];
    
    for (i=1:size(sss,1))
        ss = sss(i);
        filteredSS = filterBySS(filtered, interface, ss);
        ssCG = mean(filteredSS.mean_cg);  % Given the fact we filter by threshold, this is the highest CG on average.
        
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
    
    ylim([0 4.25]);
    xlabel('Result Summary Level Stopping Strategy');
    ylabel('Mean Cumulative Gain (CG)');
    
    bestDataset
end

function [filteredDS] = filterBySS(inputDS, interface, ss)
        filteredDS = inputDS(inputDS.interface == interface,:);
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
            end
         elseif (ss == 7)
            if (interface == 1)
                filteredDS = filteredDS(filteredDS.u_t==3.5,:);
            elseif (interface == 2)
                filteredDS = filteredDS(filteredDS.u_t==3.00,:);
            elseif (interface == 3)
                filteredDS = filteredDS(filteredDS.u_t==3.00,:);
            elseif (interface == 4)
                filteredDS = filteredDS(filteredDS.u_t==3.00,:);
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