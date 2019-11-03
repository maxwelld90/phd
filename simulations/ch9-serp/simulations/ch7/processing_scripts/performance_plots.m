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
    
    snip_lens = unique(d.snip_len);
    ses = unique(d.se);
    time_limit = 360;
    qs = 13;
    decision_maker = 1;
    snip_len = 2;
    
    filtered = d(d.time_limit==time_limit,:);
    filtered = filtered(filtered.qs==qs,:);
    filtered = filtered(filtered.decision_maker==decision_maker,:);
    filtered = filtered(filtered.ss==ss,:);
    filtered = filtered(filtered.snip_len==snip_len,:);
    
    hold all;
        
    for (i=1:size(ses,1))
        se = ses(i);
        filteredLoop = filtered(filtered.se==se,:);

        if (ss == 5)
            if (se == 0)
                filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
            elseif (se == 1)
                filteredLoop = filteredLoop(filteredLoop.u_r==7,:);
            elseif (se == 2)
                filteredLoop = filteredLoop(filteredLoop.u_r==9,:);
            end
        elseif (ss == 11)
            if (se == 0)
                filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
            elseif (se == 1)
                filteredLoop = filteredLoop(filteredLoop.u_r==5,:);
            elseif (se == 2)
                filteredLoop = filteredLoop(filteredLoop.u_r==0,:);
            end
        end
        
        filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
        
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
    
%     for (i=1:size(sss,1))
%         ss = sss(i);
%         
%         hold all;
%         
%         for (j=1:size(snip_lens,1))
%             snip_len = snip_lens(j);
%             
%             
%             
%             
%             if (ss == 5)
%                 if (snip_len == 0)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==8,:);
%                 elseif (snip_len == 1)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
%                 elseif (snip_len == 2)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==4,:);
%                 elseif (snip_len == 4)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==3,:);
%                 end
%             elseif (ss == 11)
%                 if (snip_len == 0)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==8,:);
%                 elseif (snip_len == 1)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
%                 elseif (snip_len == 2)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
%                 elseif (snip_len == 4)
%                     filteredLoop = filteredLoop(filteredLoop.u_r==10,:);
%                 end
%             end
%             
%             ls = '-';
%             
%             if (snip_len == 0)
%                 ls = '-o';
%             elseif (snip_len == 1)
%                 ls = '-*';
%             elseif (snip_len == 2)
%                 ls = '-s';
%             elseif (snip_len == 4)
%                 ls = '-d';
%             end
%             
%             filteredGrp = grpstats(filteredLoop, {'snip_len', 'se', 'time_limit', 'ss', 'decision_maker', 'qs', 'u_t', 'u_n', 'u_r', 'u_d'});
%             
%             plot(filteredGrp.mean_depth_per_query, filteredGrp.mean_cg, ls, 'LineWidth', 4, 'MarkerSize', 13, 'DisplayName', sprintf('T%d', snip_len));
%         end
%         
%         the_legend = legend(gca, 'show');
%         set(the_legend, 'FontSize', 16);
%         xlim([0 25]);
%         ylim([0 3]);
%         xlabel('Mean Depth per Query');
%         ylabel('Cumulative Gain (CG)');
%     end
end

