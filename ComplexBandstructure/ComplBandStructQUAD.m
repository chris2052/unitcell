clearvars;
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Tool to calculate the complex band structure of PnCs             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  -------------------------------- BEGIN -----------------------------------
%
%% geometry settings
%
% cell length, x [m]
l1 = 0.10;
% cell height, y [m]
l2 = 0.10;
% radius out and in [m]
rOut = 0.03;
rIn = 0;
%
% mesh settings
nameMesh = 'quads9';
lc = 1;
% maxMesh = 50e-3;
% factorMesh = 10;
maxMesh = 40e-3;
factorMesh = 1;

% order of element shape functions
order = 2;
% degree of freedom per node; (x, y)-direction
dof = 2;
% Element Type (number of nodes per element)
% elemType = 'q9';
% ratio lambdax/lambday
theta = 1;

% Minimum node distance to be considered, important for node indexing when line 
% boundary conditions are applied. Usually this value doesnt have to be changed.
minNodeDist = 0.0001;
% Set parallel computing (yes/no). Parallel computing is only effective for 
% large systems (statistics and machine learning Toolbox for improvement)
ParaComp = 6;

%% material properties
% Matrix material index for PnC=1!     !!v!!
% For multiple materials use vector: [E1 ; E2;...]. USE SEMICOLON ; !!!
%                                      !!^!!
% 1 silicon
% 2 steel
% 3 rubber
% 4 plexiglas
% 5 wolfram
% 6 concrete
%
% loading materials
load("material.mat");
% mat: outer material -> inner material
mat = [1,2];
matComsol = [
    2e9, 0.45, 1e3, 1;
    200e9, 0.34, 8e3, 1;
    ];
% (plane) "strain", "stress"
physics = "strain";

%  -------------------------------- END -------------------------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% getting mesh parameters
% creating mesh
createMeshUnitcell(nameMesh, l1, l2, rOut, rIn, lc, maxMesh, factorMesh, order);
% loading mesh
evalin('caller', [nameMesh, 'MESH']);
% quad4 or quad9 elements (depends on `order`)
switch order
    case 1
        quads = msh.QUADS;
        elemType = 'q4';
        
    case 2
        quads = msh.QUADS9;
        elemType = 'q9';
        
end
% number Elements
numEl = size(quads, 1);
% number Nodes per Element
nodPEle = size(quads, 2) - 1;
% material matrix E[N/m^2], v[-], rho[kg/m3], t[m]
matProp = material(mat,:);
matName = materialNames(mat);
matIdx = quads(:, end);

matProp = matComsol;

% global degree of freedom
numDoF = dof * msh.nbNod;
% xy-components, z is 0
InitialNodes = msh.POS;
nodesX = InitialNodes(:, 1);
nodesY = InitialNodes(:, 2);

connGlob = quads(:, 1:nodPEle);

quadsCorner = quads(:, 1:4);
nodesCornerX = nodesX(quadsCorner);
nodesCornerY = nodesY(quadsCorner);

%% drawing mesh
drawingMesh2D(nodesCornerX, nodesCornerY, 'none', '-', 'k');

%% generate element stiffnes matrix k
%
parfor n = 1:numEl
    % Connectivity vector per element
    connEle = quads(n, 1:nodPEle);
    % Node matrix per element
    nodesEle = msh.POS(connEle, :);
    % gettings material properties per element
    matEle = matProp(matIdx(n), :);
    % generating locale stiffness/mass matrix
    [elementK, elementM] = Element2D(nodesEle, order, matEle, elemType, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs = reshape(repmat(connEle, dof, 1) * dof ...
        - repmat((dof - 1:-1:0)', 1, nodPEle), [], 1)';
end

% global stiffness and mass matrizes
[Ksys, Msys] = FastMatrixAssembly(Elements);

%% calculating and plotting dispersion curves

% model=mphload('ExampleComplexBandStructure.mph'); %Load model from COMSOL
% str = mphmatrix(model, 'sol1', 'out', {'Kc','Ec','K','E'});
% info = mphxmeshinfo(model);
% Ksys=sparse(str.K);                           %full stiffness matrix
% Msys=sparse(str.E);                           %full mass matrix
% InitialNodes = [info.nodes.coords', zeros(size(info.nodes.coords',1),1)];
% % InitialNodes=info.dofs.coords';
% % InitialNodes=InitialNodes(1:2:end,:);
% % InitialNodes=[InitialNodes, zeros(size(InitialNodes,1),1)];
% numDoF=info.ndofs;
% load model_information.mat;


% reindex boundary (periodic boundary conditions, floquet-bloch)

PBC0 = [
    -l1/2, -l2/2, 0, -l1/2, l2/2, 0;
    l1/2, -l2/2, 0, l1/2, l2/2, 0;
    -l1/2, -l2/2, 0, l1/2, -l2/2, 0;
    -l1/2, l2/2, 0, l1/2, l2/2, 0];


[IdxPBCIn,IdxPBCOut,PBCTrans,BasisVec]=IndexPBC3D(InitialNodes,dof,PBC0,minNodeDist);  
i=sqrt(-1);

%% calculating and plotting dispersion curves

nBand = 8;
deltaKxy0 = 50;

[fBand, ABand, deltaKx, deltaKy, kxy0] = dispersionCalc(nBand, deltaKxy0, PBCTrans, BasisVec, ...
    IdxPBCIn, IdxPBCOut, Ksys, Msys);

plotDispersion(fBand, deltaKx, deltaKy, kxy0, BasisVec);

% dimensions for 3 figs (dispersion curves) in a row
% plotDimensions(gca, gcf, 5.3, 5, .67);

% dimensions for 2 figs in a row
% plotDimensions(gca, gcf, 7, 7, 5/7);
% plotOffset(gca, 3);

%% Calculation of complex band structure
%
% round to next 10th
maxf = ceil(real(max(max(fBand))/10))*10;
% omega intervall end value for calculation of complex band structure
OmegC = maxf*2*pi;
% omega intervall increment value
dOmegC = round(maxf/200) * 2*pi;

numredDoF=numDoF-size(unique(IdxPBCOut),1);
redDoF=1:numDoF;
redDoF(:,unique(IdxPBCOut))=[];
SIdxPBCIn=unique(sort(reshape(IdxPBCIn,[],1)));
SIdxPBCOut=unique(sort(reshape(IdxPBCOut,[],1)));
SlaveDofsPBC=1:numDoF;
SlaveDofsPBC([SIdxPBCIn,SIdxPBCOut])=[];
CompNodes=InitialNodes;
CompNodes(unique(ceil(SlaveDofsPBC/dof)),:)=[];
[IdxPBCCompIn,IdxPBCCompOut,PBCCompTrans,~]=IndexPBC3D(CompNodes,dof,PBC0,minNodeDist);
tic
updateWaitbarCompBands = waitbarParfor(ceil(OmegC/dOmegC)+1, ...
"Calculation of complex band structure in progress...");

% for idxComp=1:ceil(OmegC/dOmegC)
parfor (idxComp=1:ceil(OmegC/dOmegC)+1,ParaComp)
    omegComp=dOmegC*(idxComp-1)+0.1;
    KdynPBC=Ksys-omegComp^2*Msys;
    [KdynPBCred,~,~,~,~]=FastGuyanReduction(KdynPBC,KdynPBC,KdynPBC,SlaveDofsPBC);
    [K3GX, K4GX, K3XM, K4XM, K1MG, K2MG, K3MG, ~, ~, ~, ~] = ...
       CoefficientMatricesPBCrect(KdynPBCred, IdxPBCCompIn, IdxPBCCompOut,... 
       PBCCompTrans, theta);
    lambXiGX = quadeig(K3GX,K4GX,transpose(K3GX));
    kxSCGX0{idxComp}=i*log(lambXiGX);

    if size(BasisVec,1)>1
        lambXiXM = quadeig(K3XM,K4XM,transpose(K3XM));
        lambXiMG = polyeig(transpose(K1MG),transpose(K2MG),K3MG,K2MG,K1MG);
        kxSCXM0{idxComp}=i*log(lambXiXM);
        kxSCMG0{idxComp}=i*log(lambXiMG);
    end

    updateWaitbarCompBands(); 
end

CompBandStepTime=toc;
CompBandStepTime=CompBandStepTime/(ceil(OmegC/dOmegC)+1);
kxSCGX=cell2mat(kxSCGX0);

if size(BasisVec,1)>1
    kxSCXM=cell2mat(kxSCXM0);
    kxSCMG=cell2mat(kxSCMG0);
end

fprintf(['Calculation time for one frequency step is approximately ', ...
    num2str(CompBandStepTime), ' [s].', '\n'])

[kxSCGXRe, kxSCGXIm, kxSCGXCom] = filterCBS_2DFEM(kxSCGX);
[kxSCXMRe, kxSCXMIm, kxSCXMCom] = filterCBS_2DFEM(kxSCXM);
[kxSCMGRe, kxSCMGIm, kxSCMGCom] = filterCBS_2DFEM(kxSCMG);

PRekxSCGX = real(kxSCGXRe);
PRekxSCXM = real(kxSCXMRe);
PRekxSCMG = real(kxSCMGRe);

CRekxSCGX = real(kxSCGXCom);
CRekxSCXM = real(kxSCXMCom);
CRekxSCMG = real(kxSCMGCom);

RImkxSCGX = imag(kxSCGXRe);
RImkxSCXM = imag(kxSCXMRe);
RImkxSCMG = imag(kxSCMGRe);

PImkxSCGX = imag(kxSCGXIm);
PImkxSCXM = imag(kxSCXMIm);
PImkxSCMG = imag(kxSCMGIm);

CImkxSCGX = imag(kxSCGXCom);
CImkxSCXM = imag(kxSCXMCom);
CImkxSCMG = imag(kxSCMGCom);

omegSCGX = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSCGXRe,1),1);
omegSCXM = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSCXMRe,1),1);
omegSCMG = repmat((0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),size(kxSCMGRe,1),1);

%% plotting
%
% Font for all plots 
% Font="CMU Serif";
% Font size for all plots 
% FontSize=11;
% Set default axes line width
% AxesLineWidth=1;
% Set default line width of all lines within plots
% LineLineWidth=1;
% Set marker size for complex band structure
MarkerSize1 = 5;
 
% set(0, 'DefaultAxesLineWidth', AxesLineWidth);
% set(0, 'DefaultLineLineWidth', LineLineWidth);

DRed=[0.70 0.2 0.2];                   %Dark Red
DBlue=[.2 .2 0.7];                     %Dark Blue 

ComplBandFig = figure;
ComplBandFig.Units = 'centimeters';
ComplBandFig.Position = [10, 10, 15, 10];

ComplBandReAx = axes(ComplBandFig);
ComplBandReAx.Position = [0.1 0.1 0.5 0.8];
ComplBandReAx.Box = 'on';

% set(gcf, 'Position',  [0, 0, 1920/2*0.9, 1080/2*0.9])
% tilpltBG = tiledlayout(1,2,'TileSpacing','none');
% 
% nexttile(tilpltBG)
..........................

hold(ComplBandReAx, 'on')

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

axis(ComplBandReAx, [0 3 0 maxf]);
xticks(ComplBandReAx, 0:1:3)% create tick marks at 1/4 multiples of pi
xticklabels(ComplBandReAx, {'$\Gamma$', 'X', 'M','$\Gamma$'})
xtickangle(ComplBandReAx, 0);
% ComplBandReAx.TickLabelInterpreter = 'none';
% end

% set(ComplBandReAx,'Layer','top')
% pbaspect([1 1.2 1]);
xlabel(ComplBandReAx, '$\Re(\bf{k})$','interpreter', 'none')
ylabel(ComplBandReAx, '$f$ [\unit{Hz}]','interpreter', 'none')
% yticks(ComplBandReAx, 0:100:maxf)
% yticklabels([0 2 4 6 8 10 12 14])
grid(ComplBandReAx, 'on')
% figureHandle = gcf;
% set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
% set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
hold(ComplBandReAx, 'off')

% nexttile(tilpltBG)
% set(gcf, 'Position',  [0, 0, 1920/2*0.9, 1080/2*0.9])
ComplBandImAx = axes(ComplBandFig);
ComplBandImAx.Position = [0.65 0.1 0.3 0.8];
ComplBandImAx.Box = 'on';

hold(ComplBandImAx, 'on')

axis(ComplBandImAx, [0 3 0 (OmegC+0.1)/(2*pi)]);

% CompFreqBandsPIm1
plot(ComplBandImAx, PImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPIm2
plot(ComplBandImAx, PImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsPIm3
plot(ComplBandImAx, PImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);

% CompFreqBandsCIm1
plot(ComplBandImAx, CImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

% CompFreqBandsCIm2
plot(ComplBandImAx, CImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

% CompFreqBandsCIm3
plot(ComplBandImAx, CImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
    'MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue);

% %CompFreqBandsRIm1
% plot(ComplBandImAx, RImkxSCGX, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%     'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
% 
% % CompFreqBandsRIm2
% plot(ComplBandImAx, RImkxSCXM, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%     'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
% 
% % CompFreqBandsRIm3
% plot(ComplBandImAx, RImkxSCMG, (0.1:dOmegC:(ceil(OmegC/dOmegC))*dOmegC + 0.1)/(2*pi),'o', ...
%     'MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed);
    
hold(ComplBandImAx, 'off')

% pbaspect([1 1.2 1]);

grid(ComplBandImAx, 'on')

xlabel(ComplBandImAx, '$\Im(\bf{k})$','interpreter', 'none')
% figureHandle = gcf;

% set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
% set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
% set(ComplBandImAx, 'ytick',[])
set(ComplBandImAx, 'yticklabel',[])

% set(findall(ComplBandFig,'type','text'),'fontSize',11)
set(findall(ComplBandFig,'type','axes'),'fontSize',10)

ChangeInterpreter(ComplBandFig, 'none')

% box on

% set(gca,'Layer','top')

% tilplt.TileSpacing = 'none';
% tilplt.Padding = 'none';
