function bandgaps = getBandgaps(fBand)
%GETBANDGAPS Summary of this function goes here
%   Detailed explanation goes here
fBand = abs(fBand);
fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

bandgaps = zeros(1, size(indBand, 2) * 2);
% bandgaps = zeros(1, 50);

for bgi = 1:size(indBand, 2)
    bandMin = fBandMax(indBand(bgi));
    bandMax = fBandMin(indBand(bgi));
    bandgaps(bgi * 2 - 1) = bandMin;
    bandgaps(bgi * 2) = bandMax;
end

end