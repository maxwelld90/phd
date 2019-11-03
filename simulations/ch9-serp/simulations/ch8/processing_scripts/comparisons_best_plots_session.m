function [] = comparisons_best_plot_session(mse_session_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    interface = 4;
    ses = [0 2 1];
    decision_maker = 1;
    userids = unique(d.userid);
    
    filtered = d(d.interface==interface,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    hold all;
    
    colors = containers.Map();
    colors('0') = [0.6901 0.1019 0.1960];
    colors('1') = [0.4274 0.6705 0.2509];
    colors('2') = [0.3010 0.7450 0.9330];
    
    % Plot the Real-world D/Q values first
    plot([13.94 13.94], [0 250], '--', 'Color', [0.2274 0.2274 0.3176], 'LineWidth', 4, 'DisplayName', 'RW ND-AD');
    
    for (i=1:size(ses,2))
        se = ses(i);
        filteredLoop = filtered(filtered.se==se,:);
        
        meanMSEClick = [];
        meanDQClick = [];
        
        if (ss == 1)
            thresholds = unique(filteredLoop.u_d);
        elseif (ss == 2 || ss == 3)
            thresholds = unique(filteredLoop.u_n);
        elseif (ss == 4)
            thresholds = unique(filteredLoop.u_r);
        elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
            thresholds = unique(filteredLoop.u_t);
        elseif (ss == 8)
            thresholds = unique(filteredLoop.u_g);
        elseif (ss == 12)
            thresholds = unique(filteredLoop.u_p);
        elseif (ss == 5)
            thresholds = unique(filteredLoop.u_n);
        elseif (ss == 11)
            thresholds = unique(filteredLoop.u_t);
        end
        
        for (k=1:size(thresholds,1))
            threshold = thresholds(k);
            
            if (ss == 1)
                filteredThresh = filteredLoop(filteredLoop.u_d==threshold,:);
            elseif (ss == 2 || ss == 3)
                filteredThresh = filteredLoop(filteredLoop.u_n==threshold,:);
            elseif (ss == 4)
                filteredThresh = filteredLoop(filteredLoop.u_r==threshold,:);
            elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                filteredThresh = filteredLoop(filteredLoop.u_t==threshold,:);
            elseif (ss == 8)
                filteredThresh = filteredLoop(filteredLoop.u_g==threshold,:);
            elseif (ss == 12)
                filteredThresh = filteredLoop(filteredLoop.u_p==threshold,:);
            elseif (ss == 5)
                filteredThresh = filteredLoop(filteredLoop.u_n==threshold,:);

                if (se == 0)
                    filteredThresh = filteredThresh(filteredThresh.u_r==5,:);
                elseif (se == 1)
                    filteredThresh = filteredThresh(filteredThresh.u_r==5,:);
                elseif (se == 2)
                    filteredThresh = filteredThresh(filteredThresh.u_r==8,:);
                end
            end
            
            g = grpstats(filteredThresh, {'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t'});
            
            meanMSEClick = [meanMSEClick g.mean_mse_click_depth];
            meanDQClick = [meanDQClick g.mean_mean_click_depth_per_query];
        end
        
        if (se == 0)
            ls = '-x';
        elseif (se == 1)
            ls = '-o';
        elseif (se == 2)
            ls = '-^';
        end

        plot(meanDQClick, meanMSEClick, ls, 'Color', colors(num2str(se)), 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('SE%d', se));
        
    end
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
    xlim([5 20]);
    ylim([50 250]);
    xlabel('Mean Depth per Query');
    ylabel('Cumulative Gain (CG)');
    
end

