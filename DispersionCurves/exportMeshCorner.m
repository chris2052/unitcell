function exportMeshCorner(FileName, nodesCornerX, nodesCornerY)
%EXPORTMESHCORNER Summary of this function goes here
%   Detailed explanation goes here

fileId = fopen(FileName, 'w');

for n = 1:size(nodesCornerX)
    xx = [nodesCornerX(n,:), nodesCornerX(n,1)];
    yy = [nodesCornerY(n,:), nodesCornerY(n,1)];
    xy = [xx; yy];
    fprintf(fileId, '%f %f\n', xy);
    fprintf(fileId, '\n');
end

fclose(fileId);

end