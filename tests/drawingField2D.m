function drawingField2D(nodesGlob, conn, field)
%DRAWINGFIELD2D Summary of this function goes here
%   Detailed explanation goes here

    hold on
    % Q9 elements
    ord=[1,5,2,6,3,7,4,8,1];
    
    for e = 1:size(conn, 1)
        xpt = nodesGlob(conn(e, ord), 1);
        ypt = nodesGlob(conn(e, ord), 2);
        fpt = field(conn(e, ord));

        fill(xpt, ypt, fpt)
    end

    shading interp
    axis equal  
    hold off    
end


