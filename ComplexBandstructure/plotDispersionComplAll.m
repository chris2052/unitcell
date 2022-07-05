function plotDispersionComplAll(kxSC, OmegC, dOmegC, maxf)
%PLOTDISPERSIONCOMPLALL Summary of this function goes here
%   Detailed explanation goes here

MarkerSize1 = 2;
AxesLineWidth = 1;
LineLineWidth = 1;    

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
 
DRed = [0.70 0.2 0.2];
DBlue = [0.2 0.2 0.7];

ComplBandFig = figure;%('units','normalized','outerposition',[0 0 1 1]);

% set dimensions
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [20, 10, 10, 10];

%% setup real dispersion
%
ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.1 0.1 0.35 0.8];
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
ComplBandImAx.Position = [0.55 0.1 0.35 0.8];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(ComplBandImAx, 0:0.5:3)
xticklabels(ComplBandImAx, {' ', ' ', 1, ' ', 2, ' ', 3})

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\bmr{k})$','interpreter', 'latex')

%%

plot(ComplBandReAx, PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandReAx, PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandReAx, -PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
% plot(ComplBandReAx, CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% plot(ComplBandReAx, -CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');

% axis(ComplBandReAx, [0 3 0 maxf]);

axis(ComplBandReAx, [0 3 0 maxf]);
xticks(ComplBandReAx, 0:.5:3)
xticklabels(ComplBandReAx, {'$\Gamma$', ' ', 'X', ' ', 'M', ' ', '\Gamma'})

% axis([0 3 0 (OmegC+0.1)/(2*pi)]);
% xticks([0:1:3])% create tick marks at 1/4 multiples of pi
% xticklabels({'\Gamma', 'X', 'M','\Gamma'})

% end
% box on

% set(gca,'Layer','top')
% pbaspect([1 1.2 1]);
% xlabel('$\Re(\bmr{k})$','interpreter', 'none')
% ylabel('$f$ [\unit{kHz}]','interpreter', 'none')
% yticks([0:2000:14000])
% yticklabels([0 2 4 6 8 10 12 14])
% grid on
% set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
% set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
% hold off
% nexttile(tilpltBG)
% set(gcf, 'Position',  [0, 0, 1920/2*0.9, 1080/2*0.9])
% hold on

plot(ComplBandImAx, PImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, PImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, PImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, CImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
plot(ComplBandImAx, CImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
plot(ComplBandImAx, CImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
plot(ComplBandImAx, RImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, RImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
plot(ComplBandImAx, RImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');

set(ComplBandImAx, 'yticklabel',[]);
ylabel(ComplBandImAx, ' ');

% axis([0 3 0 (OmegC+0.1)/(2*pi)]);

% hold off
hold(ComplBandReAx, 'off');

hold(ComplBandImAx, 'off');
% grid on

% set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
% set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])

% box on

% set(findall(ComplBandFig,'type','text'),'fontSize',11)
set(findall(ComplBandFig,'type','axes'),'fontSize', 9)

plotOffset(ComplBandImAx, 2)
plotOffset(ComplBandReAx, 2)

ChangeInterpreter(ComplBandFig, 'none')

end

