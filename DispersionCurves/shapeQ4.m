function [shape,diffs] = shapeQ4(xi, eta, elemType)
%SHAPEQ4 Summary of this function goes here
%   Detailed explanation goes here
switch elemType
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
% shapeQ4 = 1/4*[
%     (1 - xi)*(1 - eta);
%     (1 + xi)*(1 - eta);
%     (1 + xi)*(1 + eta);
%     (1 - xi)*(1 + eta);
%     ];
% 
% shapeQ8 = 1/4*[-(1-xi)*(1-eta)*(1+xi+eta);
%     -(1+xi)*(1-eta)*(1-xi+eta);
%     -(1+xi)*(1+eta)*(1-xi-eta);
%     -(1-xi)*(1+eta)*(1+xi-eta);
%     2*(1-xi*xi)*(1-eta);
%     2*(1+xi)*(1-eta*eta);
%     2*(1-xi*xi)*(1+eta);
%     2*(1-xi)*(1-eta*eta)];
% 
