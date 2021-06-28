function DetJac = DetJacobiQ(xi1, xi2, x1, x2, x3, x4, y1, y2, y3, y4)
DetJac=-x2*y1+x3*y1-x3*xi1*y1+x4*xi1*y1+x2*xi2*y1-x4*xi2*y1+x1*y2-x3*y2+x3*xi1*y2-x4*xi1*y2-x1*xi2*y2+x3*xi2*y2-x1*y3+x2*y3+x1*xi1*y3-x2*xi1*y3-x2*xi2*y3+x4*xi2*y3-x1*xi1*y4+x2*xi1*y4+x1*xi2*y4-x3*xi2*y4;
end