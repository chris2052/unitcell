clearvars
tic 

%% input parameters
nodesQ4 = [
    0, 0;
    1, 0;
    1, 1;
    0, 1];

nodesQ9 = [
    0, 0;
    1, 0;
    1, 1;
    0, 1;
    0.5, 0;
    1, 0.5;
    0.5, 1;
    0, 0.5;
    0.5, 0.5];

nodes = nodesQ9;
numEl = 1;

%% material properties
% Youngs Modulus [N/m^2]. For multiple materials use vector: [E1;E2;...]. 
% Matrix material index for PnC=1!
E = 1;
% Poission ratio [-]
v = 0.3;
% Density [kg/m^3]
rho = 1;
% Thickness [m]
t = 1;

% material matrix
matProp=[E, v, rho, t];

% (plane) "strain", "stress"
physics = "strain";

order = 2;

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
% assembling k using gauss-quadrature
% for n = 1:order^2
%     [detJ, invJT] = JacobianQuad(intNodes(n,1), intNodes(n,2), nodes);
%     [B, N] = b_matrix(intNodes(n,1), intNodes(n,2), invJT, 'q9');
%     k = k + (t * B' * C * B * detJ) * w(n);
% end
parfor n = 1:numEl
    [elementK, elementM] = Element2D(nodes, order, matProp, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
end

% [Ksys, Msys]=FastMatrixAssembly(Elements);

toc