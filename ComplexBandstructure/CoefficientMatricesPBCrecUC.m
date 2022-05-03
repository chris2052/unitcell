function [K3GX, K4GX,K3XM, K4XM,K1MG, K2MG, K3MG, K3GY, K4GY, K3YM, K4YM]  = ...
    CoefficientMatricesPBCrecUC(Kred,InputIdx,OutputIdx,PBCdiff,theta)
% Marius
%% Calculation of indice vectors 
%
PBCdiff=round(PBCdiff,6);

InputX=InputIdx(PBCdiff(:,1)>0,:);
InputY=InputIdx(PBCdiff(:,2)>0,:);

OutputX=OutputIdx(PBCdiff(:,1)>0,:);
OutputY=OutputIdx(PBCdiff(:,2)>0,:);
[~,InputXYidx]=ismember(InputX,InputY,'rows');

InputXYidx(~any(InputXYidx,2),: ) = [];
InputXY=InputY(InputXYidx,:);
[~,OutputXYidx]=ismember(OutputX,OutputY,'rows');

OutputXYidx(~any(OutputXYidx,2),: ) = [];
OutputXY=OutputY(OutputXYidx,:);
[~,InXOutYidx]=ismember(InputX,OutputY,'rows');

InXOutYidx(~any(InXOutYidx,2),: ) = [];
InXOutY=OutputY(InXOutYidx,:);
[~,InYOutXidx]=ismember(InputY,OutputX,'rows');

InYOutXidx(~any(InYOutXidx,2),: ) = [];
InYOutX=OutputX(InYOutXidx,:);
[~,delIdxInX]=ismember([InXOutY;InputXY],InputX,'rows');

delIdxInX(~any(delIdxInX,2),: ) = [];
InputX(delIdxInX,:)=[];
[~,delIdxInY]=ismember([InYOutX;InputXY],InputY,'rows');

delIdxInY(~any(delIdxInY,2),: ) = [];
InputY(delIdxInY,:)=[];
[~,delIdxOutX]=ismember([InYOutX;OutputXY],OutputX,'rows');

delIdxOutX(~any(delIdxOutX,2),: ) = [];
OutputX(delIdxOutX,:)=[];
[~,delIdxOutY]=ismember([InXOutY;OutputXY],OutputY,'rows');

delIdxOutY(~any(delIdxOutY,2),: ) = [];
OutputY(delIdxOutY,:)=[];
% %Reorder some index vectors
% OutputYReordered=reshape(fliplr(reshape(OutputY',di,[])),[],1);
% InputYReordered=reshape(fliplr(reshape(InputY',di,[])),[],1);
%
%% Caluclation of sub-matrices
%
%Stiffness
k11=Kred(InputXY,InputXY);
k12=Kred(InputXY,InXOutY);
k13=Kred(InputXY,InYOutX);
k14=Kred(InputXY,OutputXY);
k15=Kred(InputXY,InputX);
k16=Kred(InputXY,OutputY);
k17=Kred(InputXY,OutputX);
k18=Kred(InputXY,InputY);
k22=Kred(InXOutY,InXOutY);
k23=Kred(InXOutY,InYOutX);
k24=Kred(InXOutY,OutputXY);
k25=Kred(InXOutY,InputX);
k26=Kred(InXOutY,OutputY);
k27=Kred(InXOutY,OutputX);
k28=Kred(InXOutY,InputY);
k33=Kred(InYOutX,InYOutX);
k34=Kred(InYOutX,OutputXY);
k35=Kred(InYOutX,InputX);
k36=Kred(InYOutX,OutputY);
k37=Kred(InYOutX,OutputX);
k38=Kred(InYOutX,InputY);
k44=Kred(OutputXY,OutputXY);
k45=Kred(OutputXY,InputX);
k46=Kred(OutputXY,OutputY);
k47=Kred(OutputXY,OutputX);
k48=Kred(OutputXY,InputY);
k55=Kred(InputX,InputX);
k56=Kred(InputX,OutputY);
k57=Kred(InputX,OutputX);
k58=Kred(InputX,InputY);
k66=Kred(OutputY,OutputY);
k67=Kred(OutputY,OutputX);
k68=Kred(OutputY,InputY);
k77=Kred(OutputX,OutputX);
k78=Kred(OutputX,InputY);
k88=Kred(InputY,InputY);

%% Calculation of coefficient matrices
%
% GX-direction
K3GX=[
    k13+k14+k23+k24, k17+k27, zeros(size(k18));
    k35'+k45', k57, zeros(size(k58));
    k46'+k48'+k36'+k38', k67+k78',zeros(size(k88))];

K4GX=[
    (k34+k34')+(k12+k12')+k33+k44+k11+k22, k47+k15+k25+k37, k28+k18+k26+k16; 
    k47'+k15'+k25'+k37', k55+k77, k56+k58; 
    k28'+k18'+k26'+k16',k56'+k58', (k68'+k68)+k66+k88];

%XM-direction
K3XM=[
    -k23+k34+k12-k14, zeros(size(k15)), -k36+k16; 
    -k27'+k47'+k25'-k45', zeros(size(k57)), k56-k67'; 
    k28'-k48', zeros(size(k58')), k68'];

K4XM=[
    -(k13+k13')-(k24+k24')+k33+k44+k11+k22, -k35+k15+k37-k17, -k38-k46+k18+k26;
    -k35'+k15'+k37'-k17', -(k57+k57')+k55+k77, k58-k78;
    -k38'-k46'+k18'+k26', k58'-k78', k66+k88];

%MG-direction
K1MG=[
    k14*theta, zeros(size(k15)), zeros(size(k18));
    k45'*theta, zeros(size(k55)), zeros(size(k58)); 
    k48'*theta, zeros(size(k58')), zeros(size(k88))];

K2MG=[
    (k13+k24)*theta+k34+k12, k17*theta, k16; 
    k35'*theta+k47'+k25', k57*theta, k56; 
    k28'+(k38'+k46')*theta, k78'*theta, k68'];

K3MG=[
    k23*theta+(k33+k44+k11+k22)+k23*theta^(-1), k27*theta+(k15+k37), k36*theta^(-1)+k18+k26; 
    k15'+k37'+k27'*theta^(-1), k55+k77, k58+k67'*theta^(-1); 
    k36'*theta+k18'+k26', k67*theta+k58', k66+k88];

%GY-direction
K3GY=[
    k23+k34+k12+k14, zeros(size(k15)), k36+k16; 
    k27'+k47'+k25'-k45', zeros(size(k57)), k56+k67'; 
    k28'+k48', zeros(size(k58')), k68'];

K4GY=[
    (k13+k13')+(k24+k24')+k33+k44+k11+k22, k35+k15+k37+k17, k38+k46+k18+k26;
    k35'+k15'+k37'+k17', (k57+k57')+k55+k77, k58+k78;
    k38'+k46'+k18'+k26', k58'+k78', k66+k88];

%GX-direction
K3YM=[
    k13-k14-k23+k24, k17-k27, zeros(size(k18));
    k35'-k45', k57, zeros(size(k58));
    k46'-k48'-k36'+k38', -k67+k78',zeros(size(k88))];

K4YM=[
    -(k34+k34')-(k12+k12')+k33+k44+k11+k22, -k47+k15-k25+k37, -k28+k18+k26-k16;
    -k47'+k15'-k25'+k37', k55+k77, -k56+k58; 
    -k28'+k18'+k26'-k16',-k56'+k58', -(k68'+k68)+k66+k88];

% K1MGq=K1MG*theta^(-2);
%
% K2MGq=[
% (k13+k24)*theta^(-1)+k34+k12, k17*theta^(-1), k16; 
% k35'*theta^(-1)+k47'+k25', k57*theta^(-1), k56; 
% k28'+(k38'+k46')*theta^(-1), k78'*theta^(-1), k68'];
