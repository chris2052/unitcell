function plotDimensions(fighandle, axhandle, xDim, yDim, factor, angle)
%PLOTDIMENSIONS Summary of this function goes here
%   Detailed explanation goes here

fighandle.Units = 'centimeters';
fighandle.Position = [25, 8, xDim, yDim];

fighandle.PaperUnits = 'centimeters';
fighandle.PaperPositionMode = 'manual';
fighandle.PaperSize = [xDim, yDim];
fighandle.PaperPosition = [0, 0, xDim, yDim];
fighandle.Renderer = 'painters';

% centering axis
border = (1 - factor)/2;
axhandle.Position = [border, border, factor, factor ];

% setting angle for xticks
if nargin < 6
    angle = 0;
end

xtickangle(axhandle, angle);

end