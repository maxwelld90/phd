function [  ] = performance_plots(summary_path, ss)
%PERFORMANCE_PLOTS Spits out plots for a given stopping strategy.

% These are used for Figure 1.6 plots. MATLAB does not do the multiple
% plots; that is a pain. Post processing in Illustrator was used to combine
% them together; this script spits out a plot for each individual SS. Use
% the template figure screenshot in the thesis/figures/plots directory to
% work out the correct sizings.

% summary_path = ../summaries/performance.csv
% ss = Pick 1 to 12

    d = dataset('file', summary_path, 'delimiter', ',');
    
    co = [0    0.4470    0.7410
          0.8500    0.3250    0.0980
          0.9290    0.6940    0.1250
          0.4940    0.1840    0.5560];
    set(groot,'defaultAxesColorOrder',co);
    
    snip_lens = unique(d.snip_len);
    se = 0;
    time_limit = 360;
    qs = 13;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        hold all;
        
        for (j=1:size(snip_lens,1))
            snip_len = snip_lens(j);
            
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredLoop = filteredLoop(filteredLoop.snip_len==snip_len,:);
            
            if (ss == 5)
                if (snip_len == 0)
                    filteredLoop = filteredLoop(filteredLoop.u_r==8,:);
                elseif (snip_len == 1)
                    filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
                elseif (snip_len == 2)
                    filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
                elseif (snip_len == 4)
                    filteredLoop = filteredLoop(filteredLoop.u_r==3,:);
                end
            elseif (ss == 11)
                if (snip_len == 0)
                    filteredLoop = filteredLoop(filteredLoop.u_r==8,:);
                elseif (snip_len == 1)
                    filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
                elseif (snip_len == 2)
                    filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
                elseif (snip_len == 4)
                    filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
                end
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
            
            filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
            
            plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_cg, ls, 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('T%d', snip_len));
        end
        
        the_legend = legend(gca, 'show');
        set(the_legend, 'FontSize', 16);
        xlim([0 25]);
        ylim([0 3]);
        xlabel('Mean Depth per Query');
        ylabel('Cumulative Gain (CG)');
    end
end

