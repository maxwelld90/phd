function [ ] = query_performance_plot( )
%QUERY_PERFORMANCE_PLOT For the discussion, plots queryperf.
    co = [0    0.4470    0.7410
      0.8500    0.3250    0.0980
      0.9290    0.6940    0.1250
      0.4940    0.1840    0.5560];
    set(groot,'defaultAxesColorOrder',co);

    t0 = [49 39 41 26 21 3 10 7 0 1 0];
    t1 = [38 38 42 19 15 6 5 2 4 0 0 ];
    t2 = [39 37 45 23 11 5 10 4 1 0 0 ];
    t4 = [43 33 52 3 3 7 5 4 3 4 2];
    
    hold all;
    
    plot(t0, '-o', 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', 'T0');
    plot(t1, '-*', 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', 'T1');
    plot(t2, '-s', 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', 'T2');
    plot(t4, '-d', 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', 'T4');
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
    %xlim([0 25]);
    %ylim([0 3]);
    xlabel('P@10');
    xticklabels({'0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6' ,'0.7', '0.8', '0.9' ,'1.0'})
    ylabel('Number of Queries');

end

