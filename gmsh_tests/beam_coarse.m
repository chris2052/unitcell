%  Matlab mesh
% clamped_beam, Created by Gmsh
% ASCII
clear msh;
msh.nbNod = 65;
msh.POS = [
0 0 0;
5 0 0;
5 1 0;
0 1 0;
1.666666666666667 0 0;
3.333333333333333 0 0;
4.166666666666667 0 0;
2.5 0 0;
0.8333333333333334 0 0;
0.4166666666666667 0 0;
1.25 0 0;
2.083333333333333 0 0;
2.916666666666667 0 0;
3.75 0 0;
4.583333333333333 0 0;
5 0.5 0;
5 0.25 0;
5 0.75 0;
3.333333333333333 1 0;
1.666666666666667 1 0;
4.166666666666667 1 0;
2.5 1 0;
0.833333333333333 1 0;
4.583333333333333 1 0;
3.75 1 0;
2.916666666666667 1 0;
2.083333333333333 1 0;
1.25 1 0;
0.416666666666667 1 0;
0 0.5 0;
0 0.75 0;
0 0.25 0;
3.333333333333333 0.5 0;
4.166666666666667 0.5 0;
1.666666666666667 0.5 0;
2.5 0.5 0;
0.833333333333333 0.5 0;
4.583333333333334 0.5 0;
4.166666666666667 0.25 0;
4.583333333333333 0.25 0;
3.75 0.5 0;
3.333333333333333 0.25 0;
3.75 0.25 0;
3.333333333333333 0.75 0;
4.166666666666667 0.75 0;
3.75 0.75 0;
4.583333333333334 0.75 0;
2.5 0.25 0;
2.083333333333333 0.5 0;
1.666666666666667 0.25 0;
2.083333333333333 0.25 0;
1.666666666666667 0.75 0;
2.5 0.75 0;
2.083333333333333 0.75 0;
2.916666666666667 0.5 0;
2.916666666666667 0.75 0;
2.916666666666667 0.25 0;
0.833333333333333 0.75 0;
1.25 0.5 0;
1.25 0.75 0;
0.8333333333333333 0.25 0;
1.25 0.25 0;
0.4166666666666665 0.5 0;
0.4166666666666661 0.25 0;
0.416666666666667 0.75 0;
];
msh.MAX = max(msh.POS);
msh.MIN = min(msh.POS);
msh.LINES3 =[
 1 9 10 13
 9 5 11 13
 5 8 12 13
 8 6 13 13
 6 7 14 13
 7 2 15 13
 2 16 17 12
 16 3 18 12
 3 21 24 14
 21 19 25 14
 19 22 26 14
 22 20 27 14
 20 23 28 14
 23 4 29 14
 4 30 31 11
 30 1 32 11
];
msh.QUADS9 =[
 2 16 34 7 17 38 39 15 40 1
 6 7 34 33 14 39 41 42 43 1
 19 33 34 21 44 41 45 25 46 1
 3 21 34 16 24 45 38 18 47 1
 5 8 36 35 12 48 49 50 51 1
 20 35 36 22 52 49 53 27 54 1
 19 22 36 33 26 53 55 44 56 1
 6 33 36 8 42 55 48 13 57 1
 20 23 37 35 28 58 59 52 60 1
 5 35 37 9 50 59 61 11 62 1
 1 9 37 30 10 61 63 32 64 1
 4 30 37 23 31 63 58 29 65 1
];
