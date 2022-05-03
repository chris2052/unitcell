function [D3GX, D4GX,D3XM, D4XM,D1MG, D2MG, D3MG, D3GY, D4GY, D3YM, D4YM] = ...
    CoefficientMatricesPBCrect(Dred,InputIdx,OutputIdx,PBCdiff,theta)
%COEFFICIENTMATRICESPBCRECT Summary of this function goes here
%   Detailed explanation goes here

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
d11=Dred(InputXY,InputXY);
d12=Dred(InputXY,InYOutX);
d13=Dred(InputXY,InXOutY);
d14=Dred(InputXY,OutputXY);
d15=Dred(InputXY,InputX);
d16=Dred(InputXY,InputY);
d17=Dred(InputXY,OutputX);
d18=Dred(InputXY,OutputY);
%
d22=Dred(InYOutX,InYOutX);
d23=Dred(InYOutX,InXOutY);
d24=Dred(InYOutX,OutputXY);
d25=Dred(InYOutX,InputX);
d26=Dred(InYOutX,InputY);
d27=Dred(InYOutX,OutputX);
d28=Dred(InYOutX,OutputY);
%
d33=Dred(InXOutY,InXOutY);
d34=Dred(InXOutY,OutputXY);
d35=Dred(InXOutY,InputX);
d36=Dred(InXOutY,InputY);
d37=Dred(InXOutY,OutputX);
d38=Dred(InXOutY,OutputY);
%
d44=Dred(OutputXY,OutputXY);
d45=Dred(OutputXY,InputX);
d46=Dred(OutputXY,InputY);
d47=Dred(OutputXY,OutputX);
d48=Dred(OutputXY,OutputY);
%
d55=Dred(InputX,InputX);
d56=Dred(InputX,InputY);
d57=Dred(InputX,OutputX);
d58=Dred(InputX,OutputY);
%
d66=Dred(InputY,InputY);
d67=Dred(InputY,OutputX);
d68=Dred(InputY,OutputY);
%
d77=Dred(OutputX,OutputX);
d78=Dred(OutputX,OutputY);
%
d88=Dred(OutputY,OutputY);

%% Calculation of coefficient matrices
%
% GX-direction
D3GX=[
    d12+d14+d23+d34, d17+d37, zeros(size(d18));
    d25'+d45', d57, zeros(size(d58));
    d46'+d48'+d26'+d28', d67+d78',zeros(size(d88))];

D4GX=[
    (d13+d13')+(d24+d24')+d33+d44+d11+d22, d15+d27+d47+d35, d36+d16+d38+d18; 
    d15'+d27'+d47'+d35', d55+d77, d56+d58; 
    d36'+d16'+d38'+d18',d56'+d58', (d68'+d68)+d66+d88];

% XM-direction
D3XM=[
    -d23+d24+d13-d14, zeros(size(d15)), -d28+d18; 
    -d37'+d47'+d35'-d45', zeros(size(d57)), d58-d78; 
    d28'-d48', zeros(size(d58')), d68']; % why d68 transp?

D4XM=[
    -(d34+d34')-(d12+d12')+d33+d44+d11+d22, -d25+d15+d27-d17, -d48-d26+d38+d16;
    -d25'+d15'+d27'-d17', -(d57+d57')+d55+d77, d56-d67;
    -d48'-d26'+d16'+d38', d56'-d67', d66+d88];

% MG-direction
D1MG=[
    d14*theta, zeros(size(d15)), zeros(size(d18));
    d45'*theta, zeros(size(d55)), zeros(size(d58)); 
    d46'*theta, zeros(size(d58')), zeros(size(d88))];

D2MG=[
    (d34+d12)*theta+d13+d24, d17*theta, d18; 
    d25'*theta+d47'+d35', d57*theta, d58; 
    d36'+(d48'+d26')*theta, d67'*theta, d68']; % why d68 transp?


D3MG=[
    d23*theta+(d33+d44+d11+d22)+d23*theta^(-1), d37*theta+(d15+d27), d28*theta^(-1)+d16+d38; 
    d15'+d27'+d37'*theta^(-1), d55+d77, d56+d78'*theta^(-1); 
    d28'*theta+d16'+d38', d78'*theta+d56', d66+d88];

% GY-direction
D3GY=[
    d23+d34+d12+d14, zeros(size(d15)), d36+d16; 
    d27'+d47'+d25'-d45', zeros(size(d57)), d56+d67'; 
    d28'+d48', zeros(size(d58')), d68'];

D4GY=[
    (d13+d13')+(d24+d24')+d33+d44+d11+d22, d35+d15+d37+d17, d38+d46+d18+d26;
    d35'+d15'+d37'+d17', (d57+d57')+d55+d77, d58+d78;
    d38'+d46'+d18'+d26', d58'+d78', d66+d88];

% YM-direction
D3YM=[
    d13-d14-d23+d24, d17-d27, zeros(size(d18));
    d35'-d45', d57, zeros(size(d58));
    d46'-d48'-d36'+d38', -d67+d78',zeros(size(d88))];

D4YM=[
    -(d34+d34')-(d12+d12')+d33+d44+d11+d22, -d47+d15-d25+d37, -d28+d18+d26-d16;
    -d47'+d15'-d25'+d37', d55+d77, -d56+d58; 
    -d28'+d18'+d26'-d16',-d56'+d58', -(d68'+d68)+d66+d88];

% D1MGq=D1MG*theta^(-2);
%
% D2MGq=[
% (d13+d24)*theta^(-1)+d34+d12, d17*theta^(-1), d16; 
% d35'*theta^(-1)+d47'+d25', d57*theta^(-1), d56; 
% d28'+(d38'+d46')*theta^(-1), d78'*theta^(-1), d68'];

end

