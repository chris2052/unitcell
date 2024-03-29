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
% cell length, x [cm]
len1 = 10;
% cell height, y [cm]
len2 = 10;

% diameter of inclusion (core) [cm]
dInclusion = 9.6;
% thickness of coating [cm]; 0, if no coating!in
tCoating = .1;

% convert radius out and in [m]
if tCoating > 0
    rOut = (dInclusion/2 + tCoating)/100;
    rIn = (dInclusion/2)/100;
else
    rOut = dInclusion/(2 * 100);
    rIn = 0;
end

% convert cell length [m]
l1 = len1/100;
l2 = len2/100;

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
% ratio
theta = 1;

% calculate modeshapes? (0: no, >0: numberOfShapes)
nEig = 0;
plotEig = [pi; 0];

% calculate complex band-structure? (1: yes, 0: no)
calcCompl = 1;

%% materials
%
% See 'MaterialList_Isotropic.txt'
% matrix material (-> coating material) -> core material
matNames = {'Plexiglass', 'Silicon', 'Wolfram'};
%
% thicknes of material layers
thickness = 1;
t = ones(1, size(matNames, 2)) * thickness;
% t = [1, 1, 1];
%
%% physics
%
% (plane) "strain", "stress"
physics = "strain";
%
% Minimum node distance to be considered, important for node indexing when line
% boundary conditions are applied. Usually this value doesnt have to be changed.
minNodeDist = 0.0001;
% Set parallel computing (yes/no). Parallel computing is only effective for
% large systems (statistics and machine learning Toolbox for improvement)
ParaComp = 6;

%  -------------------------------- END -------------------------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% getting mesh parameters

% creating mesh
createMeshUnitcell(nameMesh, l1, l2, rOut, rIn, lc, maxMesh, factorMesh, order);

% loading mesh
evalin('caller', [nameMesh, 'MESH']);
% quads9NEW

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

%% material properties

materials = importMatFile('MaterialList_Isotropic');

mat = zeros(1, size(matNames, 2));

for n = 1:size(matNames, 2)
    mat(1, n) = find(strcmp(materials, matNames{n}));
end

matComsol = [
    1e3, 0.45, 2e9, 1;
    8e3, 0.34, 200e9, 1;
    ];

% material matrix rho[kg/m3], v[-], E[N/m^2], t[m]
matProp = materials(mat, 2:4);
matProp = cell2mat(matProp);
matProp(:, 4) = t';
% matName = materialNames(mat);
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

nBand = 10;
deltaKxy0 = 50;
ratio = l1/l2;
tic
[fBand, ABand, deltaKx, deltaKy, deltaKxy, kxy0, kx0, ky0] = dispersionCalc( ...
    nBand, deltaKxy0, PBCTrans, BasisVec, IdxPBCIn, IdxPBCOut, Ksys, Msys, ratio);
toc
plotDispersion(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec);
plotDimensions(gca, gcf, 18, 12, .8, 0)

% NormalizedFig = plotDispersionNormalized(fBand, deltaKx, deltaKy, deltaKxy, kxy0, BasisVec);

%% Plotting eigenmodes for specified wave vector
%%%%%%%%%%%%%%% predefined:
nPBCEig = nEig;
PlotElements = connGlob(:,[1, 5, 2, 6, 3, 7, 4, 8, 1]);
QuadMeshNodes = connGlob(:, 1:4);
maxU0 = 1e-3;
di = dof;
InitialElements = connGlob;
Font = 'CMU Serif';
colMap = 'jet';
PMshStudy = 0;
%%%%%%%%%%%%%%%
% KPlotPBCEF ist ein vorgegebener Wellenvektor, fuer den die Eigenform geplottet
% werden soll, beispielswiese [0; 0] waere die Stelle Gamma im Dispersionsdiagramm
% und [pi; 0] die Stelle X, [pi; pi] M
KPlotPBCEF = plotEig;
kxEF = KPlotPBCEF(1);
kyEF = KPlotPBCEF(2);
% Index von KPlotPBCEF in der Matrix der Wellenvektoren bestimmen
[~, indxKEF] = ismember(KPlotPBCEF', [kx0 ky0], 'rows');

i = sqrt(-1);
% Lambda_x und Lamda_y fuer die vorgegebenen Wellenvektoren bestimmen
lambX = exp(sqrt(-1) * kxEF);
lambY = exp(sqrt(-1) * kyEF);
% Transformationsmatrix LambdaR berechnen
[~, ~, LambdaR] = ApplyBlochBC2D(Ksys, Msys, IdxPBCIn, IdxPBCOut, lambX, ...
    lambY, PBCTrans);
% nPBCEig ist die Anzahl der zu plottenden Eigenformen
if nPBCEig > 0 && nPBCEig <= size(fBand, 1)
    % Achsenlimits
    axLimitsS2 = 1.0 * [
        unique(min(InitialNodes(:, 1))), ...
        unique(max(InitialNodes(:, 1))), ...
        unique(min(InitialNodes(:, 2))), ...
        unique(max(InitialNodes(:, 2)))];
    % Schleife zum Plotten aller Eigenformen
    for i = 1:nPBCEig

        figure
        % ABand sind die Eigenformen aus deiner Berechnung, hier werden dann die
        % Randbedingungen wieder eingebaut
        APBCEF = real(LambdaR * ABand(:, i, indxKEF));
        % Die zugehoerige Frequenz wird ausgelesen
        PBCfiPlot = fBand(i, indxKEF);
        % Normierung der Eigenformen auf eine vorgegebene maximale Amplitude maxU0
        PlotFakS2 = maxU0 / unique(max(max(abs(APBCEF))));
        % Umsortierung der Eigenformen nach Anteil in x - und y - Richtung,
        % also [u1 v1; u2 v2; …]
        AEigS2Plot = PlotFakS2 * [APBCEF(1:di:end) APBCEF(2:di:end) * (di - 1)];
        % Resultierende Verschiebung
        totalDispEigS2 = (AEigS2Plot(:, 1).^2 + (di - 1) ...
            * AEigS2Plot(:, 2).^2).^(0.5);

        Plot2DPBCEigenmodes(InitialNodes(:, 1:2), InitialElements(:, 1:nodPEle), ...
            PlotElements(:, 1:end), QuadMeshNodes, zeros(size(AEigS2Plot)), ...
            totalDispEigS2, i, PBCfiPlot, KPlotPBCEF, axLimitsS2, ...
            colMap, PMshStudy);
        SetColorbar
        axis off
        %         plotDimensions(gcf, gca, 11, 6, .8)

    end

end

%% Calculation of complex band structure
%
if calcCompl >= 1
    %
    % round to next 10th
    maxf = ceil(real(max(max(fBand))/10))*10;

    % omega intervall end value for calculation of complex band structure
    OmegC = maxf*2*pi;

    % omega intervall increment value
    dOmegC = round(maxf/500) * 2*pi;
    % dOmegC = 10 * 2*pi;

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
    %
    % directions: gx, xm, mg, gy, ym
    %
    % real dispersion:
    %   pr: pure real
    %   cr: complex real
    % imaginary dispersion:
    %   pi: pure imaginary
    %   ri: real imaginary
    %   ci: complex imaginary
    %
    % plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'gx', 'pr', 'pi');
    % plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'xm', 'pr', 'pi');
    % plotDispersionCompl(kxSC, OmegC, dOmegC, maxf, 'mg', 'pr', 'pi');

    plotDispersionCompl2(kxSC, OmegC, dOmegC, maxf, 'gx', 'pr');
    plotDispersionCompl2(kxSC, OmegC, dOmegC, maxf, 'xm', 'pr');
    plotDispersionCompl2(kxSC, OmegC, dOmegC, maxf, 'mg', 'pr');

    if l1 ~= l2

        %     plotDispersionComplRect(kySC, OmegC, dOmegC, maxf, 'gy', 'pr', 'pi');
        %     plotDispersionComplRect(kySC, OmegC, dOmegC, maxf, 'ym', 'pr', 'pi');

        plotDispersionComplRect2(kySC, OmegC, dOmegC, maxf, 'gy', 'pr');
        plotDispersionComplRect2(kySC, OmegC, dOmegC, maxf, 'ym', 'pr');

        ComplRealFig = plotDispersionComplRealRect(kxSC, kySC, OmegC, dOmegC, 0);
        ComplRealFigAll = plotDispersionComplAllRect(kxSC, kySC, OmegC, dOmegC, maxf, fBand);

    else

        ComplRealFig = plotDispersionComplReal(kxSC, OmegC, dOmegC, 0);
        ComplRealFigAll = plotDispersionComplAll(kxSC, OmegC, dOmegC, maxf, fBand);

    end

end