function [B, N]  = b_matrix(xi, eta, invJT, elemType)
%B_MATRIX Summary of this function goes here
%   Detailed explanation goes here

B1 = [
    1, 0, 0, 0;
    0, 0, 0, 1;
    0, 1, 1, 0];

B2 = [
    invJT, zeros(2);
    zeros(2), invJT;
    ];

switch elemType
    case 'q4'
        B3 = BQuad4(xi, eta, nodes);
    case 'q8'
        B3 = BQuad8(xi, eta, nodes);
    case 'q9'
        [shape ,diffs] = shapeQ4(xi, eta, elemType);
            B3(1, 1:2:17) = diffs(:, 1);
            B3(2, 1:2:17) = diffs(:, 2);
            B3(3, 2:2:18) = diffs(:, 1);
            B3(4, 2:2:18) = diffs(:, 2);
            N(1, 1:2:17) = shape(:);
            N(2, 2:2:18) = shape(:);
end

B = B1*B2*B3;

end