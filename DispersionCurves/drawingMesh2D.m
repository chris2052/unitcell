function drawingMesh2D(nodesCornerX, nodesCornerY, FaceColor, ...
    LineStyle, EdgeColor)
    %DRAWINGMESH2D Summary of this function goes here
    %   Detailed explanation goes here

    meshFigure = figure;
    meshFigure.Units = 'centimeters';
    meshFigure.Position = [20, 8, 10, 10];
    
    meshAxis = axes;
    meshAxis.Position = [0, 0, 1, 1];
    meshAxis.XColor = 'none';
    meshAxis.YColor = 'none';
    axis(meshAxis, 'equal')
    
    for k = 1:size(nodesCornerX, 1)
        patch(meshAxis, nodesCornerX(k, :), nodesCornerY(k, :), 'w', 'FaceColor', ...
            FaceColor, 'LineStyle', LineStyle, 'EdgeColor', EdgeColor);
    end

end