function FreqBandsFig = plotDispersionNormalized(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec)
%PLOTDISPERSIONNORMALIZED Summary of this function goes here
%   Detailed explanation goes here

LightGrey = [0.7, 0.7, 0.7];

% use only real values of fBand
fBand = abs(fBand);

% creating handles
FreqBandsFig = figure;
FreqBandsAx = axes(FreqBandsFig);

% set dimensions
FreqBandsFig.Units = 'centimeters';
FreqBandsFig.Position = [20, 10, 7.5, 7];

FreqBandsAx.Position = [0.15 0.2 0.75 0.7];
FreqBandsAx.Box = 'on';

hold on

box on
set(gca, 'Layer', 'top')

xlabel(FreqBandsAx, '$\Re(\bmr{k})$')
ylabel(FreqBandsAx, '$f$ [\unit{Hz}]')

axis(FreqBandsAx, [0 max(kxy0) 0 1.0 * max(max(abs(fBand)))]);

Xptick = numel((0:deltaKx:pi)');
Mptick = Xptick + numel(deltaKy:deltaKy:pi);

Gptick = Mptick + numel(deltaKxy:deltaKxy:pi);
Yptick = Gptick + numel(deltaKy:deltaKy:pi);
Mptick2 = numel(kxy0);


if size(BasisVec, 1) == 1

    kxy0_norm = (1:Xptick)/Xptick;
    
    FreqBandsAx.XTick = [0, 1];

elseif BasisVec(1, 1) == BasisVec(2, 2)

    kxy0_norm = [
    (1:Xptick)/Xptick, ...
    (1:(Mptick-Xptick))/(Mptick-Xptick) + 1, ...
    (1:(Gptick - Mptick))/(Gptick - Mptick) + 2];

    xticks(FreqBandsAx, [0, 1, 2, 3]);
    xticklabels(FreqBandsAx, {'$\Gamma$', 'X', 'M', '$\Gamma$'});

else

    kxy0_norm = [
        (1:Xptick)/Xptick, ...
        (1:(Mptick-Xptick))/(Mptick-Xptick) + 1, ...
        (1:(Gptick - Mptick))/(Gptick - Mptick) + 2, ...
        (1:(Yptick - Gptick))/(Yptick - Gptick) + 3, ...
        (1:(Mptick2 - Yptick))/(Mptick2 - Yptick) + 4];

    xticks(FreqBandsAx, [0, 1, 2, 3, 4, 5])
    
end

% getting bandgaps
fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(FreqBandsAx, [0 3 3 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
    text(FreqBandsAx, .03, (fBandMin(indBand(bgi)) + fBandMax(indBand(bgi))) / 2, ...
        [num2str(bgi), '. Bandl{\"u}cke: ', num2str(fBandMax(indBand(bgi)), '%.0f'), ... 
        ' - ', num2str(fBandMin(indBand(bgi)), '%.0f'), ' Hz']);
end

axis(FreqBandsAx, [0 max(kxy0_norm) 0 1.0 * max(max(abs(fBand)))]);
plot(FreqBandsAx, kxy0_norm, fBand, 'k', LineWidth=1);

ChangeInterpreter(FreqBandsFig, 'none')
set(findall(FreqBandsFig,'type','axes'),'fontSize', 9)
plotOffset(FreqBandsAx, 2)

end

%% --------------------------------------------------------------------------
function plotOffset(axHandle, xOffset, yOffset)
%PLOTOFFSET Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    axHandle.XRuler.TickLabelGapOffset = xOffset;
    axHandle.YRuler.TickLabelGapOffset = xOffset;
else
    axHandle.XRuler.TickLabelGapOffset = xOffset;
    axHandle.YRuler.TickLabelGapOffset = yOffset;
end

end

