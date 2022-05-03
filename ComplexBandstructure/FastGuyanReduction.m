function [KR,MR,DR,T,Kss]=FastGuyanReduction(K,M,D,SlaveDofs)
%  Guyan reduction or Static reduction
%  with this method, the reduced model tries to reproduce
%  the natural freq.s of full model.
%
% K , M , D: Full order stiffness & Mass Matrices
% SlaveDofs : Dofs to be deattached from system
% KR, MR,Dr : Reduced stiffness & Mass Matrices
% T : Transformation Matrix
% Kss : Slave Stiffness Matrix
% 
% Example:
% k = [2 3 5;6 7 8;3 2 1];
% [kr,~,~,~,Tr,~] = GuyanReduction(k,k,k,1)
%
% Original file by
% Keegan J. Moore
% University of Illinois at Urbana-Champaign
% 03/03/2017
% Inspired by http://www.mathworks.com/matlabcentral/fileexchange/12504-guyan-reduction
% Optimized file by
% Marius Mellmann
% University of Siegen, Germany
% 13.03.2022

Dof = length(K(:,1));
SlaveDofs = sort(SlaveDofs);
DofSlave=size(SlaveDofs,2);
index = 1:Dof;
index(SlaveDofs) = [];

% indK1=sub2ind([Dof,Dof],repmat(SlaveDofs',1,DofSlave),repmat(SlaveDofs,DofSlave,1));
% indKss=sub2ind([DofSlave,DofSlave],repmat([1:DofSlave]',1,DofSlave),repmat(1:DofSlave,DofSlave,1));
% Kvec1=reshape(K(indK1),[],1);
Kvec1=reshape(K(sub2ind([Dof,Dof],repmat(SlaveDofs',1,DofSlave),repmat(SlaveDofs,DofSlave,1))),[],1);
% [rowKss,colKss]=ind2sub([DofSlave,DofSlave],reshape(indKss,[],1));
[rowKss,colKss]=ind2sub([DofSlave,DofSlave],reshape(sub2ind([DofSlave,DofSlave],repmat([1:DofSlave]',1,DofSlave),repmat(1:DofSlave,DofSlave,1)),[],1));
Kss=sparse(rowKss,colKss,Kvec1,DofSlave,DofSlave);
% indK2=sub2ind([Dof,Dof],repmat(SlaveDofs',1,Dof-DofSlave),repmat(index,DofSlave,1));
% indKsm=sub2ind([DofSlave,length(index)],repmat([1:DofSlave]',1,length(index)),repmat(1:length(index),DofSlave,1));
% Kvec2=reshape(K(indK2),[],1);
Kvec2=reshape(K(sub2ind([Dof,Dof],repmat(SlaveDofs',1,Dof-DofSlave),repmat(index,DofSlave,1))),[],1);
% [rowKsm,colKsm]=ind2sub([DofSlave,length(index)],reshape(indKsm,[],1));
[rowKsm,colKsm]=ind2sub([DofSlave,length(index)],reshape(sub2ind([DofSlave,length(index)],repmat([1:DofSlave]',1,length(index)),repmat(1:length(index),DofSlave,1)),[],1));
Ksm=sparse(rowKsm,colKsm,Kvec2,DofSlave,length(index));

P = - inv(Kss) * Ksm;
T = zeros(length(M),length(index));
T(SlaveDofs,:) = P;
T(index,:) = eye(length(index));
MR = T'*M*T;
KR = T'*K*T;
DR = T'*D*T;