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
lc = .1;
l = 1;
//
// boundary
Point(1) = {-l, -l, 0, lc};
Point(2) = {l, -l, 0, lc};
Point(3) = {l, l, 0, lc};
Point(4) = {-l, l, 0, lc};
//
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
//center point
Point(5) = {0, 0, 0, lc};
//
// inner circle points with radius `rIn`
// rIn = .3;
// Point(6) = {rIn, 0, 0, lc};
// Point(7) = {0, rIn, 0, lc};
// Point(8) = {-rIn, 0, 0, lc};
// Point(9) = {0, -rIn, 0, lc};
// //
// Circle(5) = {6, 5, 7};
// Circle(6) = {7, 5, 8};
// Circle(7) = {8, 5, 9};
// Circle(8) = {9, 5, 6};
//
// outer circle points with radius `rOut`
rOut = .5;
Point(10) = {rOut, 0, 0, lc};
Point(11) = {0, rOut, 0, lc};
Point(12) = {-rOut, 0, 0, lc};
Point(13) = {0, -rOut, 0, lc};

Circle(9) = {10, 5, 11};
Circle(10) = {11, 5, 12};
Circle(11) = {12, 5, 13};
Circle(12) = {13, 5, 10};
//
Curve Loop(1) = {4, 1, 2, 3};
Curve Loop(2) = {10, 11, 12, 9};
// Curve Loop(3) = {6, 7, 8, 5};
// outer quad
Plane Surface(1) = {1, 2};
Physical Surface("outerQuad", 1) = {1};
// outer circ
Plane Surface(2) = {2};
// Plane Surface(2) = {2, 3};
Physical Surface("outerCirc", 2) = {2};
// inner circ
// Plane Surface(3) = {3};
// Physical Surface("innerCirc", 3) = {3};
//
Periodic Curve{2} = {4} Translate{2*l, 0, 0};
Periodic Curve{3} = {1} Translate{0, 2*l, 0};
//
Mesh.ElementOrder = 2;