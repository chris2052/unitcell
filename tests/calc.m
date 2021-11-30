clearvars
close

tic

%% input parameters
% loading mesh
beam_coarse

% number Elements
numEl = size(msh.QUADS9, 1);

% Nodes per Element
nodPEle = size(msh.QUADS9, 2) - 1;

%% material properties
% Matrix material index for PnC=1!
% For multiple materials use vector: [E1;E2;...].

% Youngs Modulus [N/m^2].
E = 30000e6;

% Poission ratio [-]
v = 0.3;

% Density [kg/m^3]
rho = 2500;

% Thickness [m]
t = 1;

% material matrix
matProp = [E, v, rho, t];

% (plane) "strain", "stress"
physics = "strain";

% order for gauss quadrature
order = 2;

% degree of freedom per node; (x, y)-direction
dof = 2;

% global degree of freedom
gDof = dof * msh.nbNod;

% scheme of the natural coordinate system (order = 2)
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
%

% xy-components, z not needed
nodesGlob = msh.POS(:, 1:2);
nodesX = nodesGlob(:, 1);
nodesY = nodesGlob(:, 2);

connGlob = msh.QUADS9(:, 1:9);

quadsCorner = msh.QUADS9(:, 1:4);
nodesCornerX = nodesX(quadsCorner);
nodesCornerY = nodesY(quadsCorner);

%% generate element stiffnes matrix k
%
parfor n = 1:numEl
    % Connectivity Matrix
    connEle = msh.QUADS9(n, 1:nodPEle);
    % Node matrix
    nodesEle = msh.POS(connEle, :);
    % generating locale stiffness/mass matrix
    [elementK, elementM] = Element2D(nodesEle, order, matProp, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs = reshape(repmat(connEle, dof, 1) * dof ...
        - repmat((dof - 1:-1:0)', 1, nodPEle), [], 1)';
end

[Ksys, Msys] = FastMatrixAssembly(Elements);

% boundary conditions, physLine{11} (gmsh) fixed
uFixed = 2 * unique(msh.LINES3(find(msh.LINES3(:, end) == 11), (1:end - 1))) - 1;
vFixed = 2 * unique(msh.LINES3(find(msh.LINES3(:, end) == 11), (1:end - 1)));
prescrDof = [uFixed; vFixed];

% forces, physLine{12} (gmsh) line load in v
load = -10000e3;
force = zeros(gDof, 1);
right = 2 * unique(msh.LINES3(find(msh.LINES3(:, end) == 12), (1:end - 1)));
% TODO: approach not correct! height of the beam is relevant!
force(right) = load / length(right);

displacements = solution(gDof, prescrDof, Ksys, force);

ux = displacements(1:2:end);
uy = displacements(2:2:end);
% wz = zeros(length(vy),1);
scaleFactor = 5;

%% drawing color field
figure;

drawingField2D(nodesGlob + scaleFactor * [ux uy], connGlob, uy);

hold on
colorbar

drawingMesh2D(nodesCornerX, nodesCornerY, 'none', '-', 'k');

axis equal

%% eigs
[Kred,idxDiriBC,DBCPresc, ~]=ApplyDirichletBC3D(Ksys,dof,[0,0,0,0,1,0,0,0],0,msh.POS,0.0001);        %Apply Dirichlet boundary conditions to K. TODO: Für Fluide anpassen

[Mred,~, ~,~]=ApplyDirichletBC3D(Msys,dof,[0,0,0,0,1,0,0,0],0,msh.POS,0.0001);       

[v,d] = eigs(Kred, Mred, 4, 'sm');

toc