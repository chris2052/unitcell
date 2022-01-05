function createMeshUnitcell(filename, l1, l2, rOut, rIn, lc, maxMesh, factorMesh)
    %CREATE_UNITCELL creates a unitcell with gmsh
    %   creates and executes gmsh *.geo-file for 2D mesh
    %   skip rIn to create only one circle
    %   rOut >! rIn
    %
    %   filename - string for filename (*.geo added automatic)
    %   lc - target mesh size
    %   l - length of quad sides
    %   rIn - radius of inner circle
    %   rOut - radius of outer circle

    % generate file and open
    fileid = fopen([filename, '.geo'], 'w');

    fprintf(fileid, 'SetFactory("OpenCASCADE");\n');
    fprintf(fileid, 'Mesh.Algorithm = 8;\n');
    fprintf(fileid, 'Mesh.RecombinationAlgorithm = 1;\n');
    fprintf(fileid, 'Mesh.SubdivisionAlgorithm = 1; \n');
    fprintf(fileid, 'Mesh.RecombineAll = 1;\n');

    % set characteristic length
    fprintf(fileid, 'lc = %d;\n', lc);
    fprintf(fileid, 'maxMesh = %d;\n', maxMesh);
    fprintf(fileid, 'factorMesh = %d;\n', factorMesh);

    % set cell length
    fprintf(fileid, 'l1 = %d;\n', l1);
    fprintf(fileid, 'l2 = %d;\n', l2);

    % define quadradic boundary
    fprintf(fileid, 'Point(1) = {-l1/2, -l2/2, 0, lc};\n');
    fprintf(fileid, 'Point(2) = {l1/2, -l2/2, 0, lc};\n');
    fprintf(fileid, 'Point(3) = {l1/2, l2/2, 0, lc};\n');
    fprintf(fileid, 'Point(4) = {-l1/2, l2/2, 0, lc};\n');

    fprintf(fileid, 'Line(1) = {1, 2};\n');
    fprintf(fileid, 'Line(2) = {2, 3};\n');
    fprintf(fileid, 'Line(3) = {3, 4};\n');
    fprintf(fileid, 'Line(4) = {4, 1};\n');

    fprintf(fileid, 'Physical Line("left", 4) = {4};\n');
    fprintf(fileid, 'Physical Line("right", 2) = {2};\n');
    fprintf(fileid, 'Physical Line("bottom", 1) = {1};\n');
    fprintf(fileid, 'Physical Line("top", 3) = {3};\n');

    % center point
    fprintf(fileid, 'Point(5) = {0, 0, 0, lc};\n');

    % outer circle with radius `rOut`
    fprintf(fileid, 'rOut = %d;\n', rOut);
    fprintf(fileid, 'Point(10) = {rOut, 0, 0, lc};\n');
    fprintf(fileid, 'Point(11) = {0, rOut, 0, lc};\n');
    fprintf(fileid, 'Point(12) = {-rOut, 0, 0, lc};\n');
    fprintf(fileid, 'Point(13) = {0, -rOut, 0, lc};\n');

    fprintf(fileid, 'Circle(9) = {10, 5, 11};\n');
    fprintf(fileid, 'Circle(10) = {11, 5, 12};\n');
    fprintf(fileid, 'Circle(11) = {12, 5, 13};\n');
    fprintf(fileid, 'Circle(12) = {13, 5, 10};\n');

    % create curves
    fprintf(fileid, 'Curve Loop(1) = {4, 1, 2, 3};\n');
    fprintf(fileid, 'Curve Loop(2) = {10, 11, 12, 9};\n');

    % outer quad
    fprintf(fileid, 'Plane Surface(1) = {1, 2};\n');
    fprintf(fileid, 'Physical Surface("outerQuad", 1) = {1};\n');

    if rIn > 0
        % inner circle with radius `rIn`
        fprintf(fileid, 'rIn = %d;\n', rIn);
        fprintf(fileid, 'Point(6) = {rIn, 0, 0, lc};\n');
        fprintf(fileid, 'Point(7) = {0, rIn, 0, lc};\n');
        fprintf(fileid, 'Point(8) = {-rIn, 0, 0, lc};\n');
        fprintf(fileid, 'Point(9) = {0, -rIn, 0, lc};\n');

        fprintf(fileid, 'Circle(5) = {6, 5, 7};\n');
        fprintf(fileid, 'Circle(6) = {7, 5, 8};\n');
        fprintf(fileid, 'Circle(7) = {8, 5, 9};\n');
        fprintf(fileid, 'Circle(8) = {9, 5, 6};\n');
        % create curve
        fprintf(fileid, 'Curve Loop(3) = {6, 7, 8, 5};\n');
        % outer circ
        fprintf(fileid, 'Plane Surface(2) = {2, 3};\n');
        fprintf(fileid, 'Physical Surface("outerCirc", 2) = {2};\n');
        % inner circ
        fprintf(fileid, 'Plane Surface(3) = {3};\n');
        fprintf(fileid, 'Physical Surface("innerCirc", 3) = {3};\n');
    else
        % outer circ
        fprintf(fileid, 'Plane Surface(2) = {2};\n');
        fprintf(fileid, 'Physical Surface("outerCirc", 2) = {2};\n');
    end


    fprintf(fileid, 'Periodic Curve{2} = {4} Translate{l1, 0, 0};\n');
    fprintf(fileid, 'Periodic Curve{3} = {1} Translate{0, l2, 0};\n');

    fprintf(fileid, 'Mesh.MeshSizeMin = 0;\n');
    fprintf(fileid, 'Mesh.MeshSizeMax = maxMesh;\n');
    fprintf(fileid, 'Mesh.MeshSizeFactor = factorMesh;\n');

    fprintf(fileid, 'Mesh.ElementOrder = 2;\n');

    fclose(fileid);

    system(['gmsh ', filename, '.geo', ' -2 -o ', filename, 'MESH.m'])
    system(['gmsh ', filename, '.geo', ' -2 -o ', filename, 'MESH.msh'])

end