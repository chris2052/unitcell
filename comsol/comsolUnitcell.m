clearvars
close all

model = mphload('unitCell_validation');

model.param.set('L1', '0.1[m]', 'Periodic cell height');
model.param.set('L2', '0.1[m]', 'Periodic cell length');

model.param.set('Rout', '(.075/2) [m]', 'Size of outer material');
model.param.set('Rin', '(.02/2) [m]', 'Radius of inner material');

model.param.set('numEigs', '6', 'Number of Eigenfruequencies/Bands');

model.param.set('E1', '0.93e6[N/m^2]', 'youngs modulus');
model.param.set('Rho1', '1250[kg/m^3]', 'desity');
model.param.set('Poisson1', '0.45', 'poissons ratio');

model.param.set('E2', '2.1e11[N/m^2]', 'outer mat2');
model.param.set('Rho2', '7850[kg/m^3]', 'outer mat2');
model.param.set('Poisson2', '0.3', 'outer mat2');

model.param.set('E3', '2.1e11[N/m^2]', 'inner mat3');
model.param.set('Rho3', '7850[kg/m^3]', 'inner mat3');
model.param.set('Poisson3', '0.3', 'inner mat3');

model.study('std2').run;

%% plotting
mphplot(model, 'pg7');

% Create labels
ylabel('Frequenz [Hz]','FontSize',12,'Interpreter','latex');
xlabel(' ','FontSize',12,'Interpreter','latex');
title(' ');

box(gca,'on');
grid(gca,'on');
% Set the remaining axes properties
set(gca,'FontSize',12,'TickLabelInterpreter','latex');

%%
dispFig = gcf;
axObjs = dispFig.Children;
dataObjs = axObjs.Children;

for n = 1:6
    x(n,:) = [dataObjs(n).XData(1,:), dataObjs(n).XData(2,end)];
    y(n,:) = [dataObjs(n).YData(1,:), dataObjs(n).YData(2,end)];
end

x = x(1,:);
y = flipud(y);

%%
% figure
plotDispersionAlex(y, x, 12, 1.2);
