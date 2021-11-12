SetFactory("OpenCASCADE");
//
// Frontal-Delauny
Mesh.Algorithm = 8;
// Blossom-full-quad
Mesh.RecombinationAlgorithm = 3;
// all quadrangles
Mesh.SubdivisionAlgorithm = 0; 
//
Mesh.RecombineAll = 1;
//
lc = 4;
//
Point(1) = {0, 0, 0, lc};
Point(4) = {0, 1, 0, lc};
Point(3) = {5, 1, 0, lc};
Point(2) = {5, 0, 0, lc};
//
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
//
Curve Loop(1) = {1, 2, 3, 4};
//
Plane Surface(1) = {1};
