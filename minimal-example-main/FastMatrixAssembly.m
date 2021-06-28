function [K, M]=FastMatrixAssembly(Elements)  

NElements=length(Elements);
mk=0;
NDOFs=0;

for i=1:1:NElements
       
NN=Elements{i}.DOFs;
k=Elements{i}.K;
m=Elements{i}.M;
NDOFElement=length(NN);
M=meshgrid(1:NDOFElement)';M2=M';
ii=M(:);
jj=M2(:);
kk=1:NDOFElement^2;  
kkk=kk+mk; 
mk=mk+NDOFElement^2;

Ig(kkk)=NN(ii);
Jg(kkk)=NN(jj);
Kg(kkk)=k(:);
Mg(kkk)=m(:);

NDOFs2=max(Elements{i}.DOFs);
if NDOFs<NDOFs2; NDOFs=NDOFs2; end

end

K=sparse(Ig,Jg,Kg,NDOFs,NDOFs);
M=sparse(Ig,Jg,Mg,NDOFs,NDOFs);
    
end
