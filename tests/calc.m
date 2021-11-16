clearvars
tic 

%% input parameters
% loading mesh
beam

% number Elements
numEl = size(msh.QUADS9, 1);

% Nodes per Element
nodPEle = size(msh.QUADS9,2)-1;

%% material properties
% Matrix material index for PnC=1!
% For multiple materials use vector: [E1;E2;...]. 

% Youngs Modulus [N/m^2]. 
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
    conn = msh.QUADS9(n,1:nodPEle);
    % Node matrix
    nodes = msh.POS(conn, :);
    % generating locale stiffness/mass matrix 
    [elementK, elementM] = Element2D(nodes, order, matProp, physics);
    Elements{n}.K = elementK;
    Elements{n}.M = elementM;
    Elements{n}.DOFs = reshape(repmat(conn ,dof,1)*dof...
         - repmat((dof-1:-1:0)',1,nodPEle),[],1)';
end

[Ksys, Msys]=FastMatrixAssembly(Elements);

% boundary conditions, physLine{11} (gmsh) fixed
uFixed = 2 * unique(msh.LINES3(find(msh.LINES3(:,end)==11), (1:end-1))) - 1;
vFixed = 2 * unique(msh.LINES3(find(msh.LINES3(:,end)==11), (1:end-1)));
prescrDof = [uFixed; vFixed];

% forces, physLine{12} (gmsh) line load in v
load = -1;
force = zeros(gDof, 1);
right = 2 * unique(msh.LINES3(find(msh.LINES3(:,end)==12), (1:end-1)));
% TODO: approach not correct! height of the beam is relevant!
force(right) = load/length(right);

displacements = solution(gDof, prescrDof, Ksys, force);

ux = displacements(1:2:end);
vy = displacements(2:2:end);
scaleFactor = 0.002;

% drawing mesh
figure;


drawingField(msh.POS(:,1:2) + scaleFactor*[ux vy], msh.QUADS9(:,1:9), vy)
hold on
colorbar

for k = 1:size(msh.QUADS9,1)
    patch(msh.POS(msh.QUADS9(k,1:4),1),msh.POS(msh.QUADS9(k,1:4),2), ...
        'w','FaceColor','none','LineStyle','--','EdgeColor','k');
end

axis equal

toc

function drawingField(nodes,conn,field)
  
if ( size(field) == size(conn) )
  elementalField=1;
else
  elementalField=0;
end

if (size(nodes,2) < 3)
   for c=size(nodes,2)+1:3
      nodes(:,c)=[zeros(size(nodes,1),1)];
   end
end

holdState=ishold;
hold on

% Q9 elements
%   ord=[1,5,2,6,3,7,4,8,1];
  ord=[1,2,3,4,1];

for e=1:size(conn,1)
  
   xpt=nodes(conn(e,ord),1);
   ypt=nodes(conn(e,ord),2);      
   zpt=nodes(conn(e,ord),3);
   
   if ( elementalField )
     fpt=field(e,ord);
   else
     fpt=field(conn(e,ord));
   end
   
   fill3(xpt,ypt,zpt,fpt)
end

shading interp
axis equal
      
if ( ~holdState )
  hold off
end
end

