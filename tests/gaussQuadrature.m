function [xi, eta, weights] = gaussQuadrature(order)
%GAUSSQUADRATURE Summary of this function goes here
%   Detailed explanation goes here

switch order
    case 1
        xi = 0;
        eta = 0;
        weights = [2, 2];
    case 2
        xi = [-0.577350269189626, 0.577350269189626];
        eta = [-0.577350269189626, 0.577350269189626];
        weights = [1, 1];

    case 3
        xi = [-0.774596669241483, 0, 0.774596669241483];
        eta = [-0.774596669241483, 0, 0.774596669241483];
        weights = [0.555555555555556, 0.888888888888889, 0.555555555555556];

end
end

