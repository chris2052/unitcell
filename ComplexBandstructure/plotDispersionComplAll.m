function ComplBandFig = plotDispersionComplAll(kxSC, OmegC, dOmegC, maxf, fBand)
%PLOTDISPERSIONCOMPLALL Summary of this function goes here
%   Detailed explanation goes here

PRekxSCGX = real(kxSC{1});
PRekxSCXM = real(kxSC{4});
PRekxSCMG = real(kxSC{7});

CRekxSCGX = real(kxSC{3});
CRekxSCXM = real(kxSC{6});
CRekxSCMG = real(kxSC{9});

RImkxSCGX = imag(kxSC{1});
RImkxSCXM = imag(kxSC{4});
RImkxSCMG = imag(kxSC{7});

PImkxSCGX = imag(kxSC{2});
PImkxSCXM = imag(kxSC{5});
PImkxSCMG = imag(kxSC{8});

CImkxSCGX = imag(kxSC{3});
CImkxSCXM = imag(kxSC{6});
CImkxSCMG = imag(kxSC{9});

omegSCGX = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{1},1),1);
omegSCXM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{4},1),1);
omegSCMG = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{7},1),1);

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

freq = (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi);

ComplBandFig = figure;%('units','normalized','outerposition',[0 0 1 1]);

% set dimensions
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 14, 7];

%% setup real dispersion
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.1 0.15 0.38 0.8];
ComplBandReAx.Box = 'on';

hold(ComplBandReAx, 'on')

xtickangle(ComplBandReAx, 0);
xticks(ComplBandReAx, 0:.25:3);
% xticklabels(ComplBandReAx, {'\Gamma', ' ', 'X', ' ', 'M'})


xlabel(ComplBandReAx, '$\Re(\bmr{k})$','interpreter', 'latex')
ylabel(ComplBandReAx, '$f$ [\unit{Hz}]','interpreter', 'latex')

grid(ComplBandReAx, 'on')

%% setup complex (imag) disperion
%
ComplBandImAx = axes(ComplBandFig);
ComplBandImAx.Position = [0.52 0.15 0.38 0.8];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(ComplBandImAx, 0:0.5:3)
xticklabels(ComplBandImAx, {0, ' ', 1, ' ', 2, ' ', 3})

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\bmr{k})$','interpreter', 'latex')

%%

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(ComplBandReAx, [0 3 3 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
    text(ComplBandReAx, .03, (fBandMin(indBand(bgi)) + fBandMax(indBand(bgi))) / 2, ...
        [num2str(bgi), '. Bandl{\"u}cke: ', num2str(fBandMax(indBand(bgi)), '%.0f'), ... 
        ' - ', num2str(fBandMin(indBand(bgi)), '%.0f'), ' Hz']);
end

plot(ComplBandReAx, PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandReAx, PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandReAx, -PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
% plot(ComplBandReAx, CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, -CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');

axis(ComplBandReAx, [0 3 0 maxf]);
xticks(ComplBandReAx, 0:.5:3)
xticklabels(ComplBandReAx, {'$\Gamma$', ' ', 'X', ' ', 'M', ' ', '\Gamma'})

% plotting box with text (freq range) for bandgaps 
for bgi = 1:size(indBand, 2)
    fill(ComplBandImAx, [0 3 3 0], ...
        [fBandMax(indBand(bgi)) fBandMax(indBand(bgi)) fBandMin(indBand(bgi)) ...
        fBandMin(indBand(bgi))], LightGrey);
end

plot(ComplBandImAx, PImkxSCGX, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, PImkxSCXM, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, PImkxSCMG, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, CImkxSCGX, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
plot(ComplBandImAx, CImkxSCXM, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
plot(ComplBandImAx, CImkxSCMG, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandImAx, RImkxSCGX, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
% plot(ComplBandImAx, RImkxSCXM, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
% plot(ComplBandImAx, RImkxSCMG, freq,'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');

set(ComplBandImAx, 'yticklabel',[]);
ylabel(ComplBandImAx, ' ');

hold(ComplBandReAx, 'off');

hold(ComplBandImAx, 'off');

set(findall(ComplBandFig,'type','axes'),'fontSize', 9)

plotOffset(ComplBandImAx, 2)
plotOffset(ComplBandReAx, 2)

ChangeInterpreter(ComplBandFig, 'none')

end

