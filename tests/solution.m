function displacements = solution(GDof,prescribedDof,stiffness,force)
%SOLUTION Summary of this function goes here
%   Detailed explanation goes here

    activeDof = setdiff((1:GDof)', prescribedDof);
    U = stiffness(activeDof,activeDof)\force(activeDof);
    displacements = zeros(GDof,1);
    displacements(activeDof) = U;
    
end

