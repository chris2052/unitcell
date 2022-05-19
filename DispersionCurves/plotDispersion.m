function plotDispersion(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec)
    %PLOTDISPERSION plotting the dispersion-diagrams for given frequencies 
    %   fBand:      matrix of frequencies 

Xptick = numel((0:deltaKx:pi)');
Mptick = Xptick + numel(deltaKy:deltaKy:pi);

LightGrey = [0.7, 0.7, 0.7];

% use only real values of fBand
fBand = abs(fBand);

% getting bandgaps
fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

% creating handles
FreqBandsFig = figure;
FreqBandsAx = axes(FreqBandsFig);

% plotting frequency bands
plot(FreqBandsAx, kxy0, fBand, 'k');
% FreqBands = plot(FreqBandsAx, kxy0, fBand, 'k');

hold on

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(FreqBandsAx, [0 max(kxy0) max(kxy0) 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
    text(FreqBandsAx, 10, (fBandMin(indBand(bgi)) + fBandMax(indBand(bgi))) / 2, ...
        [num2str(bgi), '. Bandl{\"u}cke: ', num2str(fBandMax(indBand(bgi)), '%.0f'), ... 
        ' - ', num2str(fBandMin(indBand(bgi)), '%.0f'), ' Hz']);
end

box on
set(gca, 'Layer', 'top')
% pbaspect([1 1 1]);

xlabel(FreqBandsAx, 'Wellenvektor $\mathbf{k}$')
ylabel(FreqBandsAx, '$f$ [\unit{Hz}]')

axis(FreqBandsAx, [0 max(kxy0) 0 1.0 * max(max(abs(fBand)))]);

if size(BasisVec, 1) == 1
    
    FreqBandsAx.XTick = [0, max(kxy0)];
    xticklabels(FreqBandsAx, {'$\Gamma$', 'X'})

elseif BasisVec(1, 1) == BasisVec(2, 2)

    xticks(FreqBandsAx, [0, Xptick, Mptick, max(kxy0)])
    xticklabels(FreqBandsAx, {'$\Gamma$', 'X', 'M', '$\Gamma$'})

else
    Xptick = numel((0:deltaKx:pi)');
    Mptick = Xptick + numel(deltaKy:deltaKy:pi);
%     lMGamma = sqrt(deltaKy^2 + deltaKx^2);

    Gammaptick = Mptick + numel(deltaKxy:deltaKxy:pi);

    Yptick = Gammaptick + numel(deltaKy:deltaKy:pi);
    xticks(FreqBandsAx, [0, Xptick, Mptick, Gammaptick, Yptick, max(kxy0)])
    xticklabels(FreqBandsAx, {'$\Gamma$', 'X', 'M', '$\Gamma$', 'Y', 'M'})

end

hold off

ChangeInterpreter(FreqBandsFig, 'none')

end
