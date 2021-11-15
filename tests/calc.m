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
    1. 0;
    1, 1;
    0. 1;
    0.5, 0;
    1, 0.5;
    0.5, 1;
    0, 0.5;
    0.5, 0.5];

nodes = nodesQ9;

E = 1;
v = 0.3;
t = 1;

% constitutuve law
CStrain = (E/((1 + v)*(1 - 2*v))) ...
    * [
    1 - v, v, 0;
    v, 1 - v, 0;
    0, 0, (1 - 2*v)/2
    ];

CStress = (E/(1 + v)) ...
    * [
    1/(1 - v), v/(1 - v), 0;
    v/(1 - v), 1/(1 - v), 0;
    0, 0, 0.5
    ];

C = CStrain;
% scheme of the natural coordinate system
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
order = 3;
% preallocate k
k = zeros(18);

% gauss points 1/sqrt(3)
% weights w = 1 (no need)
[intNodes, w] = gaussQuadrature(order);

% assembling k using gauss-quadrature
for n = 1:order^2
    B = b_matrix(intNodes(n,1), intNodes(n,2), nodes, 'q9');
    detJ = detJacobian(intNodes(n,1), intNodes(n,2), nodes);
    k = k + (t * B' * C * B * detJ) * w(n);
end

toc