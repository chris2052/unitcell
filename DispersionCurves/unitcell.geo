SetFactory("OpenCASCADE");
Mesh.Algorithm = 8;
Mesh.RecombinationAlgorithm = 1;
Mesh.SubdivisionAlgorithm = 0; 
Mesh.RecombineAll = 1;
lc = 2.000000e-02;
l = 5.000000e-02;
Point(1) = {-l, -l, 0, lc};
Point(2) = {l, -l, 0, lc};
Point(3) = {l, l, 0, lc};
Point(4) = {-l, l, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
// Physical Line("left", 4) = {4};
// Physical Line("right", 2) = {2};
// Physical Line("bottom", 1) = {1};
// Physical Line("top", 3) = {3};
Point(5) = {0, 0, 0, lc};
rOut = 3.750000e-02;
Point(10) = {rOut, 0, 0, lc};
Point(11) = {0, rOut, 0, lc};
Point(12) = {-rOut, 0, 0, lc};
Point(13) = {0, -rOut, 0, lc};
Circle(9) = {10, 5, 11};
Circle(10) = {11, 5, 12};
Circle(11) = {12, 5, 13};
Circle(12) = {13, 5, 10};
Curve Loop(1) = {4, 1, 2, 3};
Curve Loop(2) = {10, 11, 12, 9};


Plane Surface(1) = {1, 2};
Plane Surface(2) = {2};

Recombine Surface{1};
Recombine Surface{2};

BooleanFragments{Surface{1,2}; Delete; }{}


Physical Surface("outerQuad", 1) = {1};
Physical Surface("outerCirc", 2) = {2};
Periodic Curve{2} = {4} Translate{2*l, 0, 0};
Periodic Curve{3} = {1} Translate{0, 2*l, 0};
Mesh.ElementOrder = 2;


