function plotBandgaps(bandgaps, label, xtick)
%BAND Summary of this function goes here
%   Detailed explanation goes here

complBandFig = figure;
complBandAx = axes(complBandFig);
LightGrey = [0.7, 0.7, 0.7];

for n = 2:2:size(bandgaps, 2)
    col = bandgaps(:, (n-1):n);
    if max(col) > 0 %|| ~isnan(max(col))
        pos = find(col(:,1));
        flipPos = flipud(pos);
        xVal = [pos; flipPos];
        bgVal = [col(pos,1); col(flipPos,2)];
        fill(complBandAx, xVal, bgVal, LightGrey);
        hold(complBandAx, 'on')
    end
end

hold(complBandAx, 'off')

grid(complBandAx, 'on')

axis(complBandAx, [0, inf, 0, inf])
xlabel(complBandAx, label);
xticks(complBandAx, 1:size(bandgaps,1));

if ~iscell(xtick)
    set(complBandAx, 'XTickLabel', cellstr(get(gca, 'XTickLabel')))
end

xticklabels(complBandAx, compose('%.2f', xtick));
ylabel(complBandAx, 'Frequenz $f$ [Hz]');

set(findall(complBandAx,'type','axes'),'fontSize', 11)

ChangeInterpreter(complBandFig, 'latex')

end

