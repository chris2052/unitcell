function [k, m] = Element2D(nodes, order, matProp, physics)
%ELEMENT2D Summary of this function goes here
%   Detailed explanation goes here
% 4---7---3
% |       |
% 8	  9   6
% |       |
% 1---5---2

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
    [shape, diff] = shapeQ4(IntNodes(n,1), IntNodes(n,2), 'q9');
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