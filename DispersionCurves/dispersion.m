clearvars
tic
%% creating mesh

nameMesh = 'unitcell';
createMeshUnitcell(nameMesh, .01, 1, .5);

% loading mesh
evalin('caller', [nameMesh, 'Mesh']);
%% input parameters
% number Elements
numEl = size(msh.QUADS9, 1);

% Nodes per Element
nodPEle = size(msh.QUADS9, 2) - 1;

%% material properties
% Matrix material index for PnC=1!
% For multiple materials use vector: [E1;E2;...].

% Youngs Modulus [N/m^2].
E = [1; 2];

% Poission ratio [-]
v = [0.3; 0.2];

% Density [kg/m^3]
rho = [1; 1];

% Thickness [m]
t = [1; 1];

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
%% generate element stiffnes matrix k
%
parfor n = 1:numEl
    % Connectivity Matrix
    conn = msh.QUADS9(n, 1:nodPEle);
    % Node matrix
    nodes = msh.POS(conn, :);
    % generating locale stiffness/mass matrix
    [elementK, elementM] = Element2D(nodes, order, matProp, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs = reshape(repmat(conn, dof, 1) * dof ...
        - repmat((dof - 1:-1:0)', 1, nodPEle), [], 1)';
end

[Ksys, Msys] = FastMatrixAssembly(Elements);
toc