%% FEATool Multiphysics Version 1.14.1, Build 21.05.150, Model M-Script file.
%% Created on 30-May-2021 12:21:08 with MATLAB 9.10.0.1602886 (R2021a) PCWIN64.


%% Starting new model.
fea.sdim = { 'x', 'y' };
fea.geom = struct;
fea = addphys( fea, @planestress, { 'u', 'v' } );

%% Geometry operations.
gobj = gobj_rectangle( 0, 1, 0, 1, 'R1');
fea = geom_add_gobj( fea, gobj );
gobj = gobj_rectangle( [0], [0.05], [0], [0.05], 'R1' );
fea.geom.objects{1} = gobj;
gobj = gobj_ellipse( [ 0.025;0.025 ], 0.02, 0.01, 'E1');
fea = geom_add_gobj( fea, gobj );
gobj = gobj_ellipse( [0 0], [0.005], [0.005], 'E1' );
fea.geom.objects{2} = gobj;
fea.geom = geom_apply_formula( fea.geom, 'R1-E1' );

%% Grid operations.
fea.grid = gridgen( fea, 'gridgen', 'default', 'hmax', 0.005, 'grading', 0.3 );
fea.grid = gridgen( fea, 'gridgen', 'default', 'hmax', 0.001, 'grading', 0.3 );

%% Equation settings.
fea.phys.pss.dvar = { 'u', 'v' };
fea.phys.pss.sfun = { 'sflag1', 'sflag1' };
fea.phys.pss.eqn.coef = { 'nu_pss', 'nu', 'Poisson''s ratio', { '0.3' };
                          'E_pss', 'E', 'Modulus of elasticity', { '210e9' };
                          'rho_pss', 'rho', 'Density', { '1' };
                          'Fx_pss', 'F_x', 'Body load in x-direction', { '0' };
                          'Fy_pss', 'F_y', 'Body load in y-direction', { '0' };
                          'a_pss', 'alpha', 'Thermal expansion coeffient', { '0' };
                          'T_pss', 'T', 'Temperature', { '0' };
                          'u0_pss', 'u_0', 'Initial condition for u', { '0' };
                          'v0_pss', 'v_0', 'Initial condition for v', { '0' } };
fea.phys.pss.eqn.seqn = { 'rho_pss*u'' - E_pss/(1-nu_pss^2)*( (ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)_x + ((1-nu_pss)/2*(uy+vx))_y ) = Fx_pss', 'rho_pss*v'' - E_pss/(1-nu_pss^2)*( (nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss)_y + ((1-nu_pss)/2*(uy+vx))_x ) = Fy_pss' };
fea.phys.pss.eqn.vars = { 'von Mieses stress', 'sqrt((E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss))^2+(E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss))^2-(E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss))*(E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss))+3*(E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)))^2)';
                          'Total displacement', 'sqrt(u^2+v^2)';
                          'x-displacement', 'u';
                          'y-displacement', 'v';
                          'Stress, x-component', 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)';
                          'Stress, y-component', 'E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss)';
                          'Stress, xy-component', 'E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx))';
                          'First principal stress', 'princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 1 )';
                          'Second principal stress', 'princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 2 )';
                          'Third principal stress', 'princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 3 )';
                          'Strain, x-component', 'ux';
                          'Strain, y-component', 'vy';
                          'Strain, z-component', '-nu_pss*(ux+vy)/(1-nu_pss)';
                          'Strain, xy-component', '(uy+vx)';
                          'First principal strain', 'princse( ux, vy,-nu_pss*(ux+vy)/(1-nu_pss),(uy+vx), 1 )';
                          'Second principal strain', 'princse( ux, vy,-nu_pss*(ux+vy)/(1-nu_pss),(uy+vx), 2 )';
                          'Third principal strain', 'princse( ux, vy,-nu_pss*(ux+vy)/(1-nu_pss),(uy+vx), 3 )';
                          'Tresca stress', 'max(max(abs(princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 1 )-princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 2 )),abs(princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 2 )-princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 3 ))),abs(princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 1 )-princse( E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss), E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss), 0, E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)), 3 )))';
                          'Displacement field', { 'u', 'v' } };
fea.phys.pss.prop.isaxi = 0;
fea.phys.pss.prop.active = [ 1;
                             1 ];
fea.phys.pss.prop.intb = 0;

%% Constants and expressions.
fea.expr = { 'force', '1000';
             'width', '2*0.05';
             'thickness', '0.001';
             'load', 'force/(width*thickness)' };

%% Boundary settings.
fea.phys.pss.bdr.sel = [ 1, 1, 1, 1, 1 ];
fea.phys.pss.bdr.coef = { 'bcnd_pss', 'Set displacements/loads', 'Set displacements/loads', { 'Fixed displacement, u', 'Edge load, x-dir.';
                          'Fixed displacement, v', 'Edge load, y-dir.' }, { 0, 0, 0, 0, 1;
                          0, 1, 0, 0, 0 }, [], { '0', '0', 'load', '0', '0';
                          '0', '0', '0', '0', '0' } };
fea.phys.pss.bdr.vars = [];
fea.phys.pss.bdr.coefi = { 'bcnd_pss', 'Set displacements/loads', 'Set displacements/loads', { 'Fixed displacement, u', 'Load difference, x-dir.';
                           'Fixed displacement, v', 'Load difference, y-dir.' }, { 0, 0, 0, 0, 0;
                           0, 0, 0, 0, 0 }, [], { 0, 0, 0, 0, 0;
                           0, 0, 0, 0, 0 } };
fea.phys.pss.prop.intb = 0;

%% Solver call.
fea = parsephys( fea );
fea = parseprob( fea );

fea.sol.u = solvestat( fea, ...
                       'iupw', [ 0, 0 ], ...
                       'linsolv', 'backslash', ...
                       'icub', 'auto', ...
                       'nlrlx', 1, ...
                       'toldef', 1e-06, ...
                       'tolchg', 1e-06, ...
                       'reldef', 0, ...
                       'relchg', 1, ...
                       'maxnit', 20, ...
                       'nproc', 1, ...
                       'init', { 'u0_pss', 'v0_pss' }, ...
                       'solcomp', [ 1; 1 ] );

%% Postprocessing.
postplot( fea, ...
          'surfexpr', 'sqrt((E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss))^2+(E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss))^2-(E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss))*(E_pss/(1-nu_pss^2)*(nu_pss*ux + vy - (nu_pss+1)*a_pss*T_pss))+3*(E_pss/(1-nu_pss^2)*((1-nu_pss)/2*(uy+vx)))^2)', ...
          'title', 'surface: von Mieses stress', ...
          'solnum', 1 );
postplot( fea, ...
          'surfexpr', 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)', ...
          'title', 'surface: Stress, x-component', ...
          'solnum', 1 );
postplot( fea, ...
          'surfexpr', 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)', ...
          'title', 'surface: Stress, x-component', ...
          'solnum', 1 );

[mn,mx,pn,px] = minmaxsubd( 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)', fea, [1], [], 2 );
%% -593900 at ( 0.0050645, 0.000807 ); 2.97212e+07 at ( 0.0003175, 0.0051065 )
postplot( fea, ...
          'surfexpr', 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)', ...
          'title', 'surface: Stress, x-component', ...
          'solnum', 1 );

p_eval = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
0.005, 0.0075, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.0225, 0.025, 0.0275, 0.03, 0.0325, 0.035, 0.0375, 0.04, 0.0425, 0.045, 0.0475, 0.05 ];
val = evalexpr( 'E_pss/(1-nu_pss^2)*(ux + nu_pss*vy - (1+nu_pss)*a_pss*T_pss)', p_eval, fea, 1 );
%% Evaluation result of expression Stress, x-component : 2.58338e+07  1.51591e+07  1.21266e+07  1.13998e+07  1.08713e+07  1.06807e+07  1.04956e+07  1.04096e+07  1.03105e+07  1.02559e+07  1.01839e+07  1.01392e+07  1.00749e+07  1.00311e+07  9.96245e+06  9.91254e+06  9.82766e+06  9.75853e+06  9.66275e+06
plot( 1:length(val), val )

p_eval = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
0.005, 0.0075, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.0225, 0.025, 0.0275, 0.03, 0.0325, 0.035, 0.0375, 0.04, 0.0425, 0.045, 0.0475, 0.05 ];
val = evalexpr( 'load/2*(2+0.005^2/y^2+3*0.005^4/y^4)', p_eval, fea, 1 );
%% Evaluation result of expression load/2*(2+0.005^2/y^2+3*0.005^4/y^4) : 3e+07  1.51852e+07  1.21875e+07  1.1184e+07  1.07407e+07  1.05081e+07  1.03711e+07  1.02835e+07  1.0224e+07  1.01817e+07  1.01505e+07  1.01267e+07  1.01083e+07  1.00936e+07  1.00818e+07  1.00721e+07  1.0064e+07  1.00572e+07  1.00515e+07
plot( 1:length(val), val )

