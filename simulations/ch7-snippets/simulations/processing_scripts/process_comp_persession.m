function [  ] = proces_comp_persession(input_path, output_path)
% Given the raw summaries from the Python script
% summary_generator_comparison.py, produces a summarised file for each
% query. This therefore provides mean click and hover depths. This is the
% file that is spit out, and therefore there's a single line per stopping
% strategy combination for each query.

% input_path = ../summaries/comparisons.csv
% output_path = ../summaries/comparisons_grped.csv

    d = dataset('file', input_path, 'delimiter', ',');
    
    grpOverTrials = {'userid',
                     'topic',
                     'queryid',
                     'snip_len',
                     'se',
                     'ss',
                     'decision_maker',
                     'u_n',
                     'u_d',
                     'u_r',
                     'u_t',
                     'u_g',
                     'u_p'};
    
    grpOverQueries= {'userid',
                     'topic', 
                     'snip_len',
                     'se',
                     'ss',
                     'decision_maker',
                     'u_n',
                     'u_d',
                     'u_r',
                     'u_t',
                     'u_g',
                     'u_p'};
         
    % Get the mean over the different trials.
    g = grpstats(d, grpOverTrials, {'mean'});
    
    % Now work out means and summated values for the different columns over
    % each query
    g = grpstats(g, grpOverQueries, {'mean', 'sum'});
    
    % Tidy up, remove extra columns that are not necessary and rename.
    g.mean_GroupCount = [];
    g.mean_queryid = [];
    g.sum_queryid = [];
    g.sum_GroupCount = [];
    g.mean_mean_ser = [];
    g.sum_mean_ser = [];
    g.mean_mean_ssr = [];
    g.sum_mean_ssr = [];
    g.mean_mean_decision_maker_run = [];
    g.sum_mean_decision_maker_run = [];
    
    export(g, 'file', output_path, 'delimiter', ',');
    
    g = dataset('file', output_path, 'delimiter', ',');
    g.Observations = [];
    g.Properties.VarNames{13} = 'no_queries_issued';
    export(g, 'file', output_path, 'delimiter', ',');
end

% function [idx] = get_str_position(findIn, findStr)
% % Super simple function to get the index position for a given string.
% % WHY DO I HAVE TO IMPLEMENT THIS I HATE MATLAB
%     idx = 0;
%     cellArray = strfind(findIn, findStr);
%     
%     for i=1:size(cellArray,2)
%         val = cellArray(i);
%         
%         if val{1} == 1
%             idx = i;
%         end   
%     end
% end