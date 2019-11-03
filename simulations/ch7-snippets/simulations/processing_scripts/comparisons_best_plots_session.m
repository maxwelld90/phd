function [] = comparisons_best_plot_session(mse_session_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    snip_lens = unique(d.snip_len);
    se = 0;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    userids = unique(d.userid);
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    hold all;
    
    colors = containers.Map();
    colors('0') = [0 0.4470 0.7410];
    colors('1') = [0.85 0.325 0.098];
    colors('2') = [0.929 0.694 0.125];
    colors('4') = [0.494 0.184 0.556];
    
    % Plot the Real-world D/Q values first
    plot([15.421 15.421], [0 550], '--', 'Color', [0 0.4470 0.7410], 'LineWidth', 4, 'DisplayName', 'RW T0');
    plot([17.044 17.044], [0 550], '--', 'Color', [0.85 0.325 0.098], 'LineWidth', 4, 'DisplayName', 'RW T1');
    plot([14.391 14.391], [0 550], '--', 'Color', [0.929 0.694 0.125], 'LineWidth', 4, 'DisplayName', 'RW T2');
    plot([13.736 13.736], [0 550], '--', 'Color', [0.494 0.184 0.556], 'LineWidth', 4, 'DisplayName', 'RW T4');
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        for (j=1:size(snip_lens,1))
            snip_len = snip_lens(j);
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredSnipLoop = filteredLoop(filteredLoop.snip_len==snip_len,:);
            
            meanMSEClick = [];
            meanDQClick = [];
            
            if (ss == 1)
                thresholds = unique(filteredSnipLoop.u_d);
            elseif (ss == 2 || ss == 3)
                thresholds = unique(filteredSnipLoop.u_n);
            elseif (ss == 4)
                thresholds = unique(filteredSnipLoop.u_r);
            elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                thresholds = unique(filteredSnipLoop.u_t);
            elseif (ss == 8)
                thresholds = unique(filteredSnipLoop.u_g);
            elseif (ss == 12)
                thresholds = unique(filteredSnipLoop.u_p);
            elseif (ss == 5)
                thresholds = unique(filteredSnipLoop.u_n);
            elseif (ss == 11)
                thresholds = unique(filteredSnipLoop.u_t);
            end
            
            for (k=1:size(thresholds,1))
                threshold = thresholds(k);
                
                if (ss == 1)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_d==threshold,:);
                elseif (ss == 2 || ss == 3)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_n==threshold,:);
                elseif (ss == 4)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_r==threshold,:);
                elseif (ss == 6 || ss == 7 || ss == 9 || ss == 10)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_t==threshold,:);
                elseif (ss == 8)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_g==threshold,:);
                elseif (ss == 12)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_p==threshold,:);
                elseif (ss == 5)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_n==threshold,:);
                    
                    if (snip_len == 0)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    elseif (snip_len == 1)
                        filteredThresh = filteredThresh(filteredThresh.u_r==7,:);
                    elseif (snip_len == 2)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    elseif (snip_len == 4)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    end
                elseif (ss == 11)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_t==threshold,:);
                    
                    if (snip_len == 0)
                        filteredThresh = filteredThresh(filteredThresh.u_r==9,:);
                    elseif (snip_len == 1)
                        filteredThresh = filteredThresh(filteredThresh.u_r==10,:);
                    elseif (snip_len == 2)
                        filteredThresh = filteredThresh(filteredThresh.u_r==8,:);
                    elseif (snip_len == 4)
                        filteredThresh = filteredThresh(filteredThresh.u_r==2,:);
                    end
                end
                
                g = grpstats(filteredThresh, {'snip_len', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
                
                meanMSEClick = [meanMSEClick g.mean_mse_click_depth];
                meanDQClick = [meanDQClick g.mean_mean_mean_click_depth];
            end
            
            ls = '-';
            
            if (snip_len == 0)
                ls = '-o';
            elseif (snip_len == 1)
                ls = '-*';
            elseif (snip_len == 2)
                ls = '-s';
            elseif (snip_len == 4)
                ls = '-d';
            end
            
            plot(meanDQClick, meanMSEClick, ls, 'Color', colors(num2str(snip_len)), 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('T%d', snip_len));
        end
    end
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
    xlim([0 25]);
    ylim([50 550]);
    xlabel('Mean Depth per Query');
    ylabel('Cumulative Gain (CG)');
end

