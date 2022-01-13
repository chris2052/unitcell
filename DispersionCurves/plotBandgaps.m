function plotBandgaps(bandgaps, label)
%BAND Summary of this function goes here
%   Detailed explanation goes here

fig = figure;
ax = axes;

width = 0.6;
allSum = zeros(size(bandgaps, 2), 1);

for n = 1:size(bandgaps, 1)
    sumRow = 0;
    row = bandgaps(n, :);
    for m = 2:2:size(row, 2)
        rectangle('Position', [n - width/2, row(m-1), width, row(m) - row(m-1)],...
            'FaceColor', 'k');
        hold on
        sumRow = sumRow + row(m) - row(m-1);
    end
    allSum(n) = sumRow;
end

hold off

grid(ax, 'on');
grid(ax, 'minor');

fig.Units = 'centimeters';
ax.Position = [.1, .1, .8, .8];

axis(ax, [10, 50, 5000, inf]);

xlabel(ax, label);
ylabel(ax, 'Frequenz $f$ [Hz]')

[val, pos] = max(allSum);

disp(pos)
disp(val)

end

