function plotDispersionComplY(kySC, OmegC, dOmegC, maxf, direction, ...
    realPart, imagPart)
%PLOTDISPERSIONCOMPL Summary of this function goes here
%   Detailed explanation goes here

PRekySCGY = real(kySC{1});
PRekySCYM = real(kySC{4});

CRekySCGY = real(kySC{3});
CRekySCYM = real(kySC{6});

RImkySCGY = imag(kySC{1});
RImkySCYM = imag(kySC{4});

PImkySCGY = imag(kySC{2});
PImkySCYM = imag(kySC{5});

CImkySCGY = imag(kySC{3});
CImkySCYM = imag(kySC{6});

omegSCGY = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{4},1),1);
omegSCYM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kySC{1},1),1);

%% plotting
%
MarkerSize1 = 2;
 
DRed=[0.70 0.2 0.2];    % Dark Red
DBlue=[.2 .2 0.7];      % Dark Blue

ComplBandFig = figure;%('units','normalized','outerposition',[0 0 1 1]);

% set dimensions
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 9, 8];

%%
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.15 0.2 0.3 0.7];
ComplBandReAx.Box = 'on';

hold(ComplBandReAx, 'on')

xtickangle(ComplBandReAx, 0);


xlabel(ComplBandReAx, '$\Re(\mathbf{k})$','interpreter', 'none')
ylabel(ComplBandReAx, '$f$ [\unit{Hz}]','interpreter', 'none')

grid(ComplBandReAx, 'on')

%%
%
ComplBandImAx = axes(ComplBandFig);
ComplBandImAx.Position = [0.45 0.2 0.45 0.7];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(ComplBandImAx, 0:0.5:3)
xticklabels(ComplBandImAx, {' ',' ', 1, ' ', 2, ' ', 3})

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\mathbf{k})$','interpreter', 'none')

set(ComplBandImAx, 'yticklabel',[])

%%
%
switch direction

    case 'gy'

        switch realPart
            case 'pr'

            % CompFreqBandsPRe2
            plot(ComplBandReAx, PRekySCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3))/pi+1, ...
                omegSCGY(round(PRekySCGY,3)>0&round(PRekySCGY,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
          
            case 'cr'
            % CompFreqBandsCRe2
            plot(ComplBandReAx, CRekySCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3))/pi+1, ...
                omegSCGY(round(CRekySCGY,3)>0&round(CRekySCGY,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
        
        end

        axis(ComplBandReAx, [1 2 0 maxf]);
        xticks(ComplBandReAx, 1:.25:2)
        xticklabels(ComplBandReAx, {'$\Gamma$',' ', ' ',' ', 'Y'})

        switch imagPart
            case 'pi'

            % CompFreqBandsPIm2
            plot(ComplBandImAx, PImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

            case 'ci'
            % CompFreqBandsCIm2
            plot(ComplBandImAx, CImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

            case 'ri'
            % CompFreqBandsRIm2
            plot(ComplBandImAx, RImkySCGY, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

        end    
    
    case 'ym'
    
        switch realPart
            case 'pr'

            % CompFreqBandsPRe1
            plot(ComplBandReAx, PRekySCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3))/pi, ...
                omegSCYM(round(PRekySCYM,3)>0&round(PRekySCYM,3)~=round(pi,3)), 'o', ...
                'MarkerSize',MarkerSize1, 'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
            
            case 'cr'

            % CompFreqBandsCRe1
            plot(ComplBandReAx, CRekySCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3))/pi, ...
                omegSCYM(round(CRekySCYM,3)>0&round(CRekySCYM,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
       
        end

        axis(ComplBandReAx, [0 1 0 maxf]);
        xticks(ComplBandReAx, 0:.25:1)
        xticklabels(ComplBandReAx, {'Y',' ', ' ',' ', 'M'})

        switch imagPart
            case 'pi'

            % CompFreqBandsPIm1
            plot(ComplBandImAx, PImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

            case 'ci'
            % CompFreqBandsCIm1
            plot(ComplBandImAx, CImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

            case 'ri'
            % CompFreqBandsRIm1
            plot(ComplBandImAx, RImkySCYM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
        
        end

end

hold(ComplBandReAx, 'off')

%%
%
hold(ComplBandImAx, 'off')

% set(findall(ComplBandFig,'type','text'),'fontSize',11)
set(findall(ComplBandFig,'type','axes'),'fontSize', 9)

plotOffset(ComplBandImAx, 2)
plotOffset(ComplBandReAx, 2)

ChangeInterpreter(ComplBandFig, 'none')

end

