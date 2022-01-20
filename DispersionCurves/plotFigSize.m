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