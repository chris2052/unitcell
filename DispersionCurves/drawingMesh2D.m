function drawingMesh2D(nodesCornerX, nodesCornerY, FaceColor, ...
    LineStyle, EdgeColor)
%DRAWINGMESH2D Summary of this function goes here
%   Detailed explanation goes here

for k = 1:size(nodesCornerX, 1)
    patch(nodesCornerX(k, :), nodesCornerY(k, :), 'w', 'FaceColor', FaceColor, ...
        'LineStyle', LineStyle, 'EdgeColor', EdgeColor);
end

end

