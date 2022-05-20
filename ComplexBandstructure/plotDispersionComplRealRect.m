function ComplBandFig = plotDispersionComplRealRect(kxSC, kySC, OmegC, dOmegC, CompFreqBandsC)
%PLOTDISPERSIONCOMPL Summary of this function goes here
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

omegSCGX = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{1},1),1);
omegSCXM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{4},1),1);
omegSCMG = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSC{7},1),1);
omegSCGY = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{1},1),1);
omegSCYM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{4},1),1);

%% plotting
%
MarkerSize1 = 2;
 
DRed=[0.70 0.2 0.2];    % Dark Red
DBlue=[.2 .2 0.7];      % Dark Blue

ComplBandFig = figure('units','normalized','outerposition',[0 0 1 1]);

% set dimensions for publication
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 12, 8];

%%
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.1 0.15 0.8 0.8];
ComplBandReAx.Box = 'on';

hold(ComplBandReAx, 'on')

xtickangle(ComplBandReAx, 0);


xlabel(ComplBandReAx, '$\Re(\mathbf{k})$','interpreter', 'none')
ylabel(ComplBandReAx, '$f$ [\unit{Hz}]','interpreter', 'none')

grid(ComplBandReAx, 'on')

%%
%
% CompFreqBandsPRe1
plot(ComplBandReAx, PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, ...
    omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)), 'o', ...
    'MarkerSize',MarkerSize1, 'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPRe2
plot(ComplBandReAx, PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, ...
    omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPRe3
plot(ComplBandReAx, -PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, ...
    omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPRe4
plot(ComplBandReAx, PRekySCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3))/pi+3, ...
    omegSCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3)),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPRe5
plot(ComplBandReAx, PRekySCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3))/pi+4, ...
    omegSCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3)),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

if CompFreqBandsC >= 1

    % CompFreqBandsCRe1
    plot(ComplBandReAx, CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, ...
        omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'o', ...
        'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

    % CompFreqBandsCRe2
    plot(ComplBandReAx, CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, ...
        omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'o', ...
        'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

    % CompFreqBandsCRe3
    plot(ComplBandReAx, -CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, ...
        omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'o', ...
        'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

    % CompFreqBandsCRe4
    plot(ComplBandReAx, CRekySCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3))/pi+3, ...
        omegSCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3)),'o', ...
        'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

    % CompFreqBandsCRe5
    plot(ComplBandReAx, CRekySCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3))/pi+4, ...
        omegSCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3)),'o', ...
        'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);


end 

axis([0 5 0 (OmegC+0.1)/(2*pi)]);
xticks(0:1:5);
xticklabels({'$\Gamma$', 'X', 'M','$\Gamma$', 'Y', 'M'});

hold(ComplBandReAx, 'off')

%%
%

% set(findall(ComplBandFig,'type','text'),'fontSize',11)
set(findall(ComplBandFig,'type','axes'),'fontSize', 9)

plotOffset(ComplBandReAx, 2)

ChangeInterpreter(ComplBandFig, 'none')

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


