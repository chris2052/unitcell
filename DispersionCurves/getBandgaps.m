function [bandgaps, minImag] = getBandgaps(kxSC, kySC, OmegC, dOmegC, fBand)
%GETBANDGAPS get row vector of the bandgaps in fBand
%   bandgaps[1begin, 1end, 2begin, 2end, 3begin, 3end, ...]
%
%%
%
RImkxSCGX = imag(kxSC{1});
RImkxSCXM = imag(kxSC{4});
RImkxSCMG = imag(kxSC{7});
RImkySCGY = imag(kySC{1});
RImkySCYM = imag(kySC{4});

PImkxSCGX = imag(kxSC{2});
PImkxSCXM = imag(kxSC{5});
PImkxSCMG = imag(kxSC{8});
PImkySCGY = imag(kySC{2});
PImkySCYM = imag(kySC{5});

CImkxSCGX = imag(kxSC{3});
CImkxSCXM = imag(kxSC{6});
CImkxSCMG = imag(kxSC{9});
CImkySCGY = imag(kySC{3});
CImkySCYM = imag(kySC{6});

Z = [
    RImkxSCGX;
    RImkxSCXM;
    RImkxSCMG;
    RImkySCGY;
    RImkySCYM;
    PImkxSCGX;
    PImkxSCXM;
    PImkxSCMG;
    PImkySCGY;
    PImkySCYM;
    CImkxSCGX;
    CImkxSCXM;
    CImkxSCMG;
    CImkySCGY;
    CImkySCYM
    ];

%%
%
fBandMin = min(abs(fBand'));
fBandMax = max(abs(fBand'));
fBandMin = fBandMin(2:end);
fBandMax = fBandMax(1:end - 1);
fBandDelta = fBandMin - fBandMax;
indBand = find(fBandDelta > 10);

fBandDelta1 = fBandMin(indBand(1)) - fBandMax(indBand(1));
fBandDeltaM = fBandMin(indBand(1)) - fBandDelta1/2;

freq = (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi);

freqMid = find(freq > fBandDeltaM);
freqMid = freqMid(1);

mids = Z(:, freqMid);
ind = find(mids >= 0);
minImag = min(mids(ind));

%%
%
bandgaps = zeros(1, size(indBand, 2) * 2);

for bgi = 1:size(indBand, 2)
    bandMin = fBandMax(indBand(bgi));
    bandMax = fBandMin(indBand(bgi));
    bandgaps(bgi * 2 - 1) = bandMin;
    bandgaps(bgi * 2) = bandMax;
end

end