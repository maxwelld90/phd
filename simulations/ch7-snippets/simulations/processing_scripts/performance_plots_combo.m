function [  ] = performance_plots_combo(summary_path, ss)
%PERFORMANCE_PLOTS_COMBO Spits out plots for a combo strategy.
% Not much is being shown here, so I haven't included them.
% However, it generates a plot for a given stopping strategy (5 or 11).
% Generates all possible combinations, to show the difference as the
% parameters vary.

% summary_path = ../summaries/performance.csv
% ss = 5 or 11

    d = dataset('file', summary_path, 'delimiter', ',');
    
    snip_len = 2;
    se = 0;
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    
    hold all;
    set(groot,'defaultAxesColorOrder', parula, 'defaultAxesLineStyleOrder','-|--|:');
    relVals = unique(filtered.u_r);
    
    threshName = '';
    
    if (ss == 5)
        threshName = 'x_2 =';
    elseif (ss == 11)
        threshName = 'x_{10} =';
    end
    
    ls = {'-+', '-o', '-*', '-x', '-s', '-d', '-p', '-h', '-^', '-v'};
    
    for (i=1:size(relVals,1))
        rVal = relVals(i);
        filteredLoop = filtered(filtered.u_r==rVal,:);
        
        displayName = sprintf('%s%d', threshName, rVal);
        
        filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
        plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_cg, ls{i}, 'LineWidth', 4, 'MarkerSize', 10, 'DisplayName', displayName);
    end
    
    xlim([0 25]);
    ylim([0 3]);
    xlabel('Mean Depth per Query');
    ylabel('Cumulative Gain (CG)');
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
end

