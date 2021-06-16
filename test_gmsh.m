% generate filename
filename = 'newertest';
fileid = fopen([filename, '.geo'],'w');
domainPid = 10;

% force to use legacy *.msh output
fprintf(fileid, 'Mesh.MshFileVersion = 2.2;');

% set characteristic length
fprintf(fileid, 'lc = .1;\n');

% set cell length
fprintf(fileid, 'l = 1;\n');

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

fclose(fileid);

% generate mesh --> *.msh, -2 (2D); alias >> !gmsh filename.geo -2
status = system(['gmsh ', filename, '.geo', ' -2']);

% open mesh with Gmsh; alias >> !gmsh geofile.msh
% status = system(['gmsh ', filename, '.msh']); 