function getTrans(transData)
%GETTRANS Summary of this function goes here
%   Detailed explanation goes here

transFig = figure;

transFig.Units = 'centimeters';
transFig.Position = [20, 10, 4, 8];

transAx = axes(transFig);
transAx.Position = [0.1 0.1 0.8 0.8];

transAx.Box = 'on';

plot(transData(:,2), transData(:,1), '-k')

xlabel(transAx, 'Transmission $[\unit(dB)]$','interpreter', 'none')


grid(transAx, 'on');

set(transAx, 'yticklabel',[])

end