function plotOverlapFigures(master, sub)
%OVERLAPFIGURES combine two figures with same axes into one single
%   master: number of master figure (copy sub into master)
%   sub:    number of sub-figure
%   ** get number from title-bar (1, 2, 3, ...) ** 

    first_fig = figure(master);
    second_fig = figure(sub);
    first_ax = findobj(first_fig, 'type', 'axes');
    second_ax = findobj(second_fig, 'type', 'axes');

    if length(first_ax) ~= 1 || length(second_ax) ~= 1
        error('this code requires the two figures to have exactly one axes each');
    end
    %direct children only and don't try to find the hidden ones
    ch2 = get(second_ax, 'children');
    %beam them over
    copyobj(ch2, first_ax);

end