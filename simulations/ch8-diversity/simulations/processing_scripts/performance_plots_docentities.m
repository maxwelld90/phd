function [  ] = performance_plots_docentities(summary_path, ss)
%PERFORMANCE_PLOTS Spits out plots for a given stopping strategy.

% These are used for Figure 1.6 plots. MATLAB does not do the multiple
% plots; that is a pain. Post processing in Illustrator was used to combine
% them together; this script spits out a plot for each individual SS. Use
% the template figure screenshot in the thesis/figures/plots directory to
% work out the correct sizings.

% summary_path = ../summaries/performance.csv
% ss = Pick 1 to 12

    d = dataset('file', summary_path, 'delimiter', ',');
    interfaces = unique(d.interface);
    se = 0;
    time_limit = 500;
    qs = 13;
    %sss = unique(d.ss);
    sss = ss;
    decision_maker = 1;
    
    % Change colours.
    co = [0.4660 0.6740 0.1880
          0.3010 0.7450 0.9330
          0.6350 0.0780 0.1840
          0.2274 0.2274 0.3176];
    
    set(groot, 'defaultAxesColorOrder', co);
    
    filtered = d(d.se==se,:);
    filtered = filtered(filtered.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    
    for (i=1:size(sss,1))
        ss = sss(i);
        
        hold all;
        
        for (j=1:size(interfaces,1))
            interface = interfaces(j);
            
            filteredLoop = filtered(filtered.ss==ss,:);
            filteredLoop = filteredLoop(filteredLoop.interface==interface,:);
            
            if (ss == 5)
                if (interface == 1)
                    filteredLoop = filteredLoop(filteredLoop.u_r==3,:);
                elseif (interface == 2)
                    filteredLoop = filteredLoop(filteredLoop.u_r==6,:);
                elseif (interface == 3)
                    filteredLoop = filteredLoop(filteredLoop.u_r==3,:);
                elseif (interface == 4)
                    filteredLoop = filteredLoop(filteredLoop.u_r==6,:);
                end
            elseif (ss == 11)
                if (interface == 1)
                    filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
                elseif (interface == 2)
                    filteredLoop = filteredLoop(filteredLoop.u_r==6,:);
                elseif (interface == 3)
                    filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
                elseif (interface == 4)
                    filteredLoop = filteredLoop(filteredLoop.u_r==6,:);
                end
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
            
            filteredGrp = grpstats(filteredLoop, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_p', 'u_d', 'u_g'});
            plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_new_docs_with_entities, ls, 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', label);
        end
        
        the_legend = legend(gca, 'show');
        set(the_legend, 'FontSize', 16);
        xlim([0 25]);
        ylim([0 1.2]);
        xlabel('Mean Depth per Query');
        ylabel('Aspectual Recall');
    end
end

