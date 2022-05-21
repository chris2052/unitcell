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
mat = [1, 5];
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

% matProp = matComsol;

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

% reindex boundary (periodic boundary conditions, floquet-bloch)

PBC0 = [
    -l1/2, -l2/2, 0, -l1/2, l2/2, 0;
    l1/2, -l2/2, 0, l1/2, l2/2, 0;
    -l1/2, -l2/2, 0, l1/2, -l2/2, 0;
    -l1/2, l2/2, 0, l1/2, l2/2, 0];


[IdxPBCIn,IdxPBCOut,PBCTrans,BasisVec]=IndexPBC3D(InitialNodes,dof,PBC0,minNodeDist);  
i=sqrt(-1);

%% calculating and plotting (real) dispersion curves

nBand = 8;
deltaKxy0 = 500;
ratio = l1/l2;

[fBand, ABand, deltaKx, deltaKy, deltaKxy, kxy0] = dispersionCalc( ...
    nBand, deltaKxy0, PBCTrans, BasisVec, IdxPBCIn, IdxPBCOut, Ksys, Msys, ratio);

plotDispersion(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec);
plotDimensions(gca, gcf, 18, 12, .8, 0)

NormalizedFig = plotDispersionNormalized(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec);

%% Calculation of complex band structure
%
% round to next 10th
maxf = ceil(real(max(max(fBand))/10))*10;
% omega intervall end value for calculation of complex band structure
OmegC = maxf*2*pi;
% omega intervall increment value
% dOmegC = round(maxf/500) * 2*pi;
dOmegC = pi;

% reduce system to boundary nodes -> dynamic condensation
numredDoF = numDoF-size(unique(IdxPBCOut),1);
redDoF = 1:numDoF;
redDoF(:, unique(IdxPBCOut)) = [];
SIdxPBCIn = unique(sort(reshape(IdxPBCIn, [], 1)));
SIdxPBCOut = unique(sort(reshape(IdxPBCOut, [], 1)));
SlaveDofsPBC = 1:numDoF;
SlaveDofsPBC([SIdxPBCIn, SIdxPBCOut]) = [];
CompNodes = InitialNodes;
CompNodes(unique(ceil(SlaveDofsPBC/dof)), :) = [];
[IdxPBCCompIn, IdxPBCCompOut, PBCCompTrans, ~] = IndexPBC3D(CompNodes, dof, PBC0, ...
    minNodeDist);

tic

updateWaitbarCompBands = waitbarParfor(ceil(OmegC/dOmegC) + 1, ...
"Calculation of complex band structure in progress...");

parfor (idxComp = 1:ceil(OmegC/dOmegC)+1, ParaComp)
    
    omegComp = dOmegC*(idxComp - 1) + 0.1;
    
    DdynPBC = Ksys - omegComp^2 * Msys;
    
    % reduce system to boundary nodes -> dynamic condensation
    [DdynPBCred, ~, ~, ~, ~] = FastGuyanReduction(DdynPBC, DdynPBC, DdynPBC, SlaveDofsPBC);
    
    [D3GX, D4GX, D3XM, D4XM, D1MG, D2MG, D3MG, D3GY, D4GY, D3YM, D4YM] = ...
       CoefficientMatricesPBCrect(DdynPBCred, IdxPBCCompIn, IdxPBCCompOut,... 
       PBCCompTrans, theta);

    lambXiGX = quadeig(D3GX, D4GX, transpose(D3GX));
    kxSCGX0{idxComp} = i * log(lambXiGX);
    lambXiXM = quadeig(D3XM, D4XM, transpose(D3XM));
    kxSCXM0{idxComp} = i * log(lambXiXM);
    lambXiMG = polyeig(transpose(D1MG), transpose(D2MG), D3MG, D2MG, D1MG);
    kxSCMG0{idxComp} = i * log(lambXiMG);
    
    lambYiGY = quadeig(D3GY, D4GY, transpose(D3GY));
    kySCGY0{idxComp} = i * log(lambYiGY);
    lambYiYM = quadeig(D3YM, D4YM, transpose(D3YM));
    kySCYM0{idxComp} = i * log(lambYiYM);

    updateWaitbarCompBands(); 
end

CompBandStepTime = toc;
CompBandStepTime = CompBandStepTime/(ceil(OmegC/dOmegC)+1);
kxSCGX = cell2mat(kxSCGX0);
kxSCXM = cell2mat(kxSCXM0);
kxSCMG = cell2mat(kxSCMG0);

kySCGY = cell2mat(kySCGY0);
kySCYM = cell2mat(kySCYM0);

fprintf(['Calculation time for one frequency step is approximately ', ...
    num2str(CompBandStepTime), ' [s].', '\n'])

[kxSCGXRe, kxSCGXIm, kxSCGXCom] = filterCBS_2DFEM(kxSCGX);
[kxSCXMRe, kxSCXMIm, kxSCXMCom] = filterCBS_2DFEM(kxSCXM);
[kxSCMGRe, kxSCMGIm, kxSCMGCom] = filterCBS_2DFEM(kxSCMG);

kxSC = {kxSCGXRe, kxSCGXIm, kxSCGXCom, kxSCXMRe, kxSCXMIm, kxSCXMCom, kxSCMGRe, ...
    kxSCMGIm, kxSCMGCom};

[kySCGYRe, kySCGYIm, kySCGYCom] = filterCBS_2DFEM(kySCGY);
[kySCYMRe, kySCYMIm, kySCYMCom] = filterCBS_2DFEM(kySCYM);

kySC = {kySCGYRe, kySCGYIm, kySCGYCom,kySCYMRe, kySCYMIm, kySCYMCom};

%% plotting

plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'gx', 'cr', 'ci');
plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'xm', 'pr', 'ci');
plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'mg', 'pr', 'ci');

if l1 ~= l2

    plotDispersionComplRect(kySC, OmegC, dOmegC, maxf, 'gy', 'pr', 'ci');
    plotDispersionComplRect(kySC, OmegC, dOmegC, maxf, 'ym', 'pr', 'ci');

    ComplRealFig = plotDispersionComplRealRect(kxSC, kySC, OmegC, dOmegC, 0);

else 

    ComplRealFig = plotDispersionComplReal(kxSC, OmegC, dOmegC, 0);

end


