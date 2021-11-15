clearvars
tic 

%% input parameters
% nodesQ4 = [
%     0, 0;
%     1, 0;
%     1, 1;
%     0, 1];
% 
% nodesQ9 = [
%     0, 0;
%     1, 0;
%     1, 1;
%     0, 1;
%     0.5, 0;
%     1, 0.5;
%     0.5, 1;
%     0, 0.5;
%     0.5, 0.5];
% 
% nodes = nodesQ9;
% loading mesh
beam

numEl = size(msh.QUADS9, 1);

nodPEle = size(msh.QUADS9,2)-1;

conn = msh.QUADS9(:, 1:nodPEle);

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

% degree of freedom per element
dof = 2;

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
for n = 1:numEl
    nodes = msh.POS(msh.QUADS9(n,1:nodPEle), :);
    [elementK, elementM] = Element2D(nodes, order, matProp, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs=reshape(repmat(conn(n,1:nodPEle),dof,1)*dof...
         - repmat((dof-1:-1:0)',1,nodPEle),[],1)';
end
%     Elements{i}.DOFs=reshape(repmat(Elements0(i,1:nodPEle),di,1)*di...
%         - repmat((di-1:-1:0)',1,nodPEle),[],1)';


[Ksys, Msys]=FastMatrixAssembly(Elements);

toc