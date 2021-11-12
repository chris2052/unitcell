function detJ = detJacobian(xi, eta, nodes)
%DETJACOBIAN Summary of this function goes here
%   Detailed explanation goes here
xx = nodes(:,1);
yy = nodes(:,2);

x1 = xx(1);
x2 = xx(2);
x3 = xx(3);
x4 = xx(4);

y1 = yy(1);
y2 = yy(2);
y3 = yy(3);
y4 = yy(4);

detJ = ((x1*y2) - (x2*y1) - (x1*y4) + (x2*y3) - (x3*y2) + (x4*y1) + (x3*y4) - (x4*y3) - (eta*x1*y2) + (eta*x2*y1) + (eta*x1*y3) - (eta*x3*y1) - (eta*x2*y4) + (eta*x4*y2) + (eta*x3*y4) - (eta*x4*y3) - (x1*xi*y3) + (x3*xi*y1) + (x1*xi*y4) + (x2*xi*y3) - (x3*xi*y2) - (x4*xi*y1) - (x2*xi*y4) + (x4*xi*y2))/8;

end

