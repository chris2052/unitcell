function createLog(log, counter, l1, l2, dInclusion, tCoating, matProp, matName)
%CREATELOG write calculation information in a *.txt file called `fileName`
%   Detailed explanation goes here

%log = fopen([fileName, '.txt'], 'w');
fprintf(log, 'counter: %d\n%s\n', counter, datestr(datetime('now')));
fprintf(log, 'l1 x l2 = %5.3f x %5.3f [m]\n', l1, l2);
fprintf(log, 'tCoating = %5.3f [m]\t\t', tCoating);
fprintf(log, 'dInclusion = %5.3f [m]\n\n', dInclusion);
fprintf(log, '%5s %12s %12s %9s %12s %9s \n\n','Num', 'Mat', 'E [N/m2]', ...
    'v [-]', 'rho [kg/m3]', 't [m]');
for k = 1:size(matProp, 1)
    fprintf(log, '%5d %12s %12.3e %9.3f %12.f %9.1f\n', k, matName(k), matProp(k,:));
end
%fclose(log);

end