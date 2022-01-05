function plotDispersion(fBand, deltaKx, deltaKy, kxy0, BasisVec, ...
    FontSize, LineLineWidth)
    %PLOTDISPERSION Summary of this function goes here
    %   Detailed explanation goes here

Xptick = numel((0:deltaKx:pi)');
Mptick = Xptick + numel(deltaKy:deltaKy:pi);

LightGrey = [0.7, 0.7, 0.7];
% set(gcf, 'Position', [0, 0, 1920, 1080])

fBand = abs(fBand);

fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

% plotting with MATLAB
hold on
FreqBands = plot(kxy0, fBand, 'k', 'LineWidth', LineLineWidth);

for bgi = 1:size(indBand, 2)
    Bandgaps = fill([0 max(kxy0) max(kxy0) 0], [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) fBandMin(indBand(bgi))], LightGrey);
    text(10, (fBandMin(indBand(bgi)) + fBandMax(indBand(bgi))) / 2, [num2str(bgi), '. Bandl{\"u}cke: ', num2str(fBandMax(indBand(bgi)), '%.0f'), ' - ', num2str(fBandMin(indBand(bgi)), '%.0f'), ' Hz'], 'FontSize', FontSize, 'interpreter', 'latex');
end

box on
set(gca, 'Layer', 'top')
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', FontSize)
pbaspect([1 1 1]);
xlabel('Wellenvektor', 'interpreter', 'latex', 'FontSize', FontSize)
ylabel('$f$ [Hz]', 'interpreter', 'latex', 'FontSize', FontSize)
% figureHandle = gcf;
% set(findall(figureHandle, 'type', 'text'), 'fontSize', FontSize, 'fontWeight', 'normal', 'fontName', Font)
% set(findall(figureHandle, 'type', 'axes'), 'fontsize', FontSize, 'fontWeight', 'normal', 'fontName', Font)    

if size(BasisVec, 1) == 1
    axis([0 max(kxy0) 0 1.0 * max(max(abs(fBand)))]);
    ax = gca;
    ax.XTick = [0, max(kxy0)];
    xticklabels({'$\Gamma$', 'X'})
else
    axis([0 max(kxy0) 0 1.0 * max(max(abs(fBand)))]);
    xticks([0, Xptick, Mptick, max(kxy0)])
    xticklabels({'$\Gamma$', 'X', 'M', '$\Gamma$'})
    % set(gca,'ytick',[])
    % set(gca,'yticklabel',[])
end

hold off

end
