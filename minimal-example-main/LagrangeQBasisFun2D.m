function phi2Dequi = LagrangeQBasisFun2D(p,xi1,xi2)
        if p==1
        phi2Dequi(1,1)=(1-xi1)*(1-xi2);
        phi2Dequi(1,2)=xi1*(1-xi2);
        phi2Dequi(1,3)=xi2*(1-xi1);
        phi2Dequi(1,4)=xi1*xi2;
        elseif p==2
        phi2Dequi(1,1)=4*(1-xi1)*(-(1/2)+xi1)*(1-xi2)*(-(1/2)+xi2);
        phi2Dequi(1,2)=8*(-1+xi1)*xi1*(1-xi2)*(-(1/2)+xi2);
        phi2Dequi(1,3)=-4*(-(1/2)+xi1)*xi1*(1-xi2)*(-(1/2)+xi2);
        phi2Dequi(1,4)=8*(1-xi1)*(-(1/2)+xi1)*(-1+xi2)*xi2;
        phi2Dequi(1,5)=16*(-1+xi1)*xi1*(-1+xi2)*xi2;
        phi2Dequi(1,6)=-8*(-(1/2)+xi1)*xi1*(-1+xi2)*xi2;
        phi2Dequi(1,7)=-4*(1-xi1)*(-1/2+xi1)*(-1/2+xi2)*xi2;
        phi2Dequi(1,8)=-8*(-1+xi1)*xi1*(-1/2+xi2)*xi2;
        phi2Dequi(1,9)=4*(-(1/2)+xi1)*xi1*(-(1/2)+xi2)*xi2;
        end
end