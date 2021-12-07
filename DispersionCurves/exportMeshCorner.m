function exportMeshCorner(FileName, nodesCornerX, nodesCornerY, dispCorner)
%EXPORTMESHCORNER Summary of this function goes here
%   Detailed explanation goes here

fileId = fopen(FileName, 'w');

for n = 1:size(nodesCornerX)
    xx = [nodesCornerX(n,:), nodesCornerX(n,1)];
    yy = [nodesCornerY(n,:), nodesCornerY(n,1)];
    dd = [dispCorner(n,:), dispCorner(n,1)];
    xy = [xx; yy; dd];
    fprintf(fileId, '%f %f %.16e\n', xy);
    fprintf(fileId, '\n');
end

fclose(fileId);

end