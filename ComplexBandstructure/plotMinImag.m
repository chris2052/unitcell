function plotMinImag(minImag, label, xtick)
%BAND Summary of this function goes here
%   Detailed explanation goes here

minImagFig = figure;
minImagAx = axes(minImagFig);
% LightGrey = [0.7, 0.7, 0.7];

plot(minImagAx, minImag);

grid(minImagAx, 'on')

axis(minImagAx, [0, inf, 0, inf])
xlabel(minImagAx, label);
xticks(minImagAx, 1:size(minImag,1));

if ~iscell(xtick)
    set(minImagAx, 'XTickLabel', cellstr(get(gca, 'XTickLabel')))
end

xticklabels(minImagAx, compose('%.2f', xtick));
ylabel(minImagAx, '$\Im(\mathbf{k}(f_{BL,Mf}))$ [1/m]');

set(findall(minImagFig,'type','axes'),'fontSize', 11)

ChangeInterpreter(minImagAx, 'latex')

end