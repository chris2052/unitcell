clearvars
close all

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  -------------------------------- BEGIN -----------------------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% creating mesh
nameMesh = 'testing';
% cell length
l1 = .1;
% cell height
l2 = .1;

createMeshUnitcell(nameMesh, l1, l2, .075/2, 0, 1, 10e-3, 1);

%% material properties
% Matrix material index for PnC=1!     !!v!!
% For multiple materials use vector: [E1 ; E2;...]. USE SEMICOLON ; !!!
% Youngs Modulus [N/m^2].              !!^!!
E = [.93e6; 2.1e11];

% Poission ratio [-]
v = [0.45; 0.3];

% Density [kg/m^3]
rho = [1250; 7850];

% Thickness [m]
t = [1; 1];

% (plane) "strain", "stress"
physics = "strain";

% order for gauss quadrature
order = 2;

% degree of freedom per node; (x, y)-direction
dof = 2;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ---------------------------------- END ------------------------------------
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loading mesh
evalin('caller', [nameMesh, 'ExportMesh']);

%% input parameters
% number Elements
numEl = size(msh.QUADS9, 1);

% number Nodes per Element
nodPEle = size(msh.QUADS9, 2) - 1;

% material matrix
matProp = [E, v, rho, t];
matIdx = msh.QUADS9(:, end);

%% getting mesh informations
% global degree of freedom
gDof = dof * msh.nbNod;

% xy-components, z is 0
nodesGlob = msh.POS(:, 1:2);
nodesX = nodesGlob(:, 1);
nodesY = nodesGlob(:, 2);

connGlob = msh.QUADS9(:, 1:9);

quadsCorner = msh.QUADS9(:, 1:4);
nodesCornerX = nodesX(quadsCorner);
nodesCornerY = nodesY(quadsCorner);

%% drawing mesh
meshFigure = figure;
meshFigure.Units = 'centimeters';
meshFigure.Position = [20, 8, 10, 10];

drawingMesh2D(nodesCornerX, nodesCornerY, 'none', '-', 'k');

meshAxis = gca;
meshAxis.Position = [.1, .1, .8, .8];

set(meshAxis, 'XColor', 'none', 'YColor', 'none');
% exportgraphics(meshFigure,'test.eps');
% set(meshAxis, 'visible', 'off');

%% scheme of the natural coordinate system (order = 2)
%
%                       7
%  (-1,1)    4----------o---------3 (1,1)
%            |                    |
%            |   x      x     x   |
%            |         eta        |
%            |          |         |
%          8 o   x      0->xi x   o 6
%            |          9         |
%            |                    |
%            |   x      x     x   |
%            |                    |
%  (-1,-1)   1----------o---------2 (1,-1)
%                       5
%
%% generate element stiffnes matrix k
%
parfor n = 1:numEl
    % Connectivity vector per element
    connEle = msh.QUADS9(n, 1:nodPEle);
    % Node matrix per element
    nodesEle = msh.POS(connEle, :);
    % gettings material properties per element
    matEle = matProp(matIdx(n), :);
    % generating locale stiffness/mass matrix
    [elementK, elementM] = Element2D(nodesEle, order, matEle, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs = reshape(repmat(connEle, dof, 1) * dof ...
        - repmat((dof - 1:-1:0)', 1, nodPEle), [], 1)';
end

%% global stiffness, mass
[Ksys, Msys] = FastMatrixAssembly(Elements);

%% getting eingenfrequencies
omega2 = eigs(Ksys, Msys, 10, 'smallestabs');
f = real(sqrt(omega2) / (2 * pi));
disp(f);

%% Dispersion Curves
%
% Minimalbeispiel zur Berechnung der Dispersionskurven
% Zusaetzliche Eingabedaten
% Das Beispiel funktioniert nicht als standalone, sondern die Ssteifigkeits-
% und Massenmatrix, sowie die Knotenmatrix muessen bereits berechnet worden sein.
% Dabei werden hier folgende Namen verwenden:
% Ksys - Steifigkeitsmatrix
% Msys - Massenmatrix
% InitialNodes - Knotenmatrix, wie aus gmsh exportiert (mit x y z Koordinate)

% Anzahl der zu berechnenden Baender im Dispersionsdiagramm
nBand = 6;
% deltaKxy=pi/deltaKxy0 (Unterteilung der Raender der Brillouinzone
% in deltaKxy-Werte
deltaKxy0 = 144;

% Festlegung der Bloch-Floquet-Randbedingungen:
%
% [Input line coordinates: x1, y1,z1, x2 ,y2,z2].
% Maintain direction for corresponding input/output lines,
% e.g. top->bottom/left->right.
PBC0(1, :) = [-l1 / 2, -l2 / 2, 0, -l1 / 2, l2 / 2, 0];
% [Output line coordinates: x1, y1,z1, x2 ,y2,z2].
% Maintain direction for corresponding input/output lines,
% e.g. top->bottom/left->right.
PBC0(2, :) = [l1 / 2, -l2 / 2, 0, l1 / 2, l2 / 2, 0];
% [Input line coordinates: xx1, y1,z1, x2 ,y2,z2].
% Maintain direction for corresponding input/output lines,
% e.g. top->bottom/left->right.
PBC0(3, :) = [-l1 / 2, -l2 / 2, 0, l1 / 2, -l2 / 2, 0];
% [Output line coordinates: x1, y1,z1, x2 ,y2,z2].
% Maintain direction for corresponding input/output lines,
% e.g. top->bottom/left->right.
PBC0(4, :) = [-l1 / 2, l2 / 2, 0, l1 / 2, l2 / 2, 0];
%

minNodeDist = 0.0001;

[IdxPBCIn, IdxPBCOut, PBCTrans, BasisVec] = IndexPBC3D(msh.POS, ...
    dof, PBC0, minNodeDist);

% IdxPBCIn gibt die jeweiligen Eingangs-Freiheitsgrade an, im Beispiel oben
% waeren das fuer die x-Richtung v3,v2 und v8.
% IdxPBCOut gibt die jeweiligen Ziel-Freiheitsgrade an, im Beispiel oben waeren
% das fuer die x-Richtung v7,v6 und v9.
% PBCTrans gibt die Translation fuer jeden Knoten auf der linken Seite auf
% die rechte Seite (bzw von unten nach oben) an.
% BasisVec ist der Basisvektor (Translationsvektor) fuer die jeweilige
% Randbedingung, also
% in x-Richtung waere der Vektor [hx 0 0].

maxBasisVecX = max(max(abs(BasisVec(:, 1))));
maxBasisVecY = max(max(abs(BasisVec(:, 2))));
normdkx = maxBasisVecX / min(maxBasisVecX, maxBasisVecY);
normdky = maxBasisVecY / min(maxBasisVecX, maxBasisVecY);
% Diese Berechnungen (bis Zeile 30) dienen nur der Normierung der
% Diskretisierung der Brillouin-Zone, sodass alle Reander auf der Brillouin-Zone
% gleich diskretisiert werden.
% Bsp. wenn der Rand Gamma-X und der Rand X-M jeweils in 100 Schritte
% unterteilt wird, dannn wird der Rand M-Gamma in sqrt(2)*100 Schritte
% unterteilt, da dieser Rand laenger ist.
% ----------------------------------------------------------------------------
% Calculation of real valued band structure omega(k)
deltaKx = pi / (deltaKxy0 * normdkx);
deltaKy = pi / (deltaKxy0 * normdky);
deltaKxy = pi / (deltaKxy0 * sqrt(normdky^2 + normdkx^2));
%Aufstellen der Vektoren fuer kx und ky entlang der Brillouin-Zone
%(s. Abb. oben)
kx0 = [(0:deltaKx:pi)'; ones(numel(deltaKy:deltaKy:pi), 1) * pi; ...
    (pi - deltaKxy:-deltaKxy:0)'];
ky0 = [zeros(numel(0:deltaKx:pi), 1); (deltaKy:deltaKy:pi)'; ...
        (pi - deltaKxy:-deltaKxy:0)'];

% GGf. loeschen einiger Eintraege, falls nur eine Bloch-Randbedinung in
% x-Richtung vorliegt
if size(BasisVec, 1) == 1
    kx0(deltaKxy0 + 2:end) = [];
    ky0(deltaKxy0 + 2:end) = [];
end

% Nummerierungsvektor von 1 bis Anzahl der Eintraege im kx bzw ky Vektor
kxy0 = 1:1:size(kx0);
% Anzahl an Freiheitsgraden im reduzierten System
% (also abzgl. v8, v5, v9, v6, v7)
nDofPBC = size(Ksys, 1) - size(unique(IdxPBCOut), 1);
% Preallokation einer Matrix, in die die Eigenfrequenzen pro Berechnungsschritt
% geschrieben werden
fBand = zeros(nBand, size(kx0, 1));
% Preallokation einer Matrix, in die die Eigenformen pro Berechnungsschritt
% geschrieben werden
ABand = zeros(nDofPBC, nBand, size(kx0, 1));
% Schleife zur Berechnung der Dispersionskurven
parfor kindx = 1:size(kx0, 1)
    %     kindx = 1;
    i = sqrt(-1);
    % Auslesen von kx
    kx = kx0(kindx) + 0.01;
    % Auslesen von ky
    ky = ky0(kindx);
    % Berechnung der Ausbreitungskonstante Lambdax
    lambX = exp(sqrt(-1) * kx);
    % Berechnung der Ausbreitungskonstante Lambday
    lambY = exp(sqrt(-1) * ky);
    % Einbau der Randbedingungen mittels Funktion
    [KPBC, MPBC, ~] = ApplyBlochBC2D(Ksys, Msys, IdxPBCIn, IdxPBCOut, lambX, ...
    lambY, PBCTrans);
    % Loesen des Eigenwertproblems
    [AEig0PBC, LambdaPBC] = eigs(KPBC, MPBC, nBand, 'smallestabs');
    % Sortieren der Loesungen
    [LambdaPBC, LambdaPBCLoc] = sort(diag(LambdaPBC));
    % Berechnung von omega (mit neuer Sortierung)
    OmegaiPBC = sqrt((LambdaPBC)');
    % Berechnung von f
    fiPBC = OmegaiPBC / (2 * pi());
    % Umsortierung der Eigenformen
    AEig0PBC = AEig0PBC(:, LambdaPBCLoc);
    % Abspeichern der Eigenfrequenzen
    fBand(:, kindx) = fiPBC';
    % Abspeichern der Eigenformen
    ABand(:, :, kindx) = AEig0PBC;
end

%% plotting dispersion curves
% settings for all plots
% Font = "CMU Serif";
FontSize = 12;
AxesLineWidth = 1;
LineLineWidth = 1;

dispersionFigure = figure;

% length/height of plot in centimeters
plotDimX = 10;
plotDimY = 10;

dispersionFigure.Units = 'centimeters';
dispersionFigure.Position = [35, 8, plotDimX, plotDimY];

dispersionFigure.PaperUnits = 'centimeters';
dispersionFigure.PaperPositionMode = 'manual';
dispersionFigure.PaperSize = [plotDimX, plotDimY];
dispersionFigure.PaperPosition = [0, 0, plotDimX, plotDimY];
dispersionFigure.Renderer = 'painters';

% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf,'papersize',[width,height])
% set(gcf,'paperposition',[0,0,width,height])
% set(gcf, 'renderer', 'painters');

plotDispersion(fBand, deltaKx, deltaKy, kxy0, BasisVec, FontSize, 1, 0);

dispersionAxis = gca;
dispersionAxis.Position = [.15, .15, .7, .7];
% exportgraphics(dispersionFigure,'testDisp.png');
% exportgraphics(dispersionFigure,'testDisp.eps');

saveas(dispersionFigure, 'testDisp', 'pdf');
% saveas(dispersionFigure, 'testDisp11', 'eps');

%% Plotting eigenmodes for specified wave vector
%%%%%%%%%%%%%%% predefined:
nPBCEig = 4; %nBand;
InitialNodes = nodesGlob;
PlotElements = connGlob(:,[1, 5, 2, 6, 3, 7, 4, 8, 1]);
QuadMeshNodes = connGlob(:, 1:4);
maxU0 = 0.01;
di = dof;
InitialElements = connGlob;
Font = 'CMU Serif';
colMap = 'jet';
PMshStudy = 0;
%%%%%%%%%%%%%%%
% KPlotPBCEF ist ein vorgegebener Wellenvektor, fuer den die Eigenform geplottet
% werden soll, beispielswiese [0; 0] waere die Stelle Gamma im Dispersionsdiagramm 
% und [pi; 0] die Stelle X, [pi; pi] M
KPlotPBCEF = [pi; 0];
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
if nPBCEig > 0 
    % Achsenlimits
    axLimitsS2 = [
        1.2 * unique(min(InitialNodes(:, 1))), ...
        1.2 * unique(max(InitialNodes(:, 1))), ...
        1.2 * unique(min(InitialNodes(:, 2))), ...
        1.2 * unique(max(InitialNodes(:, 2)))]; 
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
            PlotElements(:, 1:end), QuadMeshNodes, 1, zeros(size(AEigS2Plot)), ...
            totalDispEigS2, i, PBCfiPlot, KPlotPBCEF, Font, FontSize, axLimitsS2, ...
            colMap, PMshStudy);
    end
end
