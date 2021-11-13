function [detJ, invJT] = JacobianQuad(xi, eta, nodes)
    %JACOBIANQUAD Summary of this function goes here
    %   Detailed explanation goes here
    % coordinate scheme:
    % 4--------3
    % |        |
    % |		   |
    % |        |
    % 1--------2

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
    
    detJ = ((x1 * y2) - (x2 * y1) - (x1 * y4) + (x2 * y3) - (x3 * y2) + (x4 * y1) + (x3 * y4) - (x4 * y3) - (eta * x1 * y2) + (eta * x2 * y1) + (eta * x1 * y3) - (eta * x3 * y1) - (eta * x2 * y4) + (eta * x4 * y2) + (eta * x3 * y4) - (eta * x4 * y3) - (x1 * xi * y3) + (x3 * xi * y1) + (x1 * xi * y4) + (x2 * xi * y3) - (x3 * xi * y2) - (x4 * xi * y1) - (x2 * xi * y4) + (x4 * xi * y2)) / 8;

    invJT = [(2*(y1 - y2 + y3 - y4 - 2*eta*y1 + 2*eta*y2 + 2*eta*y3 - 2*eta*y4 - xi*y1 - xi*y2 + xi*y3 + xi*y4 + 2*eta*xi*y1 + 2*eta*xi*y2 + 2*eta*xi*y3 + 2*eta*xi*y4))/(eta*(eta*x1*y3 - eta*x3*y1 - eta*x1*y4 - eta*x2*y3 + eta*x3*y2 + eta*x4*y1 + eta*x2*y4 - eta*x4*y2 + x1*xi*y2 - x2*xi*y1 - x1*xi*y3 + x3*xi*y1 + x2*xi*y4 - x4*xi*y2 - x3*xi*y4 + x4*xi*y3 - 3*eta*x1*xi*y2 + 3*eta*x2*xi*y1 + 3*eta*x1*xi*y4 - 3*eta*x2*xi*y3 + 3*eta*x3*xi*y2 - 3*eta*x4*xi*y1 - 3*eta*x3*xi*y4 + 3*eta*x4*xi*y3 + 2*eta^2*x1*xi*y2 - 2*eta^2*x2*xi*y1 - 2*eta*x1*xi^2*y3 + 2*eta*x3*xi^2*y1 + 2*eta^2*x1*xi*y3 - 2*eta^2*x3*xi*y1 - 2*eta*x1*xi^2*y4 - 2*eta*x2*xi^2*y3 + 2*eta*x3*xi^2*y2 + 2*eta*x4*xi^2*y1 - 2*eta*x2*xi^2*y4 + 2*eta*x4*xi^2*y2 - 2*eta^2*x2*xi*y4 + 2*eta^2*x4*xi*y2 - 2*eta^2*x3*xi*y4 + 2*eta^2*x4*xi*y3)), -(2*(y1 - y2 + y3 - y4 - eta*y1 + eta*y2 + eta*y3 - eta*y4 - 2*xi*y1 - 2*xi*y2 + 2*xi*y3 + 2*xi*y4 + 2*eta*xi*y1 + 2*eta*xi*y2 + 2*eta*xi*y3 + 2*eta*xi*y4))/(xi*(eta*x1*y3 - eta*x3*y1 - eta*x1*y4 - eta*x2*y3 + eta*x3*y2 + eta*x4*y1 + eta*x2*y4 - eta*x4*y2 + x1*xi*y2 - x2*xi*y1 - x1*xi*y3 + x3*xi*y1 + x2*xi*y4 - x4*xi*y2 - x3*xi*y4 + x4*xi*y3 - 3*eta*x1*xi*y2 + 3*eta*x2*xi*y1 + 3*eta*x1*xi*y4 - 3*eta*x2*xi*y3 + 3*eta*x3*xi*y2 - 3*eta*x4*xi*y1 - 3*eta*x3*xi*y4 + 3*eta*x4*xi*y3 + 2*eta^2*x1*xi*y2 - 2*eta^2*x2*xi*y1 - 2*eta*x1*xi^2*y3 + 2*eta*x3*xi^2*y1 + 2*eta^2*x1*xi*y3 - 2*eta^2*x3*xi*y1 - 2*eta*x1*xi^2*y4 - 2*eta*x2*xi^2*y3 + 2*eta*x3*xi^2*y2 + 2*eta*x4*xi^2*y1 - 2*eta*x2*xi^2*y4 + 2*eta*x4*xi^2*y2 - 2*eta^2*x2*xi*y4 + 2*eta^2*x4*xi*y2 - 2*eta^2*x3*xi*y4 + 2*eta^2*x4*xi*y3));
    -(2*(x1 - x2 + x3 - x4 - 2*eta*x1 + 2*eta*x2 + 2*eta*x3 - 2*eta*x4 - x1*xi - x2*xi + x3*xi + x4*xi + 2*eta*x1*xi + 2*eta*x2*xi + 2*eta*x3*xi + 2*eta*x4*xi))/(eta*(eta*x1*y3 - eta*x3*y1 - eta*x1*y4 - eta*x2*y3 + eta*x3*y2 + eta*x4*y1 + eta*x2*y4 - eta*x4*y2 + x1*xi*y2 - x2*xi*y1 - x1*xi*y3 + x3*xi*y1 + x2*xi*y4 - x4*xi*y2 - x3*xi*y4 + x4*xi*y3 - 3*eta*x1*xi*y2 + 3*eta*x2*xi*y1 + 3*eta*x1*xi*y4 - 3*eta*x2*xi*y3 + 3*eta*x3*xi*y2 - 3*eta*x4*xi*y1 - 3*eta*x3*xi*y4 + 3*eta*x4*xi*y3 + 2*eta^2*x1*xi*y2 - 2*eta^2*x2*xi*y1 - 2*eta*x1*xi^2*y3 + 2*eta*x3*xi^2*y1 + 2*eta^2*x1*xi*y3 - 2*eta^2*x3*xi*y1 - 2*eta*x1*xi^2*y4 - 2*eta*x2*xi^2*y3 + 2*eta*x3*xi^2*y2 + 2*eta*x4*xi^2*y1 - 2*eta*x2*xi^2*y4 + 2*eta*x4*xi^2*y2 - 2*eta^2*x2*xi*y4 + 2*eta^2*x4*xi*y2 - 2*eta^2*x3*xi*y4 + 2*eta^2*x4*xi*y3)), (2*(x1 - x2 + x3 - x4 - eta*x1 + eta*x2 + eta*x3 - eta*x4 - 2*x1*xi - 2*x2*xi + 2*x3*xi + 2*x4*xi + 2*eta*x1*xi + 2*eta*x2*xi + 2*eta*x3*xi + 2*eta*x4*xi))/(xi*(eta*x1*y3 - eta*x3*y1 - eta*x1*y4 - eta*x2*y3 + eta*x3*y2 + eta*x4*y1 + eta*x2*y4 - eta*x4*y2 + x1*xi*y2 - x2*xi*y1 - x1*xi*y3 + x3*xi*y1 + x2*xi*y4 - x4*xi*y2 - x3*xi*y4 + x4*xi*y3 - 3*eta*x1*xi*y2 + 3*eta*x2*xi*y1 + 3*eta*x1*xi*y4 - 3*eta*x2*xi*y3 + 3*eta*x3*xi*y2 - 3*eta*x4*xi*y1 - 3*eta*x3*xi*y4 + 3*eta*x4*xi*y3 + 2*eta^2*x1*xi*y2 - 2*eta^2*x2*xi*y1 - 2*eta*x1*xi^2*y3 + 2*eta*x3*xi^2*y1 + 2*eta^2*x1*xi*y3 - 2*eta^2*x3*xi*y1 - 2*eta*x1*xi^2*y4 - 2*eta*x2*xi^2*y3 + 2*eta*x3*xi^2*y2 + 2*eta*x4*xi^2*y1 - 2*eta*x2*xi^2*y4 + 2*eta*x4*xi^2*y2 - 2*eta^2*x2*xi*y4 + 2*eta^2*x4*xi*y2 - 2*eta^2*x3*xi*y4 + 2*eta^2*x4*xi*y3))];
end