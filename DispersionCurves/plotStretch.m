function plotStretch(axHandle, stretchX, stretchY)
%PLOTSTRETCH Summary of this function goes here
%   Detailed explanation goes here

innerPos = get(axHandle, 'InnerPosition');
[dx, dy] = deal(innerPos(3), innerPos(4));

dx = dx*stretchX;
x0 = (1 - dx)/2; 
dy = dy*stretchY;
y0 = (1 - dy)/2;

set(axHandle, 'InnerPosition', [x0, y0, dx, dy]);

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