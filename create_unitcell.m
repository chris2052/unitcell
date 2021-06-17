function create_unitcell(filename, l, lc, domainPid)
%CREATE_UNITCELL creates a unitcell with gmsh
%   creates and executes gmsh *.geo-file for 2D mesh
%
%   filename - string for filename (*.geo added automatic)
%   l - length of each side
%   lc - target mesh size
%   (domainPid - default set to 10)

if (nargin < 4)
   domainPid = 10;
end

% generate filename
fileid = fopen([filename, '.geo'],'w');

% test with loop
% id = [1,2,3,4,lc];
% for i = 1:4
% fprintf(fileID,'Point(%d) = {%d,%d,%d,%d};\n',i*id);
% end

% force to use legacy *.msh output
fprintf(fileid, 'Mesh.MshFileVersion = 2.2;\n');
fprintf(fileid, 'Mesh.Algorithm = 8;\n');

% set characteristic length
fprintf(fileid, 'lc = %d;\n', lc);

% set cell length
fprintf(fileid, 'l = %d;\n', l);

% define geometry elements
fprintf(fileid, 'Point(1) = {0, 0, 0, lc};\n');
fprintf(fileid, 'Point(2) = {l, 0, 0, lc};\n');
fprintf(fileid, 'Point(3) = {l, l, 0, lc};\n');
fprintf(fileid, 'Point(4) = {0, l, 0, lc};\n');

fprintf(fileid, 'Line(1) = {1, 2};\n');
fprintf(fileid, 'Line(2) = {2, 3};\n');
fprintf(fileid, 'Line(3) = {3, 4};\n');
fprintf(fileid, 'Line(4) = {4, 1};\n');

fprintf(fileid, 'Curve Loop(1) = {1, 2, 3, 4};\n');

fprintf(fileid, 'Plane Surface(1) = {1};\n');

fprintf(fileid, 'Physical Surface(%d) = {1};\n', domainPid);

fprintf(fileid, 'Recombine Surface{%d};\n', domainPid);

fclose(fileid);

% generate mesh --> *.msh, -2 (2D); alias >> !gmsh filename.geo -2
status = system(['gmsh ', filename, '.geo', ' -2 -order 2']);

% open mesh with Gmsh; alias >> !gmsh geofile.msh
% status = system(['gmsh ', filename, '.msh']); 
end

