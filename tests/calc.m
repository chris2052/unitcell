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
C = constitutiveLaw(E, v, 'strain');

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

% gauss points and weights
[xi, eta, w] = gaussQuadrature(order);

% assembling k using gauss-quadrature
for n = 1:order
    for m = 1:order
        [detJ, invJT] = JacobianQuad(xi(n), eta(m), nodes);
        [B, N] = b_matrix(xi(n), eta(m), invJT, 'q9');
        k = k + (t * B' * C * B * detJ) * w(n)*w(m);
    end
end

toc