function plotMinImag(minImag, label, xtick)
%BAND Summary of this function goes here
%   Detailed explanation goes here

fig = figure;
ax = axes(fig);
% LightGrey = [0.7, 0.7, 0.7];

plot(ax, minImag);

grid(ax, 'on')

axis(ax, [0, inf, 0, inf])
xlabel(ax, label);
xticks(ax, 1:size(minImag,1));

if ~iscell(xtick)
    set(ax, 'XTickLabel', cellstr(get(gca, 'XTickLabel')))
end

xticklabels(ax, compose('%.2f', xtick));
ylabel(ax, '$\Im(\bmr{k}(f_{BL,Mf}))$ [\unit{1/m}]');

ChangeInterpreter(fig, 'none')

end