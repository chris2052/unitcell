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
//
Point(1) = {-1, -1, 0, lc};
Point(2) = {1, -1, 0, lc};
Point(3) = {1, 1, 0, lc};
Point(4) = {-1, 1, 0, lc};

Point(5) = {0, 0, 0, lc};

// circle with radius `r`
r = .2;
Point(6) = {r, 0, 0, lc};
Point(7) = {0, r, 0, lc};
Point(8) = {-r, 0, 0, lc};
Point(9) = {0, -r, 0, lc};
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
// Ellipse(5) = {0, -0, 0, 0.5, 0.3, 0, 2*Pi};
//
Curve Loop(1) = {1, 2, 3, 4};
Curve Loop(2) = {5, 6, 7, 8};
//
Curve Loop(3) = {4, 1, 2, 3};
Curve Loop(4) = {6, 7, 8, 5};
Plane Surface(1) = {3, 4};
//
Curve Loop(5) = {6, 7, 8, 5};
Plane Surface(2) = {5};
