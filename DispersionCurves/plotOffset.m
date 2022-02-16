function plotOffset(axHandle, xOffset, yOffset)
%PLOTOFFSET Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    axHandle.XRuler.TickLabelGapOffset = xOffset;
    axHandle.YRuler.TickLabelGapOffset = xOffset;
else
    axHandle.XRuler.TickLabelGapOffset = xOffset;
    axHandle.YRuler.TickLabelGapOffset = yOffset;
end

end

