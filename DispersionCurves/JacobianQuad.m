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

%     J = [(eta*x1*xi*(eta - 1))/4 + (eta*x2*xi*(eta - 1))/4 + (eta*x3*xi*(eta + 1))/4 + (eta*x4*xi*(eta + 1))/4 + (eta*x1*(eta - 1)*(xi - 1))/4 + (eta*x2*(eta - 1)*(xi + 1))/4 + (eta*x3*(eta + 1)*(xi + 1))/4 + (eta*x4*(eta + 1)*(xi - 1))/4, (eta*x1*xi*(xi - 1))/4 + (eta*x2*xi*(xi + 1))/4 + (eta*x3*xi*(xi + 1))/4 + (eta*x4*xi*(xi - 1))/4 + (x1*xi*(eta - 1)*(xi - 1))/4 + (x2*xi*(eta - 1)*(xi + 1))/4 + (x3*xi*(eta + 1)*(xi + 1))/4 + (x4*xi*(eta + 1)*(xi - 1))/4; 
%     (eta*xi*y1*(eta - 1))/4 + (eta*xi*y2*(eta - 1))/4 + (eta*xi*y3*(eta + 1))/4 + (eta*xi*y4*(eta + 1))/4 + (eta*y1*(eta - 1)*(xi - 1))/4 + (eta*y2*(eta - 1)*(xi + 1))/4 + (eta*y3*(eta + 1)*(xi + 1))/4 + (eta*y4*(eta + 1)*(xi - 1))/4, (eta*xi*y1*(xi - 1))/4 + (eta*xi*y2*(xi + 1))/4 + (eta*xi*y3*(xi + 1))/4 + (eta*xi*y4*(xi - 1))/4 + (xi*y1*(eta - 1)*(xi - 1))/4 + (xi*y2*(eta - 1)*(xi + 1))/4 + (xi*y3*(eta + 1)*(xi + 1))/4 + (xi*y4*(eta + 1)*(xi - 1))/4];
% 
%     detJ = det(J);
%     invJT = inv(J)';
%     
    detJ = 1/8*((x1*y2) - (x2*y1) - (x1*y4) + (x2*y3) - (x3*y2) + (x4*y1) ...
        + (x3*y4) - (x4*y3) - (eta*x1*y2) + (eta*x2*y1) + (eta*x1*y3) ...
        - (eta*x3*y1) - (eta*x2*y4) + (eta*x4*y2) + (eta*x3*y4) - (eta*x4*y3) ...
        - (x1*xi*y3) + (x3*xi*y1) + (x1*xi*y4) + (x2*xi*y3) - (x3*xi*y2) ... 
        - (x4*xi*y1) - (x2*xi*y4) + (x4*xi*y2));

    invJT = transpose([-(2*(y1 + y2 - y3 - y4 - xi*y1 + xi*y2 - xi*y3 + xi*y4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2), (2*(x1 + x2 - x3 - x4 - x1*xi + x2*xi - x3*xi + x4*xi))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2);
            (2*(y1 - y2 - y3 + y4 - eta*y1 + eta*y2 - eta*y3 + eta*y4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2), -(2*(x1 - x2 - x3 + x4 - eta*x1 + eta*x2 - eta*x3 + eta*x4))/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3 - eta*x1*y2 + eta*x2*y1 + eta*x1*y3 - eta*x3*y1 - eta*x2*y4 + eta*x4*y2 + eta*x3*y4 - eta*x4*y3 - x1*xi*y3 + x3*xi*y1 + x1*xi*y4 + x2*xi*y3 - x3*xi*y2 - x4*xi*y1 - x2*xi*y4 + x4*xi*y2)]);

end