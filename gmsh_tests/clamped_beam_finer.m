%  Matlab mesh
% clamped_beam, Created by Gmsh
% ASCII
clear msh;
msh.nbNod = 15;
msh.POS = [
0 0 0;
5 0 0;
5 1 0;
0 1 0;
5 0.5 0;
2.5 1 0;
1.25 1 0;
3.75 1 0;
0 0.5 0;
2.5 0 0;
1.25 0 0;
3.75 0 0;
2.5 0.5 0;
1.25 0.5 0;
3.75 0.5 0;
];
msh.MAX = max(msh.POS);
msh.MIN = min(msh.POS);
msh.LINES =[
 2 5 0
 5 3 0
 3 8 0
 8 6 0
 6 7 0
 7 4 0
 4 9 0
 9 1 0
 1 11 0
 11 10 0
 10 12 0
 12 2 0
];
msh.QUADS =[
 6 7 14 13 0
 10 13 14 11 0
 1 11 14 9 0
 4 9 14 7 0
 2 5 15 12 0
 10 12 15 13 0
 6 13 15 8 0
 3 8 15 5 0
];
msh.PNT =[
 1 0
 2 0
 3 0
 4 0
];
