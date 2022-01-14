function plotBandgaps(bandgaps, label, position, color)
%BAND Summary of this function goes here
%   Detailed explanation goes here

fig = figure;
ax = axes;

width = 0.6;

switch position
    case 'full'
        x1 = -width/2;
        x2 = width;

    case 'left'
        x1 = -width/2;
        x2 = width/2;

    case 'right'
        x1 = 0;
        x2 = width/2;
end

allSum = zeros(size(bandgaps, 2), 1);

for n = 1:size(bandgaps, 1)
    sumRow = 0;
    row = bandgaps(n, :);
    for m = 2:2:size(row, 2)
        if row(m) > 0
        rectangle('Position', [n + x1, row(m-1), x2, row(m) - row(m-1)],...
            'FaceColor', color, 'EdgeColor', color);
        hold on
        end
        sumRow = sumRow + row(m) - row(m-1);
    end
    allSum(n) = sumRow;
end

hold off

grid(ax, 'on');
grid(ax, 'minor');

fig.Units = 'centimeters';
plotDimX = 9;
plotDimY = 7;

fig.Position = [35, 8, plotDimX, plotDimY];
ax.Position = [.15, .15, .7, .7];

% axis(ax, [10, 50, 5000, inf]);

xlabel(ax, label);
ylabel(ax, 'Frequenz $f$ [Hz]')

[val, pos] = max(allSum);

disp(pos)
disp(val)

end

