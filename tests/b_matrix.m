function B = b_matrix(xi, eta, nodes, elemType)
%B_MATRIX Summary of this function goes here
%   Detailed explanation goes here

switch elemType
    case 'q4'
        B = BQuad4(xi, eta, nodes);
    case 'q8'
        B = BQuad8(xi, eta, nodes);
    case 'q9'
        B = BQuad9(xi, eta, nodes);
end

end