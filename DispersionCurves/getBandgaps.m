function bandgaps = getBandgaps(fBand)
%GETBANDGAPS get row vector of the bandgaps in fBand
%   bandgaps[1begin, 1end, 2begin, 2end, 3begin, 3end, ...]

fBand = abs(fBand);
fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

bandgaps = zeros(1, size(indBand, 2) * 2);

for bgi = 1:size(indBand, 2)
    bandMin = fBandMax(indBand(bgi));
    bandMax = fBandMin(indBand(bgi));
    bandgaps(bgi * 2 - 1) = bandMin;
    bandgaps(bgi * 2) = bandMax;
end

end