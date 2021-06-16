clearvars

filename = 'gmshfile';
l = 1;
lc = .25;

create_unitcell(filename,l,lc)

domainPid = 10;
[node, nids] = readnodes([filename,'.msh']);
conn = readelements([filename,'.msh'], domainPid);

plot_mesh(node,conn,'tria3')