function [ElementMat2DK, ElementMat2DM]=ElementMatrices2D(Nodes,p,MatProp,physics)
%{{x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}} -> {{ul}, {ur}, {ol}, {or}} mit den Funktionswerten xi1 und xi2
x1=Nodes(1,1);
x2=Nodes(2,1);
x3=Nodes(3,1);
x4=Nodes(4,1);
y1=Nodes(1,2);
y2=Nodes(2,2);
y3=Nodes(3,2);
y4=Nodes(4,2);
z1=Nodes(1,3);
z2=Nodes(2,3);
z3=Nodes(3,3);
z4=Nodes(4,3);
[IntNodes, IntWeights]=NumIntTabFEM(p);                          %Auslesen der Integrationsstützstellen und Gewichte 
    Emod=MatProp(1);                                                    %Auslesen der Materialeigenschaften aus der "MatProp"-Matrix
    nue=MatProp(2);
    rho=MatProp(3);
    thick=MatProp(4);
    if physics=="PlaneStrain"                                           %Elastiziätsmatrix für den ebenen Verzerrungszustand
    D=Emod/(1+nue)/(1-2*nue)*[ 1-nue nue 0;nue 1-nue 0;0 0 1/2-nue ];
    elseif physics=="PlaneStress"                                       %Elastiziätsmatrix für den ebenen Spannungszustand
    D=Emod/(1-nue^2)*[ 1 nue 0;nue 1 0;0 0 (1-nue)/2 ];     
    end
    ElementMat2DK=zeros(2*(p+1)^2,2*(p+1)^2);                       %Preallokation der Steifigkeitsmatrix
    ElementMat2DM=zeros(2*(p+1)^2,2*(p+1)^2);                       %Preallokation der Massenmatrix
    GradMat=zeros(3,(p+1)^2*2);                                         %Preallokation der B-Matrix (enthält Ableitungen der Formfunktionen)
    NMat=zeros(2,(p+1)^2*2);                                            %Preallokation der N-Matrix (enthält die Formfunktionen)
    for i=1:(p+1)^2                                                     %Schleife von i=1 bis Anzahl der Knoten pro Element
        GradMat0=InvJacobiTQuad(IntNodes(i,1),IntNodes(i,2), x1, x2, x3, x4, y1, y2, y3, y4)*LagrangeQBasisFunGrad2D(p,IntNodes(i,1),IntNodes(i,2));
        GradMat(1,1:2:(p+1)^2*2-1)=GradMat0(1,:);
        GradMat(2,2:2:(p+1)^2*2)=GradMat0(2,:);
        GradMat(3,1:2:(p+1)^2*2-1)=GradMat0(2,:);
        GradMat(3,2:2:(p+1)^2*2)=GradMat0(1,:);
        NMat(1,1:2:(p+1)^2*2-1)=LagrangeQBasisFun2D(p,IntNodes(i,1),IntNodes(i,2));
        NMat(2,2:2:(p+1)^2*2)=LagrangeQBasisFun2D(p,IntNodes(i,1),IntNodes(i,2));
        ElementMat2DK=ElementMat2DK+transpose(GradMat)*D*GradMat*DetJacobiQ(IntNodes(i,1),IntNodes(i,2), x1, x2, x3, x4, y1, y2, y3, y4)*IntWeights(i)*thick;
        ElementMat2DM=ElementMat2DM+transpose(NMat)*NMat*DetJacobiQ(IntNodes(i,1),IntNodes(i,2), x1, x2, x3, x4, y1, y2, y3, y4)*IntWeights(i)*thick*rho;
    end           
end