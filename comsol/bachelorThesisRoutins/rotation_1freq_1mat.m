tic
for d = 10

    %% load model
    model = mphload('final_rot_program_geom');
    % ModelUtil.showProgress(true);

    %% clear mesh and geometry
    model.component('comp1').mesh('mesh1').feature.clear;
    model.component('comp1').geom('geom1').feature.clear;

    %% setup variables
    % d = 50;     % variable
    ang_deg = 45;        % variable
    dist = d;      % variable
    freq = 18800;   % variable frequency range

    fprintf('calculation set for: \n\n')
    fprintf('       diameter = %d m \n', d)
    fprintf('        angular = %d deg \n', ang_deg)
    fprintf('       distance = %d m \n', dist)
%     fprintf(' frequency range: %d mHz to %d mHz \n', freq(1), freq(end))
%     fprintf('       with step: %d mHz \n', freq(2)-freq(1))

    %% model parameter
    model.param.set('d', d);
    r = mphevaluate(model, 'r');
    model.param.set('ang_deg', ang_deg);
    ang = mphevaluate(model, 'ang');
    length = mphevaluate(model, 'length');
    l_zone = mphevaluate(model, 'l_zone');
    model.param.set('dist', dist);
    x_dist = mphevaluate(model, 'x_dist');
    min_x_dist = mphevaluate(model, 'min_x_dist');
    dist_0 = mphevaluate(model, 'dist_0');
    dist_c = mphevaluate(model, 'dist_c');
    w_bound = mphevaluate(model, 'w_bound');
    w_pml = mphevaluate(model, 'w_pml'); 

    %% material parameter
    model.param.set('E1', '1e9[Pa]', 'Boden youngs modulus');   % boden
    model.param.set('rho1', '1000[kg/m^3]', 'Boden desity');
    model.param.set('nu1', '0.3', 'Boden poissons ratio');
    model.param.set('E2', '30e9[Pa]', 'outer mat2');        % concrete
    model.param.set('rho2', '2300[kg/m^3]', 'outer mat2');
    model.param.set('nu2', '0.2', 'outer mat2');
    model.param.set('E3', '0.05e9[Pa]', 'inner mat3');      % rubber
    model.param.set('rho3', '2300[kg/m^3]', 'inner mat3');
    model.param.set('nu3', '0.49', 'inner mat3');

    %% create geometry
    model.component('comp1').geom('geom1').create('sq1', 'Square');
    model.component('comp1').geom('geom1').feature('sq1').set('base', 'center');
    model.component('comp1').geom('geom1').feature('sq1').set('size', 'length');
    model.component('comp1').geom('geom1').create('r1', 'Rectangle');
    model.component('comp1').geom('geom1').feature('r1').label('bound');
    model.component('comp1').geom('geom1').feature('r1').set('pos', {'-.5*length' '.5*length'});
    model.component('comp1').geom('geom1').feature('r1').set('size', {'length' 'w_bound'});
    model.component('comp1').geom('geom1').create('sq2', 'Square');
    model.component('comp1').geom('geom1').feature('sq2').set('pos', {'.5*length' '.5*length'});
    model.component('comp1').geom('geom1').feature('sq2').set('size', 'w_bound');
    model.component('comp1').geom('geom1').create('r3', 'Rectangle');
    model.component('comp1').geom('geom1').feature('r3').label('pml');
    model.component('comp1').geom('geom1').feature('r3').set('pos', {'-.5*length-w_bound' '.5*length+w_bound'});
    model.component('comp1').geom('geom1').feature('r3').set('size', {'length+w_bound*2' 'w_pml'});
    model.component('comp1').geom('geom1').create('sq3', 'Square');
    model.component('comp1').geom('geom1').feature('sq3').label('pml_corner');
    model.component('comp1').geom('geom1').feature('sq3').set('pos', {'.5*length+w_bound' '.5*length+w_bound'});
    model.component('comp1').geom('geom1').feature('sq3').set('size', 'w_pml');
    model.component('comp1').geom('geom1').create('rot2', 'Rotate');
    model.component('comp1').geom('geom1').feature('rot2').set('keep', true);
    model.component('comp1').geom('geom1').feature('rot2').set('rot', '90,180,270');
    model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'r1' 'r3' 'sq2' 'sq3'});
    model.component('comp1').geom('geom1').create('sq4', 'Square');
    model.component('comp1').geom('geom1').feature('sq4').label('zone');
    model.component('comp1').geom('geom1').feature('sq4').set('base', 'center');
    model.component('comp1').geom('geom1').feature('sq4').set('size', 'l_zone');

    model.component('comp1').geom('geom1').create('ls1', 'LineSegment');
    model.component('comp1').geom('geom1').feature('ls1').set('specify1', 'coord');
    model.component('comp1').geom('geom1').feature('ls1').set('coord1', {'.5*length+.5*w_bound' '.5*length+w_bound'});
    model.component('comp1').geom('geom1').feature('ls1').set('specify2', 'coord');
    model.component('comp1').geom('geom1').feature('ls1').set('coord2', {'.5*length+.5*w_bound' '-(.5*length+w_bound)'});

    disp('created geometry');

    %% create rotation
    count = ((length-l_zone)*0.5-(dist_0-dist_c))/dist_c;
    count = count-rem(count,1)-1;

    for m=0:ang:(2*pi-ang)
        for n=0:count
            tag = model.geom('geom1').feature.uniquetag('c');
            model.geom('geom1').feature.create(tag, 'Circle');
            model.geom('geom1').feature(tag).set('r', r);
            model.geom('geom1').feature(tag).set('pos', [(dist_0+dist_c*n)*cos(m) (dist_0+dist_c*n)*sin(m)]);
        end
    end

    for f = 1:10
        ang_var = 2^f;
        hyp = dist_c/sin(ang/ang_var);
        if hyp < dist_0
            hyp = dist_0;
        end
        count = ((length-l_zone)*0.5-hyp)/dist_c;
        count = count - rem(count,1);
        if count > 1
            for m=ang/ang_var:2*ang/ang_var:(2*pi-ang/ang_var)    
                for n=0:count
                    tag = model.geom('geom1').feature.uniquetag('c');
                    model.geom('geom1').feature.create(tag, 'Circle');
                    model.geom('geom1').feature(tag).set('r', r);
                    model.geom('geom1').feature(tag).set('pos', [(hyp+n*dist_c)*cos(m) (hyp+n*dist_c)*sin(m)]);
                end
            end
        end
    end

    disp('generated rotation');

    model.component('comp1').geom('geom1').run;
    % mphgeom(model)

    %% selections
    % select circles
    idx_holes_dom_ = mphselectbox(model, 'geom1', [-0.5*length+0.01 0.5*length-0.01; -0.5*length+0.01 0.5*length-0.01], 'domain');
    idx_zone_dom = mphselectbox(model, 'geom1', [-0.5*l_zone-0.01 0.5*l_zone+0.01; -0.5*l_zone-0.01 0.5*l_zone+0.01], 'domain');
    idx_holes_dom = setdiff(idx_holes_dom_, idx_zone_dom);

    % domain for domain probe
    model.component('comp1').probe('dom1').selection.set(idx_zone_dom);

    % prescribed displacement selection
    idx_displ_bound = mphselectbox(model, 'geom1', [0.5*length+0.3*w_bound 0.5*length+0.7*w_bound; -0.5*length-0.3*w_bound 0.5*length+0.3*w_bound], 'boundary');
    model.component('comp1').physics('solid').feature('disp1').selection.set(idx_displ_bound);

    % set mat1 (boden) 
    model.component('comp1').material('mat1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21]);
    % set mat2 to holes
    model.component('comp1').material('mat2').selection.set(idx_holes_dom);

    % select pml, something wrong
    %idx_pml_dom_ = mphselectbox(model, 'geom1', [-0.5*(length+l_zone)-w_bound-w_pml 0.5*(length+l_zone)+w_bound+w_pml; -0.5*(length+l_zone)-w_bound-w_pml 0.5*(length+l_zone)+w_bound+w_pml], 'domain');
    %idx_wbound_dom = mphselectbox(model, 'geom1', [-0.5*(length+l_zone) 0.5*(length+l_zone); -0.5*(length+l_zone) 0.5*(length+l_zone)], 'domain');
    %idx_pml_dom = setdiff(idx_pml_dom_, idx_wbound_dom);
    model.component('comp1').coordSystem('pml1').selection.set([1 2 3 4 8 19 20 21]);

    %% set mesh
    idx_holes_bound_ = mphselectbox(model, 'geom1', [-0.5*length+0.01 0.5*length-0.01; -0.5*length+0.01 0.5*length-0.01], 'boundary');
    idx_zone_bound = mphselectbox(model, 'geom1', [-0.5*l_zone-0.01 0.5*l_zone+0.01; -0.5*l_zone-0.01 0.5*l_zone+0.01], 'boundary');
    idx_holes_bound = setdiff(idx_holes_bound_, idx_zone_bound);

    model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
    model.component('comp1').mesh('mesh1').feature('ftri1').selection.set(idx_zone_dom);
    model.component('comp1').mesh('mesh1').feature('ftri1').create('dis1', 'Distribution');
    model.component('comp1').mesh('mesh1').feature('ftri1').feature('dis1').selection.set(idx_zone_bound);
    model.component('comp1').mesh('mesh1').feature('ftri1').feature('dis1').set('numelem', 4);

    model.component('comp1').mesh('mesh1').create('ftri2', 'FreeTri');
    model.component('comp1').mesh('mesh1').feature('ftri2').selection.set(idx_holes_dom);
    model.component('comp1').mesh('mesh1').feature('ftri2').create('dis1', 'Distribution');
    model.component('comp1').mesh('mesh1').feature('ftri2').feature('dis1').selection.set(idx_holes_bound);
    model.component('comp1').mesh('mesh1').feature('ftri2').feature('dis1').set('numelem', 2);

    model.component('comp1').mesh('mesh1').create('ftri3', 'FreeTri');
    model.component('comp1').mesh('mesh1').feature('ftri3').create('size1', 'Size');
    model.component('comp1').mesh('mesh1').feature('ftri3').feature('size1').set('custom', true);
    model.component('comp1').mesh('mesh1').feature('ftri3').feature('size1').set('hmaxactive', true);
    model.component('comp1').mesh('mesh1').feature('ftri3').feature('size1').set('hmax', 25);

    model.component('comp1').mesh('mesh1').run;

    disp('created mesh');

    %% start study
    fprintf('start study ...')
    model.study('std1').feature('freq').set('plist', freq);
    model.study('std1').run;

    % create solution vector


    fprintf('==> completed study \n');

    %% plot surface
    % first plot of the min disp
    model.result('pg3')
    figure('Position',[25 25 950 950]);
    model.result('pg3').feature('surf1').set('resolution', 'finer');
    model.result('pg3').feature('surf1').set('expr', 'log10(solid.disp)');
    model.result('pg3').feature('surf1').set('rangecolormax', '0');
    model.result('pg3').feature('surf1').set('rangecolormin', '-3');
    model.result('pg3').set('legendpos', 'bottom');
    mphplot(model, 'pg3', 'rangenum', 1);

%     min_freq = (freq(2)-freq(1))*min_disp;

    % xlim([-650 650])
    % ylim([-650 650])
    % xlim([-25 25])
    % ylim([-25 25])

    colorbar('TickLabelInterpreter', 'latex', 'FontSize', 12, 'location', 'southoutside')
%     title(['Frequency ',num2str(min_freq), ' mHz'], 'Interpreter', 'latex', 'FontSize', 15)
    % title ''
    axis off

%     figurenamesurf = [num2str(d), '_surf_', num2str(min_freq), '.fig'];
%     savefig(figurenamesurf);

    %% to close figure windows
%     close all

    %% save workspace
    workspacename = [num2str(d), '_', num2str(numel(idx_holes_dom))];
    save(workspacename);

end

% fs = 10e3;
% t = 0 : 1/fs : 3;
% y = sin(2*pi*440*t);
% sound(0.5*y,fs)

toc