function data = unit_box( N )

data.tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, N, N);
vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);


c = 3*10^8;
f = 2.4*10^9;
omega = 2*pi*f;
k = omega/c;

M = helmholtz.generateMaterials(k,length(triangles));

g0 = -1-1i;


source_index = nearestNeighbor(data.tri,[0,0]);


[A, b] = helmholtz.stiffness2D(data.tri,M, g0, source_index);
data.u = helmholtz.dirichlet2D(A, b, edgelist);

close all

figure
trimesh(triangles,vertices(:,1),vertices(:,2),abs(data.u))
title('FEM solution')
ylabel('y')
xlabel('x')


end