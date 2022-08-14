function ComplBandFig = plotDispersionComplAllRect(kxSC, kySC, OmegC, dOmegC, maxf, fBand)
%PLOTDISPERSIONCOMPLALL Summary of this function goes here
%   Detailed explanation goes here

PRekxSCGX = real(kxSC{1});
PRekxSCXM = real(kxSC{4});
PRekxSCMG = real(kxSC{7});
PRekySCGY = real(kySC{1});
PRekySCYM = real(kySC{4});

CRekxSCGX = real(kxSC{3});
CRekxSCXM = real(kxSC{6});
CRekxSCMG = real(kxSC{9});
CRekySCGY = real(kySC{3});
CRekySCYM = real(kySC{6});

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

omegSCGX = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{1},1),1);
omegSCXM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{4},1),1);
omegSCMG = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{7},1),1);
omegSCGY = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{1},1),1);
omegSCYM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{4},1),1);

%% plotting
%
MarkerSize1 = 2;

AxesLineWidth = 1;
LineLineWidth = 1;    
 
DRed = [0.70 0.2 0.2];
DBlue = [0.2 0.2 0.7];
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

ComplBandFig = figure;%('units','normalized','outerposition',[0 0 1 1]);

% set dimensions
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 15, 7];

%% setup real dispersion
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.12 0.18 0.38 0.8];
ComplBandReAx.Box = 'on';

hold(ComplBandReAx, 'on')

xtickangle(ComplBandReAx, 0);
xticks(ComplBandReAx, 0:.25:3);
% xticklabels(ComplBandReAx, {'\Gamma', ' ', 'X', ' ', 'M'})


xlabel(ComplBandReAx, '$\Re(\mathbf{k})$')
ylabel(ComplBandReAx, '$f$ [Hz]')

grid(ComplBandReAx, 'on')

%% setup complex (imag) disperion
%
ComplBandImAx = axes(ComplBandFig);
ComplBandImAx.Position = [0.55 0.18 0.38 0.8];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(ComplBandImAx, 0:1:3)
xticklabels(ComplBandImAx, {0, 1, 2, 3})

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\mathbf{k})$')

%%

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(ComplBandReAx, [0 5 5 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
    text(ComplBandReAx, .03, (fBandMin(indBand(bgi)) + fBandMax(indBand(bgi))) / 2, ...
        [num2str(bgi), '. Bandl{\"u}cke: ', num2str(fBandMax(indBand(bgi)), '%.0f'), ... 
        ' - ', num2str(fBandMin(indBand(bgi)), '%.0f'), ' Hz']);
end

plot(ComplBandReAx, PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)), 'o', 'MarkerSize',MarkerSize1, 'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandReAx, PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandReAx, -PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandReAx, PRekySCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3))/pi+3, omegSCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandReAx, PRekySCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3))/pi+4, omegSCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% plot(ComplBandReAx, CRekySCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3))/pi+3, omegSCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
% plot(ComplBandReAx, CRekySCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3))/pi+4, omegSCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3)),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
% plot(ComplBandReAx, CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, -CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');

axis(ComplBandReAx, [0 5 0 maxf]);
xticks(ComplBandReAx, 0:1:5)
xticklabels(ComplBandReAx, {'$\Gamma$', 'X', 'M','$\Gamma$', 'Y', 'M'})

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(ComplBandImAx, [0 3 3 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
end

plot(ComplBandImAx, PImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, PImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, PImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, PImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, PImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

plot(ComplBandImAx, CImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
plot(ComplBandImAx, CImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
plot(ComplBandImAx, CImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
plot(ComplBandImAx, CImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
plot(ComplBandImAx, CImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

plot(ComplBandImAx, RImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, RImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, RImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, RImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
plot(ComplBandImAx, RImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', 'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

set(ComplBandImAx, 'yticklabel',[]);
ylabel(ComplBandImAx, ' ');

hold(ComplBandReAx, 'off');

hold(ComplBandImAx, 'off');

set(findall(ComplBandFig,'type','axes'),'fontSize', 11)

plotOffset(ComplBandImAx, 2)
plotOffset(ComplBandReAx, 2)

ChangeInterpreter(ComplBandFig, 'latex')

end

