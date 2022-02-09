function plotBandgaps(bandgaps, label, color, xtick)
%BAND Summary of this function goes here
%   Detailed explanation goes here

fig = figure;
ax = axes(fig);

for n = 2:2:size(bandgaps, 2)
    col = bandgaps(:, (n-1):n);
    if max(col) > 0 %|| ~isnan(max(col))
        pos = find(col(:,1));
        flipPos = flipud(pos);
        xVal = [pos; flipPos];
        bgVal = [col(pos,1); col(flipPos,2)];
        fill(ax, xVal, bgVal, color);
        hold(ax, 'on')
    end
end

hold(ax, 'off')

grid(ax, 'on')

axis(ax, [0, inf, 0, inf])
xlabel(ax, label);
xticks(ax, 1:size(bandgaps,1));

if ~iscell(xtick)
    set(ax, 'XTickLabel', cellstr(get(gca, 'XTickLabel')))
end

xticklabels(ax, compose('%.1f', xtick));
ylabel(ax, 'Frequenz $f$ [\unit{Hz}]');

ChangeInterpreter(fig, 'none')

end

