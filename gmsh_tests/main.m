clearvars; close all; clc;

clamped_beam;

numEl = size(msh.QUADS,1);

% % 2 5 9 8
% elem = [
%     5, 0, 0;
%     5, 0.5, 0;
%     2.5, 0.5, 0;
%     2.5, 0, 0
% ];
% 
% elemXX = elem(:,1);
% elemYY = elem(:,2);

% f = figure(1);
% f.Position = [2500 360 560 420];
% ax = axes;

nodes = msh.POS;
conn = msh.QUADS;

elemNodes = zeros(4, 3);
for n = 1:4
    elemNodes(n, :) = msh.POS(msh.QUADS(1, n), :);
end
