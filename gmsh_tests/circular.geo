SetFactory("OpenCASCADE");
//
// Frontal-Delauny
Mesh.Algorithm = 8;
// Blossom-full-quad
Mesh.RecombinationAlgorithm = 1;
// all quadrangles
Mesh.SubdivisionAlgorithm = 0; 
//
Mesh.RecombineAll = 1;
//
// boundary points
lc = .1;
l = 1;
//
Point(1) = {-l, -l, 0, lc};
Point(2) = {l, -l, 0, lc};
Point(3) = {l, l, 0, lc};
Point(4) = {-l, l, 0, lc};
//center point
Point(5) = {0, 0, 0, lc};
//
// inner circle points with radius `r1`
r1 = .3;
Point(6) = {r1, 0, 0, lc};
Point(7) = {0, r1, 0, lc};
Point(8) = {-r1, 0, 0, lc};
Point(9) = {0, -r1, 0, lc};
//
// outer circle points with radius `r2`
r2 = .5;
Point(10) = {r2, 0, 0, lc};
Point(11) = {0, r2, 0, lc};
Point(12) = {-r2, 0, 0, lc};
Point(13) = {0, -r2, 0, lc};
//
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
//
Circle(5) = {6, 5, 7};
Circle(6) = {7, 5, 8};
Circle(7) = {8, 5, 9};
Circle(8) = {9, 5, 6};

Circle(9) = {10, 5, 11};
Circle(10) = {11, 5, 12};
Circle(11) = {12, 5, 13};
Circle(12) = {13, 5, 10};
// Ellipse(5) = {0, -0, 0, 0.5, 0.3, 0, 2*Pi};
//
Curve Loop(1) = {4, 1, 2, 3};
Curve Loop(2) = {10, 11, 12, 9};
Plane Surface(1) = {1, 2};
//
Curve Loop(4) = {6, 7, 8, 5};
Plane Surface(2) = {2, 4};
//
Curve Loop(5) = {6, 7, 8, 5};
Plane Surface(3) = {5};
//
Periodic Curve{2} = {4} Translate{2*l, 0, 0};
Periodic Curve{3} = {1} Translate{0, 2*l, 0};
//
Mesh.ElementOrder = 2;
//
