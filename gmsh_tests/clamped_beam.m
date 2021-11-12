%  Matlab mesh
% clamped_beam, Created by Gmsh
% ASCII
clear msh;
msh.nbNod = 9;
msh.POS = [
0 0 0;
5 0 0;
5 1 0;
0 1 0;
5 0.5 0;
2.5 1 0;
0 0.5 0;
2.5 0 0;
2.5 0.5 0;
];
msh.MAX = max(msh.POS);
msh.MIN = min(msh.POS);
msh.LINES =[
 2 5 0
 5 3 0
 3 6 0
 6 4 0
 4 7 0
 7 1 0
 1 8 0
 8 2 0
];
msh.QUADS =[
 2 5 9 8 0
 1 8 9 7 0
 4 7 9 6 0
 3 6 9 5 0
];
msh.PNT =[
 1 0
 2 0
 3 0
 4 0
];
