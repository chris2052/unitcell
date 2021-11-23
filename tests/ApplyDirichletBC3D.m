function [Kred,IdxDBC,DBCPresc, RHS]=ApplyDirichletBC3D(K,di,DirichletLineBC,DirichletPointBC,Nodes,minNodeDist)
numDircBCLine=size(DirichletLineBC,1)*[size(DirichletLineBC,2)>1];
numDircBCPoint=size(DirichletPointBC,1)*[size(DirichletPointBC,2)>1];
mindDist=minNodeDist;%max(min(min(pdist(Nodes))),0.001);
if numDircBCLine>0
%      IdxDLineBC=spalloc(numDircBCLine,size(Nodes,1),round(sqrt(size(Nodes,1)),0));
%      DBCLinePresc=spalloc(numDircBCLine,size(Nodes,1),round(sqrt(size(Nodes,1)),0));
sizeIdx=1;
sizePresc=1;
for i=1:numDircBCLine
    DBC0=DirichletLineBC(i,:);
    length=sqrt((DBC0(4)-DBC0(1))^2+(DBC0(5)-DBC0(2))^2+(DBC0(6)-DBC0(3))^2);
    DBCVecY=linspace(DBC0(2),DBC0(5),round(length/(mindDist*0.25),0))';
    DBCVecX=linspace(DBC0(1),DBC0(4),round(length/(mindDist*0.25),0))';
    DBCVecZ=linspace(DBC0(3),DBC0(6),round(length/(mindDist*0.25),0))';
    DBCVec=[ones(round(length/(mindDist*0.25),0),3)'.*[DBC0(1) DBC0(2) DBC0(3)]']';
    DBCVec(1:size(DBCVecX),1)= DBCVecX;
    DBCVec(1:size(DBCVecY),2)= DBCVecY;
    DBCVec(1:size(DBCVecZ),3)= DBCVecZ;
    Idx00=rangesearch(Nodes,DBCVec,mindDist);
    Idx00=Idx00(~cellfun('isempty',Idx00));
    Idx0=cell2mat(Idx00);
    Idx0=unique(Idx0)';
    Presc0=repmat(reshape([DirichletLineBC(i,7:end)]',1,[]),1,size(Idx0,2));
    IdxDLineBC(1,sizeIdx:sizeIdx+size(Idx0,2)-1)=Idx0;
    DBCLinePresc(1,sizePresc:sizePresc+size(Presc0,2)-1)=Presc0;
    sizeIdx=sizeIdx+size(Idx0,2);
    sizePresc=sizePresc+size(Presc0,2);
end
%Delete doubles
[IdxDLineBC, iaIdxLine, ~]=unique(IdxDLineBC,'stable');
iaIdxLinePresc=reshape([repmat(iaIdxLine,1,di)*di-repmat([di-1:-1:0],size(iaIdxLine,1),1)]',[],1);
DBCLinePresc=DBCLinePresc(iaIdxLinePresc);
%-----
IdxDBCLinedi=reshape(repmat(IdxDLineBC,di,1)*di-repmat(fliplr([0:di-1])',1,size(IdxDLineBC,1)),[],1)';
delNANLine=find(isnan(DBCLinePresc));
DBCLinePresc(delNANLine)=[];
IdxDBCLinedi(delNANLine)=[];
end
if numDircBCPoint>0
IdxDPointBC=unique(knnsearch(Nodes,DirichletPointBC(:,1:3)));
IdxDBCPointdi=reshape(repmat(IdxDPointBC',di,1)*di-repmat(fliplr([0:di-1])',1,size(IdxDPointBC,1)),[],1)';
DBCPointPresc=reshape([DirichletPointBC(:,4:end)]',1,[]);
delNANPoint=find(isnan(DBCPointPresc));
DBCPointPresc(delNANPoint)=[];
IdxDBCPointdi(delNANPoint)=[];
end
if numDircBCPoint>0 && numDircBCLine>0
IdxDBC=[IdxDBCLinedi;IdxDBCPointdi];
DBCPresc=[DBCLinePresc;DBCPointPresc];
elseif numDircBCPoint>0 && numDircBCLine==0
IdxDBC=IdxDBCPointdi;
DBCPresc=DBCPointPresc;
elseif numDircBCPoint==0 && numDircBCLine>0
IdxDBC=IdxDBCLinedi;
DBCPresc=DBCLinePresc;
end
RHS=-[K(:,IdxDBC)].*repmat(DBCPresc,size(K,1),1); 
RHS=sum(RHS,2);
Kred=K;
Kred(IdxDBC,:)=[];
Kred(:,IdxDBC)=[];
RHS(IdxDBC)=[];
end