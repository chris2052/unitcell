function Dphi2Dequi = LagrangeQBasisFunGrad2D(p,xi1,xi2)
        if p==1
        Dphi2Dequi(:,1)=[-1+xi2;-1+xi1];
        Dphi2Dequi(:,2)=[1-xi2;-xi1];
        Dphi2Dequi(:,3)=[-xi2;1-xi1];
        Dphi2Dequi(:,4)=[xi2;xi1];
        elseif p==2
        Dphi2Dequi(:,1)=[4*(1-xi1)*(1-xi2)*(-(1/2)+xi2)-4*(-(1/2)+xi1)*(1-xi2)*(-(1/2)+xi2);4*(1-xi1)*(-(1/2)+xi1)*(1-xi2)-4*(1-xi1)*(-(1/2)+xi1)*(-(1/2)+xi2)];
        Dphi2Dequi(:,2)=[8*(-1+xi1)*(1-xi2)*(-(1/2)+xi2)+8*xi1*(1-xi2)*(-(1/2)+xi2);8*(-1+xi1)*xi1*(1-xi2)-8*(-1+xi1)*xi1*(-(1/2)+xi2)];
        Dphi2Dequi(:,3)=[-4*(-(1/2)+xi1)*(1-xi2)*(-(1/2)+xi2)-4*xi1*(1-xi2)*(-(1/2)+xi2);-4*(-(1/2)+xi1)*xi1*(1-xi2)+4*(-(1/2)+xi1)*xi1*(-(1/2)+xi2)];
        Dphi2Dequi(:,4)=[8*(1-xi1)*(-1+xi2)*xi2-8*(-(1/2)+xi1)*(-1+xi2)*xi2;8*(1-xi1)*(-(1/2)+xi1)*(-1+xi2)+8*(1-xi1)*(-(1/2)+xi1)*xi2];
        Dphi2Dequi(:,5)=[16*(-1+xi1)*(-1+xi2)*xi2+16*xi1*(-1+xi2)*xi2;16*(-1+xi1)*xi1*(-1+xi2)+16*(-1+xi1)*xi1*xi2];
        Dphi2Dequi(:,6)=[-8*(-(1/2)+xi1)*(-1+xi2)*xi2-8*xi1*(-1+xi2)*xi2;-8*(-(1/2)+xi1)*xi1*(-1+xi2)-8*(-(1/2)+xi1)*xi1*xi2];
        Dphi2Dequi(:,7)=[-4*(1-xi1)*(-(1/2)+xi2)*xi2+4*(-(1/2)+xi1)*(-(1/2)+xi2)*xi2;-4*(1-xi1)*(-(1/2)+xi1)*(-(1/2)+xi2)-4*(1-xi1)*(-(1/2)+xi1)*xi2];
        Dphi2Dequi(:,8)=[-8*(-1+xi1)*(-(1/2)+xi2)*xi2-8*xi1*(-(1/2)+xi2)*xi2;-8*(-1+xi1)*xi1*(-(1/2)+xi2)-8*(-1+xi1)*xi1*xi2];
        Dphi2Dequi(:,9)=[4*(-(1/2)+xi1)*(-(1/2)+xi2)*xi2+4*xi1*(-(1/2)+xi2)*xi2;4*(-(1/2)+xi1)*xi1*(-(1/2)+xi2)+4*(-(1/2)+xi1)*xi1*xi2];
        end      
end