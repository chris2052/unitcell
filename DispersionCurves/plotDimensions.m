function plotDimensions(axHandle, figHandle, xDim, yDim, factor, angle)
%PLOTDIMENSIONS set dimensions of current figure-window xDim x yDim
%   factor <= 1:    fill factor of axis
%   angle:          angle of x-ticks (leave empty if not needed)

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

plotFigSize(axHandle, figHandle)

end



function plotFigSize(axHandle, figHandle)
%PLOTFIGSIZE displays the real dimensions of the axis in [cm]

inPos = axHandle.InnerPosition;
dx = inPos(3);
dy = inPos(4);

figHandle.Units = 'centimeters';
WinSize = figHandle.PaperSize;
figSize = [WinSize(1)*dx, WinSize(2)*dy];

fprintf('figure size: %3.1f x %3.1f [cm]\n', figSize(1), figSize(2))

end