function [kRe,kIm,kCom] = filterCBS_2DFEM(kixy)
% kixy=kxSCGX; %testmatrix
kiIm=imag(kixy);
[row,col]=find(abs(kiIm)>=10);
sub2index=sub2ind(size(kiIm),row,col);
kixy(sub2index)=(-10-10*sqrt(-1));
% kixy0=kixy.*[real(kixy)>=0&real(kixy)<round(pi,2)];
% kixy0=kixy.*[real(kixy)>=0];
% kixy0=sort(kixy0,1);
kixy0=sort(kixy,1);
kixy1 = kixy0(any(kixy0,2),:);
[row2,col2]=find(round(abs(imag(kixy1)),3)==0&round(abs(real(kixy1)),3)>0);
[row3,col3]=find(round(abs(imag(kixy1)),3)>0&round(abs(real(kixy1)),3)==0);
[row4,col4]=find(round(abs(imag(kixy1)),3)>0&round(abs(real(kixy1)),3)>0);
kRe0=ones(size(kixy1))*(-10-10*sqrt(-1));
kIm0=ones(size(kixy1))*(-10-10*sqrt(-1));
kCom0=ones(size(kixy1))*(-10-10*sqrt(-1));
indRe0=sub2ind(size(kixy1),row2,col2);
indIm0=sub2ind(size(kixy1),row3,col3);
indCom0=sub2ind(size(kixy1),row4,col4);
kRe0(indRe0)=kixy1(indRe0);
kIm0(indIm0)=kixy1(indIm0);
kCom0(indCom0)=kixy1(indCom0);
kRe=kRe0;
kIm=kIm0;
kCom=kCom0;