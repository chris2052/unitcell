function plotTickDelta(axHandle, xyAxis, delta, offset)
    %PLOTTICKDELTA Summary of this function goes here
    %   Detailed explanation goes here

switch xyAxis 

    case 'x'
	    label = get(axHandle, 'XTickLabel');
        
    case 'y'
	    label = get(axHandle, 'YTickLabel');

end

newLabel = cell(size(label));

if nargin < 4

    for n = delta:delta:size(label, 1)
    
        newLabel(n) = label(n);
    
    end

else

    for n = offset:delta:size(label, 1)
    
        newLabel(n) = label(n);
    
    end

end 

switch xyAxis 

    case 'x'
	    set(axHandle, 'XTickLabel', newLabel);

    case 'y'
	    set(axHandle, 'YTickLabel', newLabel);

end