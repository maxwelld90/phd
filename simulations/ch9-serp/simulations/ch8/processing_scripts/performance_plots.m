function [  ] = performance_plots(summary_path, ss)
%PERFORMANCE_PLOTS Spits out plots for a given stopping strategy,
%considering the different SERP stopping decision point implementations.

% summary_path = ../summaries/performance.csv
% ss = Pick 1,2 or 11

    d = dataset('file', summary_path, 'delimiter', ',');
    
    co = [0.6901 0.1019 0.1960
          0.4274 0.6705 0.2509
          0.3010 0.7450 0.9330];
    set(groot,'defaultAxesColorOrder',co);
    
    ses = unique(d.se);
    time_limit = 500;
    qs = 13;
    decision_maker = 1;
    interface = 4;
    
    filtered = d(d.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.interface==interface,:);
    
    hold all;
        
    for (i=1:size(ses,1))
        se = ses(i);
        filteredLoop = filtered(filtered.se==se,:);
        
        if (ss == 11)
            if (se == 0)
                filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
            elseif (se == 1)
                filteredLoop = filteredLoop(filteredLoop.u_r==5,:);
            elseif (se == 2)
                filteredLoop = filteredLoop(filteredLoop.u_r==0,:);
            end
        elseif (ss == 5)
            if (se == 0)
                filteredLoop = filteredLoop(filteredLoop.u_r==6,:);
            elseif (se == 1)
                filteredLoop = filteredLoop(filteredLoop.u_r==3,:);
            elseif (se == 2)
                filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
            end
        end

        
        filteredGrp = grpstats(filteredLoop, {'interface', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
        
        if (se == 0)
            ls = '-x';
        elseif (se == 1)
            ls = '-o';
        elseif (se == 2)
            ls = '-^';
        end
        
        plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_cg, ls, 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('SE%d', se));
    end
    
    the_legend = legend(gca, 'show');
    set(the_legend, 'FontSize', 16);
    xlim([0 25]);
    ylim([0.5 3.5]);
    xlabel('Mean Depth per Query');
    ylabel('Cumulative Gain (CG)');

end

