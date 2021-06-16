clearvars
% filename = 'newertest.msh';
domainPid = 10;
[node, nids] = readnodes('test.msh');
conn = readelements('test.msh', domainPid);

plot_mesh(node,conn,'tria3')
