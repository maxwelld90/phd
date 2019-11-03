function [  ] = proces_comp(input_path, output_path)
% Given the raw summaries from the Python script
% summary_generator_comparison.py, produces a summarised file for each
% query. This therefore provides mean click and hover depths. This is the
% file that is spit out, and therefore there's a single line per stopping
% strategy combination for each query.

% input_path = ../summaries/comparisons.csv
% output_path = ../summaries/comparisons_grped.csv

    d = dataset('file', input_path, 'delimiter', ',');
    
    grpBy = {'userid',
             'queryid',
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

    g = grpstats(d, grpBy, {'mean'});
    g.GroupCount = [];
    g.mean_ser = [];
    g.mean_ssr = [];
    g.mean_decision_maker_run = [];
    export(g, 'file', output_path, 'delimiter', ',');
    
    g2 = dataset('file', output_path, 'delimiter', ',');
    g2.Observations = [];
    export(g2, 'file', output_path, 'delimiter', ',');
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