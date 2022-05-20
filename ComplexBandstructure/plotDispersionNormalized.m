function FreqBandsFig = plotDispersionNormalized(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec)
%PLOTDISPERSIONNORMALIZED Summary of this function goes here
%   Detailed explanation goes here

% use only real values of fBand
fBand = abs(fBand);

% creating handles
FreqBandsFig = figure;
FreqBandsAx = axes(FreqBandsFig);

hold on

box on
set(gca, 'Layer', 'top')

xlabel(FreqBandsAx, 'Wellenvektor $\mathbf{k}$')
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

    xticks(FreqBandsAx, [0, 1, 2, 3])

else

    kxy0_norm = [
        (1:Xptick)/Xptick, ...
        (1:(Mptick-Xptick))/(Mptick-Xptick) + 1, ...
        (1:(Gptick - Mptick))/(Gptick - Mptick) + 2, ...
        (1:(Yptick - Gptick))/(Yptick - Gptick) + 3, ...
        (1:(Mptick2 - Yptick))/(Mptick2 - Yptick) + 4];

    xticks(FreqBandsAx, [0, 1, 2, 3, 4, 5])
    
end

axis(FreqBandsAx, [0 max(kxy0_norm) 0 1.0 * max(max(abs(fBand)))]);
plot(FreqBandsAx, kxy0_norm, fBand, 'b', LineWidth=2);

ChangeInterpreter(FreqBandsFig, 'none')

end

