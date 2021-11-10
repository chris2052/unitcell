clear; close all; clc
tic
%% geometry and material

% node coordinates
Nodes=[
    0, 0, 0;
    1, 0, 0;
    0, 1, 0;
    1, 1, 0]; 
% Matrix der Knotenkoordinaten
%    
%  (-1,1)    3--------------------4 (1,1) 
%            |                    |
%            |                    |
%            |          xi2       |
%            |          |         |
%            |          --> xi    |
%            |                    |
%            |                    |
%            |                    |
%            |                    |
%  (-1,-1)   1--------------------2 (1,-1) 

% connectivity matrix, last collumn physicID
Elements0=[1 2 3 4 1];

% Youngs Modulus [N/m^2]. For multiple materials use vector: [E1;E2;...]. 
% Matrix material index for PnC=1!
Emod=[1];

% Poission ratio [-]. For multiple materials use vector: [nue1;nue2;...].
nue=[0.3];

% Density [kg/m^3]. For multiple materials use vector: [rho1;rho2;...].
rho=[1];

% Thickness [m]. For multiple values use vector: [thick1;thick2;...].
thick=[1];

% "PlaneStrain", "PlaneStress"
% %Auswählen zwischen ebenem Verzerrungs- oder Spannungszustand
PhysModel="PlaneStrain";

% order
p=1;                    

%% parameters
% Anzahl der Knoten pro Element
nodPEle=size(Elements0,2)-1;

% Materialidentifikationsvektor, also zb bei Element 1 eine 1 fuer 
% Materialtyp 1 und bei Element 2 eine 2 fuer Materialtyp 2.
idxMat=Elements0(:,nodPEle+1); 

% Materialmatrix
MatProp=[Emod,nue,rho,thick];  

% Anzahl der Elemente
numElem=size(Elements0,1);  

% Gibt die Orte des Elementeckknoten innerhalb der "Elements0" Matrix an. 
% Bei linearen Elementen sind das natürlich direkt die 4 Knoten, bei Elementen 
% hoeherer Ordnung muessen eben die Stellen des unteren linken Eckknotens, 
% unteren rechten Eckknotens,  oberen linken Eckknotens und oberen rechten 
% Eckknotens angegeben werden.
CornerNodes=[1 2 3 4];                       
di=2;   


%% calculation of element-matrizes
% Bemerkung: Die parfor-Schleife wird natuerlich hier in dem Minimalbeispiel 
% nicht beruecksichtigt, aber dann hast du direkt auch die Vorgehensweise fuer
% die Berechnung und Assemblierung bei mehreren Elementen vorliegen.
% Die verwendete Speicherform und Namensgebung von "Elements.K, Elements.M und 
% Elements.DOFs" muss so verwendet werden, damit die effiziente Assemblierung 
% mittels "FastMatrixAssembly" funktioniert.

% parfor i=1:numElem
i=1;
    [ElementQMat2DK, ElementQMat2DM]=ElementMatrices2D(Nodes(Elements0...
        (i,CornerNodes),:),p,MatProp(idxMat(i),:),PhysModel);
    Elements{i}.K=ElementQMat2DK;
    Elements{i}.M=ElementQMat2DM;
    Elements{i}.DOFs=reshape(repmat(Elements0(i,1:nodPEle),di,1)*di...
        - repmat([di-1:-1:0]',1,nodPEle),[],1)';
% end

%% Assembling
% [Ksys, Msys]=FastMatrixAssembly(Elements);
toc