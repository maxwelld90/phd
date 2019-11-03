function [] = comparisons_best_plot_session(mse_session_path, ss)
%COMPARISONS_TABLE Spits out TeX code for the MSE table.
%   Blah blah
    
    d = dataset('file', mse_session_path, 'delimiter', ',');
    
    interfaces = unique(d.interface);
    se = 0;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    userids = unique(d.userid);
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    hold all;
    
    colors = containers.Map();
    colors('1') = [0.4660 0.6740 0.1880];
    colors('2') = [0.3010 0.7450 0.9330];
    colors('3') = [0.6350 0.0780 0.1840];
    colors('4') = [0.2274 0.2274 0.3176];
    
    % Plot the Real-world D/Q values first
    plot([12.85 12.85], [0 550], '--', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 4, 'DisplayName', 'RW D-AS');
    plot([15.73 15.73], [0 550], '--', 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 4, 'DisplayName', 'RW ND-AS');
    plot([16.19 16.19], [0 550], '--', 'Color', [0.6350 0.0780 0.1840], 'LineWidth', 4, 'DisplayName', 'RW D-AD');
    plot([13.94 13.94], [0 550], '--', 'Color', [0.2274 0.2274 0.3176], 'LineWidth', 4, 'DisplayName', 'RW ND-AD');
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        for (j=1:size(interfaces,1))
            interface = interfaces(j);
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredSnipLoop = filteredLoop(filteredLoop.interface==interface,:);
            
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
                    
                    if (interface == 1)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    elseif (interface == 2)
                        filteredThresh = filteredThresh(filteredThresh.u_r==7,:);
                    elseif (interface == 3)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    elseif (interface == 4)
                        filteredThresh = filteredThresh(filteredThresh.u_r==6,:);
                    end
                elseif (ss == 11)
                    filteredThresh = filteredSnipLoop(filteredSnipLoop.u_t==threshold,:);
                    
                    if (interface == 1)
                        filteredThresh = filteredThresh(filteredThresh.u_r==9,:);
                    elseif (interface == 2)
                        filteredThresh = filteredThresh(filteredThresh.u_r==10,:);
                    elseif (interface == 3)
                        filteredThresh = filteredThresh(filteredThresh.u_r==8,:);
                    elseif (interface == 4)
                        filteredThresh = filteredThresh(filteredThresh.u_r==2,:);
                    end
                end
                
                g = grpstats(filteredThresh, {'interface', 'se', 'ss', 'decision_maker', 'u_n', 'u_d', 'u_r', 'u_t', 'u_g', 'u_p'});
                
                meanMSEClick = [meanMSEClick g.mean_mse_click_depth];
                meanDQClick = [meanDQClick g.mean_mean_click_depth_per_query];
            end
            
            ls = '-';
            
            if (interface == 1)
                ls = '-p';
                label = 'D-AS';
            elseif (interface == 2)
                ls = '-h';
                label = 'ND-AS';
            elseif (interface == 3)
                ls = '-^';
                label = 'D-AD';
            elseif (interface == 4)
                ls = '-v';
                label = 'ND-AD';
            end
            
            plot(meanDQClick, meanMSEClick, ls, 'Color', colors(num2str(interface)), 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', label);
        end
    end
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
    xlim([0 25]);
    ylim([50 550]);
    xlabel('Mean Depth per Query');
    ylabel('Cumulative Gain (CG)');
end

