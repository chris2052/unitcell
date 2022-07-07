function plotDispersionCompl2(kxSC, OmegC, dOmegC, maxf, direction, realPart)
%PLOTDISPERSIONCOMPL Summary of this function goes here
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
 
DRed=[0.70 0.2 0.2];    % Dark Red
DBlue=[.2 .2 0.7];      % Dark Blue

ComplBandFig = figure;%('units','normalized','outerposition',[0 0 1 1]);

% set dimensions
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 7.5, 7];

%%
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.15 0.2 0.3 0.7];
ComplBandReAx.Box = 'on';

hold(ComplBandReAx, 'on')

xtickangle(ComplBandReAx, 0);


xlabel(ComplBandReAx, '$\Re(\bmr{k})$','interpreter', 'latex')
ylabel(ComplBandReAx, '$f$ [\unit{kHz}]','interpreter', 'latex')

grid(ComplBandReAx, 'on')

%%
%
ComplBandImAx = axes(ComplBandFig);
ComplBandImAx.Position = [0.45 0.2 0.45 0.7];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(ComplBandImAx, 0:0.5:3)
xticklabels(ComplBandImAx, {' ', ' ', 1, ' ', 2, ' ', 3})

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\bmr{k})$','interpreter', 'latex')

%%
%
switch direction

    case 'gx'
    
        switch realPart
            case 'pr'

            % CompFreqBandsPRe1
            plot(ComplBandReAx, PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, ...
                omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)), 'o', ...
                'MarkerSize',MarkerSize1, 'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
            
            case 'cr'

            % CompFreqBandsCRe1
            plot(ComplBandReAx, CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, ...
                omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
       
        end

        axis(ComplBandReAx, [0 1 0 maxf]);
        xticks(ComplBandReAx, 0:.25:1)
        xticklabels(ComplBandReAx, {'$\Gamma$', ' ', ' ', ' ', 'X'})

        

        % CompFreqBandsPIm1
        plot(ComplBandImAx, PImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

        % CompFreqBandsCIm1
        plot(ComplBandImAx, CImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

        % CompFreqBandsRIm1
%         plot(ComplBandImAx, RImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%             'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
        
        
        set(ComplBandImAx, 'yticklabel',[])

    case 'xm'

        switch realPart
            case 'pr'

            % CompFreqBandsPRe2
            plot(ComplBandReAx, PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, ...
                omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
          
            case 'cr'
            % CompFreqBandsCRe2
            plot(ComplBandReAx, CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, ...
                omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);
        
        end

        axis(ComplBandReAx, [1 2 0 maxf]);
        xticks(ComplBandReAx, 1:.25:2)
        xticklabels(ComplBandReAx, {'X', ' ', ' ', ' ', 'M'})

        
        % CompFreqBandsPIm2
        plot(ComplBandImAx, PImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

        % CompFreqBandsCIm2
        plot(ComplBandImAx, CImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

        % CompFreqBandsRIm2
%         plot(ComplBandImAx, RImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%             'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

        

        set(ComplBandImAx, 'yticklabel',[])

    case 'mg'

%         overwrite/swap the alignement of the two plots for this direction
%         ComplBandReAx.Position = [0.6 0.2 0.3 0.7];
%         ComplBandImAx.Position = [0.15 0.2 0.45 0.7];

        switch realPart
            case 'pr'   
            % CompFreqBandsPRe3
            plot(ComplBandReAx, -PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, ...
                omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
        
            case 'cr'
            % CompFreqBandsCRe3
            plot(ComplBandReAx, -CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, ...
                omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'o', ...
                'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

        end 

        axis(ComplBandReAx, [2 3 0 maxf]);
        xticks(ComplBandReAx, 2:.25:3)
        xticklabels(ComplBandReAx, {'M', ' ', ' ', ' ', '$\Gamma$'})

%         axis(ComplBandImAx, [-3 0 0 (OmegC+0.1)/(2*pi)]);
%         xticks(ComplBandImAx, -3:0.5:0)
%         xticklabels(ComplBandImAx, {-3,' ', -2, ' ', -1, ' ', ' '})
%         ylabel(ComplBandImAx, '$f$ [\unit{Hz}]','interpreter', 'latex')



        % CompFreqBandsPIm3
        plot(ComplBandImAx, PImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

        % CompFreqBandsCIm3
        plot(ComplBandImAx, CImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
            'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

        % CompFreqBandsRIm3
%         plot(ComplBandImAx, RImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%             'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
        
        
        set(ComplBandImAx, 'yticklabel',[]);
%         ylabel(ComplBandReAx, ' ');

end

hold(ComplBandReAx, 'off')

%%
%
hold(ComplBandImAx, 'off')

% set(findall(ComplBandFig,'type','text'),'fontSize',11)
set(findall(ComplBandFig,'type','axes'),'fontSize', 8)

plotOffset(ComplBandImAx, 4, 2)
plotOffset(ComplBandReAx, 4, 2)

ChangeInterpreter(ComplBandFig, 'none')

ComplBandReAx.YAxis.Exponent = 0;

end

