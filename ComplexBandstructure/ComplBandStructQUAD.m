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
l1 = 0.15;
% cell height, y [m]
l2 = 0.10;
% radius out and in [m]
rOut = 0.03;
rIn = 0;
%
% mesh settings
nameMesh = 'quads';
lc = 1;
% maxMesh = 50e-3;
% factorMesh = 10;
maxMesh = 40e-3;
factorMesh = 1;

% order for gauss quadrature
order = 2;
% degree of freedom per node; (x, y)-direction
dof = 2;
% Element Type (number of nodes per element)
% elemType = 'q9';
% ratio lambdax/lambday
theta = 1;

% Minimum node distance to be considered, important for node indexing when line 
% boundary conditions are applied. Usually this value doesnt have to be changed.
minNodeDist=0.0001;
% omega intervall end value for calculation of complex band structure
OmegC=14000*2*pi;
% omega intervall increment value
dOmegC=100*2*pi;
% Set parallel computing (yes/no). Parallel computing is only effective for 
% large systems (statistics and machine learning Toolbox for improvement)
ParaComp=12;

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
mat = [3, 5];

% (plane) "strain", "stress"
physics = "strain";

%  -------------------------------- END -------------------------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% getting mesh parameters
% creating mesh
createMeshUnitcell(nameMesh, l1, l2, rOut, rIn, lc, maxMesh, factorMesh, order);
% loading mesh
evalin('caller', [nameMesh, 'MESH']);
% quad4 or quad9 elements
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
% global degree of freedom
gDof = dof * msh.nbNod;
% xy-components, z is 0
nodesGlob = msh.POS;
nodesX = nodesGlob(:, 1);
nodesY = nodesGlob(:, 2);

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


%% Calculation of complex valued band structure k(omega)
%
PBC0 = [
    -l1/2, -l2/2, 0, -l1/2, l2/2, 0;
    l1/2, -l2/2, 0, l1/2, l2/2, 0;
    -l1/2, -l2/2, 0, l1/2, -l2/2, 0;
    -l1/2, l2/2, 0, l1/2, l2/2, 0];

InitialNodes = nodesGlob;
numDoF = gDof;

[IdxPBCIn,IdxPBCOut,PBCTrans,BasisVec]=IndexPBC3D(InitialNodes,dof,PBC0,minNodeDist);  
i=sqrt(-1);
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

% for idxComp=1:ceil(OmegC/dOmegC)+1
parfor (idxComp=1:ceil(OmegC/dOmegC)+1,ParaComp)
    omegComp=dOmegC*(idxComp-1)+0.1;
    KdynPBC=Ksys-omegComp^2*Msys;
    [KdynPBCred,~,~,~,~]=FastGuyanReduction(KdynPBC,KdynPBC,KdynPBC,SlaveDofsPBC);
    % [K3GX, K4GX, K3XM, K4XM, K1MG, K2MG, K3MG, ~, ~, ~, ~] = CoefficientMatricesPBCrecUC_marius(KdynPBCred,IdxPBCCompIn,IdxPBCCompOut,PBCCompTrans,theta);
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
omegSCGX = repmat((0.1:dOmegC:OmegC+0.1)/(2*pi),size(kxSCGXRe,1),1);
omegSCXM = repmat((0.1:dOmegC:OmegC+0.1)/(2*pi),size(kxSCXMRe,1),1);
omegSCMG = repmat((0.1:dOmegC:OmegC+0.1)/(2*pi),size(kxSCMGRe,1),1);

%% plotting
%
% Font for all plots 
Font="CMU Serif";
% Font size for all plots 
FontSize=26;
% Set default axes line width
AxesLineWidth=1;
% Set default line width of all lines within plots
LineLineWidth=1;
% Set marker size for complex band structure
MarkerSize1=2;
 
set(0, 'DefaultAxesLineWidth', AxesLineWidth);
set(0, 'DefaultLineLineWidth', LineLineWidth);

DRed=[0.70 0.2 0.2];                   %Dark Red
DBlue=[.2 .2 0.7];                     %Dark Blue 

figure

set(gcf, 'Position',  [0, 0, 1920/2*0.9, 1080/2*0.9])
tilpltBG = tiledlayout(1,2,'TileSpacing','none');

nexttile(tilpltBG)

hold on

CompFreqBandsPRe1=plot(PRekxSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(PRekxSCGX,3)>0&round(PRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsPRe2=plot(PRekxSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(PRekxSCXM,3)>0&round(PRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsPRe3=plot(-PRekxSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(PRekxSCMG,3)>0&round(PRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
% CompFreqBandsCRe1=plot(CRekxSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3))/pi, omegSCGX(round(CRekxSCGX,3)>0&round(CRekxSCGX,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% CompFreqBandsCRe2=plot(CRekxSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3))/pi+1, omegSCXM(round(CRekxSCXM,3)>0&round(CRekxSCXM,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
% CompFreqBandsCRe3=plot(-CRekxSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3))/pi+3, omegSCMG(round(CRekxSCMG,3)>0&round(CRekxSCMG,3)~=round(pi,3)),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');

axis([0 3 0 (OmegC+0.1)/(2*pi)]);
xticks(0:1:3)% create tick marks at 1/4 multiples of pi
xticklabels({'\Gamma', 'X', 'M','\Gamma'})

% end
box on

set(gca,'Layer','top')
pbaspect([1 1.2 1]);
xlabel('$\Re(\bf{k})$','interpreter', 'latex')
ylabel('$f$ [kHz]','interpreter', 'latex')
yticks(0:2000:14000)
yticklabels([0 2 4 6 8 10 12 14])
grid on
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
hold off
nexttile(tilpltBG)
set(gcf, 'Position',  [0, 0, 1920/2*0.9, 1080/2*0.9])
hold on

CompFreqBandsPIm1=plot(PImkxSCGX, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsPIm2=plot(PImkxSCXM, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsPIm3=plot(PImkxSCMG, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsCIm1=plot(CImkxSCGX, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
CompFreqBandsCIm2=plot(CImkxSCXM, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
CompFreqBandsCIm3=plot(CImkxSCMG, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DBlue,'MarkerEdgeColor',DBlue,'LineStyle','none');
CompFreqBandsRIm1=plot(RImkxSCGX, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsRIm2=plot(RImkxSCXM, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
CompFreqBandsRIm3=plot(RImkxSCMG, (0.1:dOmegC:OmegC+0.1)/(2*pi),'-ok','MarkerSize',MarkerSize1,'MarkerFaceColor',DRed,'MarkerEdgeColor',DRed,'LineStyle','none');
    
axis([0 3 0 (OmegC+0.1)/(2*pi)]);

hold off

pbaspect([1 1.2 1]);

grid on

xlabel('$\Im(\bf{k})$','interpreter', 'latex')
figureHandle = gcf;

set(findall(figureHandle,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
set(findall(figureHandle,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
set(gca,'ytick',[])
set(gca,'yticklabel',[])

box on

set(gca,'Layer','top')

tilplt.TileSpacing = 'none';
tilplt.Padding = 'none';