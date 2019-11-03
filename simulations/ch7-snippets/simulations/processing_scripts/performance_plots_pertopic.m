function [  ] = performance_plots_pertopic(summary_path, ss)
%PERFORMANCE_PLOTS Spits out plots for a given stopping strategy.

% These are used for Figure 1.6 plots. MATLAB does not do the multiple
% plots; that is a pain. Post processing in Illustrator was used to combine
% them together; this script spits out a plot for each individual SS. Use
% the template figure screenshot in the thesis/figures/plots directory to
% work out the correct sizings.

% summary_path = ../summaries/performance.csv
% ss = Pick 1 to 12

    d = dataset('file', summary_path, 'delimiter', ',');
    
    co = [0.843 0.098   0.109
          0.992 0.682   0.380
          0.847	0.847	0.545
          0.671 0.866   0.643
          0.168 0.513   0.729];
    set(groot,'defaultAxesColorOrder',co);
    
    snip_len = 2;
    se = 0;
    time_limit = 360;
    qs = 13;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    topics = unique(d.topic);
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        hold all;
        
        for (j=1:size(topics,1))
            topic = topics(j);
            
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredLoop = filteredLoop(filteredLoop.topic==topic,:);
            
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
            
            if (topic == 341)
                ls = '-o';
            elseif (topic == 347)
                ls = '-x';
            elseif (topic == 367)
                ls = '-s';
            elseif (topic == 408)
                ls = '-^';
            elseif (topic == 435)
                ls = '-v';
            end
            
            filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'topic', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
            
            plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_cg, ls, 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('Topic %d', topic));
        end
        
        the_legend = legend(gca, 'show');
        set(the_legend, 'FontSize', 16);
        xlim([0 25]);
        ylim([0 6]);
        xlabel('Mean Depth per Query');
        ylabel('Cumulative Gain (CG)');
    end
end

