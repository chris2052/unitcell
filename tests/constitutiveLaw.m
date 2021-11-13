function C = constitutiveLaw(E, v, law)
%CONSTITUTIVELAW Summary of this function goes here
%   Detailed explanation goes here

switch law
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
end

