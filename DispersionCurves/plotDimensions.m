function plotDimensions(figHandle, axHandle, xDim, yDim, factor, angle)
%PLOTDIMENSIONS Summary of this function goes here
%   Detailed explanation goes here

figHandle.Units = 'centimeters';
figHandle.Position = [25, 8, xDim, yDim];

figHandle.PaperUnits = 'centimeters';
figHandle.PaperPositionMode = 'manual';
figHandle.PaperSize = [xDim, yDim];
figHandle.PaperPosition = [0, 0, xDim, yDim];
figHandle.Renderer = 'painters';

% centering axis
border = (1 - factor)/2;
axHandle.Position = [border, border, factor, factor ];

% setting angle for xticks
if nargin < 6
    angle = 0;
end

xtickangle(axHandle, angle);

end