function data = unit_box_constrained(h)
close all

f = 2.4*10^9;

vacuum = struct('permeability',1,'permittivity',1);
water = struct('permeability',0.999992,'permittivity',80.1);
sapphire = struct('permeability',0.99999976,'permittivity',10);

dom = geometry.domain(vacuum,-0.5,-0.5,0.5,0.5);
dom.add_rectangle(water,0.2,0.2,0.25,0.25);
dom.add_rectangle(sapphire,-0.4,-0.3,0.4,-0.2);
[data.tri, M] = dom.triangulate(h);
M = helmholtz.computeWavenumbers(M,f);


%geometry.material_triplot( data.tri, M, @(mat) mat.wavenumber);


vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);

%M = helmholtz.generateMaterials(k,size(triangles));

g0 = [-1,-1]';

source_index = geometry.nearestNeighbour(vertices,[0,0]);

[A_real,A_im, b] = helmholtz.stiffness2D(data.tri,M, g0, source_index);
data.u = helmholtz.dirichlet2D(A_real,A_im, b, edgelist);



figure
trimesh(triangles,vertices(:,1),vertices(:,2),data.u(:,1))
title('FEM solution')
ylabel('y')
xlabel('x')


end