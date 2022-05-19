function [fBand, ABand, deltaKx, deltaKy, deltaKxy, kxy0] = dispersionCalc(nBand, deltaKxy0, ...
    PBCTrans, BasisVec, IdxPBCIn, IdxPBCOut, Ksys, Msys, ratio)
%DISPERSIONCALC Summary of this function goes here
%   Detailed explanation goes here

maxBasisVecX = max(max(abs(BasisVec(:, 1))));
maxBasisVecY = max(max(abs(BasisVec(:, 2))));
normdkx = maxBasisVecX / min(maxBasisVecX, maxBasisVecY);
normdky = maxBasisVecY / min(maxBasisVecX, maxBasisVecY);
% Diese Berechnungen (bis Zeile 30) dienen nur der Normierung der
% Diskretisierung der Brillouin-Zone, sodass alle Reander auf der Brillouin-Zone
% gleich diskretisiert werden.
% Bsp. wenn der Rand Gamma-X und der Rand X-M jeweils in 100 Schritte
% unterteilt wird, dannn wird der Rand M-Gamma in sqrt(2)*100 Schritte
% unterteilt, da dieser Rand laenger ist.
% ----------------------------------------------------------------------------
% Calculation of real valued band structure omega(k)
deltaKx = pi / (deltaKxy0 * normdkx);
deltaKy = pi / (deltaKxy0 * normdky);
deltaKxy = pi / (deltaKxy0 * sqrt(normdky^2 + normdkx^2));
%Aufstellen der Vektoren fuer kx und ky entlang der Brillouin-Zone
%(s. Abb. oben)
if ratio ~= 1
    kx0 = [(0:deltaKx:pi)'; ones(numel(deltaKy:deltaKy:pi), 1) * pi; ...
    (pi - deltaKxy:-deltaKxy:0)'; zeros(numel(0:deltaKy:pi), 1); (0:deltaKx:pi)'];

    ky0 = [zeros(numel(0:deltaKx:pi), 1); (deltaKy:deltaKy:pi)'; ...
        (pi - deltaKxy:-deltaKxy:0)'; (0:deltaKy:pi)'; ones(numel(0:deltaKx:pi), 1) * pi];
else 
    kx0 = [(0:deltaKx:pi)'; ones(numel(deltaKy:deltaKy:pi), 1) * pi; ...
        (pi - deltaKxy:-deltaKxy:0)'];
    ky0 = [zeros(numel(0:deltaKx:pi), 1); (deltaKy:deltaKy:pi)'; ...
        (pi - deltaKxy:-deltaKxy:0)'];
end

% GGf. loeschen einiger Eintraege, falls nur eine Bloch-Randbedinung in
% x-Richtung vorliegt
if size(BasisVec, 1) == 1
    kx0(deltaKxy0 + 2:end) = [];
    ky0(deltaKxy0 + 2:end) = [];
end

% Nummerierungsvektor von 1 bis Anzahl der Eintraege im kx bzw ky Vektor
kxy0 = 1:1:size(kx0);
% Anzahl an Freiheitsgraden im reduzierten System
% (also abzgl. v8, v5, v9, v6, v7)
nDofPBC = size(Ksys, 1) - size(unique(IdxPBCOut), 1);
% Preallokation einer Matrix, in die die Eigenfrequenzen pro Berechnungsschritt
% geschrieben werden
fBand = zeros(nBand, size(kx0, 1));
% Preallokation einer Matrix, in die die Eigenformen pro Berechnungsschritt
% geschrieben werden
ABand = zeros(nDofPBC, nBand, size(kx0, 1));
% Schleife zur Berechnung der Dispersionskurven
parfor kindx = 1:size(kx0, 1)
    % Auslesen von kx
    kx = kx0(kindx) + 0.01;
    % Auslesen von ky
    ky = ky0(kindx);
    % Berechnung der Ausbreitungskonstante Lambdax
    lambX = exp(sqrt(-1) * kx);
    % Berechnung der Ausbreitungskonstante Lambday
    lambY = exp(sqrt(-1) * ky);
    % Einbau der Randbedingungen mittels Funktion
    [KPBC, MPBC, ~] = ApplyBlochBC2D(Ksys, Msys, IdxPBCIn, IdxPBCOut, lambX, ...
    lambY, PBCTrans);
    % Loesen des Eigenwertproblems
    [AEig0PBC, LambdaPBC] = eigs(KPBC, MPBC, nBand, 'smallestabs');
    % Sortieren der Loesungen
    [LambdaPBC, LambdaPBCLoc] = sort(diag(LambdaPBC));
    % Berechnung von omega (mit neuer Sortierung)
    OmegaiPBC = sqrt((LambdaPBC)');
    % Berechnung von f
    fiPBC = OmegaiPBC / (2 * pi());
    % Umsortierung der Eigenformen
    AEig0PBC = AEig0PBC(:, LambdaPBCLoc);
    % Abspeichern der Eigenfrequenzen
    fBand(:, kindx) = fiPBC';
    % Abspeichern der Eigenformen
    ABand(:, :, kindx) = AEig0PBC;
end

end

