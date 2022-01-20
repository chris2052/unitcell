function plotBandgaps(bandgaps, label, color, xtick)
%BAND Summary of this function goes here
%   Detailed explanation goes here

for n = 2:2:size(bandgaps, 2)
    col = bandgaps(:, (n-1):n);
    if max(col) > 0 || ~isnan(max(col))
        pos = find(col(:,1));
        flipPos = flipud(pos);
        xVal = [pos; flipPos];
        bgVal = [col(pos,1); col(flipPos,2)];
        fill(xVal, bgVal, color)
        hold on
    end
end

hold off

grid 'on'

axis([0, inf, 0, inf]);

xlabel(label);
xticks(1:size(bandgaps,1))

if ~iscell(xtick)
    set(gca, 'XTickLabel', cellstr(get(gca, 'XTickLabel')))
end

xticklabels(xtick)
ylabel('Frequenz $f$ [Hz]')

end

