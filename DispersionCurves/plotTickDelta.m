function plotTickDelta(axHandle, xyAxis, delta)
    %PLOTTICKDELTA Summary of this function goes here
    %   Detailed explanation goes here

switch xyAxis 

    case 'x'
	    label = get(axHandle, 'XTickLabel');
        
    case 'y'
	    label = get(axHandle, 'YTickLabel');

end

newLabel = cell(size(label));

for n = delta:delta:size(label, 1)

    newLabel(n) = label(n);

end

switch xyAxis 

    case 'x'
	    set(axHandle, 'XTickLabel', newLabel);

    case 'y'
	    set(axHandle, 'YTickLabel', newLabel);

end