function [k, m] = Element2D(nodes, order, matProp, elemType, physics)
%ELEMENT2D Summary of this function goes here
%   Detailed explanation goes here
% 4---7---3
% |       |
% 8	  9   6
% |       |
% 1---5---2
%

cornerNodes = nodes(1:4,:);

E = matProp(1);
v = matProp(2);
rho = matProp(3);
t = matProp(4);

[IntNodes, w] = gaussQuadrature(order);

switch physics
    case 'strain'
        C = (E/((1 + v)*(1 - 2*v))) ...
            * [
            1 - v, v, 0;
            v, 1 - v, 0;
            0, 0, (1 - 2*v)/2
            ];
    case 'stress'
        C = (E/(1 + v)) ...
            * [
            1/(1 - v), v/(1 - v), 0;
            v/(1 - v), 1/(1 - v), 0;
            0, 0, 0.5
            ];
end

k = zeros(2*(order + 1)^2);
m = zeros(2*(order + 1)^2);
B = zeros(3, 2*(order + 1)^2);
N = zeros(2, 2*(order + 1)^2);

for n = 1:(order + 1)^2
    [detJ, invJT] = JacobianQuad(IntNodes(n,1), IntNodes(n,2), cornerNodes);
    [shape, diff] = shapeQuad(IntNodes(n,1), IntNodes(n,2), elemType);
    B0 = invJT * diff';
    B(1, 1:2:2*(order + 1)^2 - 1) = B0(1,:);
    B(2, 2:2:2*(order + 1)^2) = B0(2,:);
    B(3, 1:2:2*(order + 1)^2 - 1) = B0(2,:);
    B(3, 2:2:2*(order + 1)^2) = B0(1,:);
    N(1, 1:2:2*(order + 1)^2 - 1) = shape;
    N(2, 2:2:2*(order + 1)^2) = shape;
    k = k + B' * C * B * w(n) * detJ * t;
    m = m + N' * N * w(n) * detJ * t * rho;
end

end

function [intNodes, weights] = gaussQuadrature(order)
%GAUSSQUADRATURE Summary of this function goes here
%   `order` is order of polynominal function
%

switch order
    case 1
        intNodes = [0, 0];
        weights = [2, 2];

    case 'reduced' % 2 gauss points sind ausreichend for exact integraion of polynominal order 2
        intNodes = [
            -0.577350269189626, -0.577350269189626;
            -0.577350269189626, 0.577350269189626;
            0.577350269189626, 0.577350269189626;
            0.577350269189626, -0.577350269189626
            ];
        weights = [1, 1, 1, 1];

    case 2 % 3 integration points TODO fixing order and let gauss points variable
        intNodes = [
            -0.774596669241483, -0.774596669241483;
            -0.774596669241483, 0;
            -0.774596669241483, 0.774596669241483;
            0, -0.774596669241483;
            0 , 0 ;
            0, 0.774596669241483;
            0.774596669241483, -0.774596669241483;
            0.774596669241483, 0;
            0.774596669241483, 0.774596669241483;
            ];
        weights = [
            0.555555555555556 * 0.555555555555556, ...
            0.555555555555556 * 0.888888888888889, ...
            0.555555555555556 * 0.555555555555556,...
            0.888888888888889 * 0.555555555555556, ...
            0.888888888888889 * 0.888888888888889, ...
            0.888888888888889 * 0.555555555555556, ...
            0.555555555555556 * 0.555555555555556, ...
            0.555555555555556 * 0.888888888888889, ...
            0.555555555555556 * 0.555555555555556
            ];

end
end


function [detJ, invJT] = JacobianQuad(xi, eta, nodes)
%JACOBIANQUAD Calculate Jacobian of a Quad-Element
%   Only the 4 corner nodes are needed for the Jacobian (change of
%   area)
%
% coordinate scheme:
% 4-------3
% |       |
% |		  |
% |       |
% 1-------2
%

xx = nodes(:, 1);
yy = nodes(:, 2);

x1 = xx(1);
x2 = xx(2);
x3 = xx(3);
x4 = xx(4);

y1 = yy(1);
y2 = yy(2);
y3 = yy(3);
y4 = yy(4);

detJ = 1/8*((x1*y2) - (x2*y1) - (x1*y4) + (x2*y3) - (x3*y2) + (x4*y1) ...
    + (x3*y4) - (x4*y3) - (eta*x1*y2) + (eta*x2*y1) + (eta*x1*y3) ...
    - (eta*x3*y1) - (eta*x2*y4) + (eta*x4*y2) + (eta*x3*y4) - (eta*x4*y3) ...
    - (x1*xi*y3) + (x3*xi*y1) + (x1*xi*y4) + (x2*xi*y3) - (x3*xi*y2) ... 
    - (x4*xi*y1) - (x2*xi*y4) + (x4*xi*y2));

invJT = transpose([-(2*(y1 + y2 - y3 - y4 - xi*y1 + xi*y2 - xi*y3 + xi*y4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2), (2*(x1 + x2 - x3 - x4 - x1*xi + x2*xi - x3*xi + x4*xi))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2);
        (2*(y1 - y2 - y3 + y4 - eta*y1 + eta*y2 - eta*y3 + eta*y4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2), -(2*(x1 - x2 - x3 + x4 - eta*x1 + eta*x2 - eta*x3 + eta*x4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2)]);

end

function [shape,diffs] = shapeQuad(xi, eta, elemType)
%SHAPEQ4 Return the shape-funktions and derrivatives of a Quad-element
%   elemType: 'q9', ('q8', 'q4')
%

switch elemType
    case 'q4'
        shape = 1/4*[
            (1 - xi)*(1 - eta);
            (1 + xi)*(1 - eta);
            (1 + xi)*(1 + eta);
            (1 - xi)*(1 + eta);
            ];

        diffs = [
            eta/4 - 1/4, xi/4 - 1/4
            1/4 - eta/4, -xi/4 - 1/4
            eta/4 + 1/4,xi/4 + 1/4
            -eta/4 - 1/4, 1/4 - xi/4]; 
    
    case 'q8'
        shape = 1/4*[
            -(1-xi)*(1-eta)*(1+xi+eta);
            -(1+xi)*(1-eta)*(1-xi+eta);
            -(1+xi)*(1+eta)*(1-xi-eta);
            -(1-xi)*(1+eta)*(1+xi-eta);
            2*(1-xi*xi)*(1-eta);
            2*(1+xi)*(1-eta*eta);
            2*(1-xi*xi)*(1+eta);
            2*(1-xi)*(1-eta*eta);
            ];

        diffs = []; % TODO

    case 'q9'
        shape = 1/4*[
            xi*eta*(xi-1)*(eta-1);
            xi*eta*(xi+1)*(eta-1);
            xi*eta*(xi+1)*(eta+1);
            xi*eta*(xi-1)*(eta+1);
            -2*eta*(xi*xi-1)*(eta-1);
            -2*xi*(xi+1)*(eta*eta-1);
            -2*eta*(xi*xi-1)*(eta+1);
            -2*xi*(xi-1)*(eta*eta-1);
            4*(xi*xi-1)*(eta*eta-1)];

        diffs = [
            (eta*(2*xi - 1)*(eta - 1))/4, (xi*(2*eta - 1)*(xi - 1))/4;
            (eta*(2*xi + 1)*(eta - 1))/4, (xi*(2*eta - 1)*(xi + 1))/4; 
            (eta*(2*xi + 1)*(eta + 1))/4, (xi*(2*eta + 1)*(xi + 1))/4; 
            (eta*(2*xi - 1)*(eta + 1))/4, (xi*(2*eta + 1)*(xi - 1))/4; 
            -eta*xi*(eta - 1), -((2*eta - 1)*(xi^2 - 1))/2; 
            -((eta^2 - 1)*(2*xi + 1))/2, -eta*xi*(xi + 1); 
            -eta*xi*(eta + 1), -((2*eta + 1)*(xi^2 - 1))/2; 
            -((eta^2 - 1)*(2*xi - 1))/2, -eta*xi*(xi - 1); 
            2*xi*(eta^2 - 1), 2*eta*(xi^2 - 1)];

end

end
