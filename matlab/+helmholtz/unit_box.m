function data = unit_box( N )

data.tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, N, N);
vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);

g0 = -10^8;

c = 3*10^8;
f = 2.4*10^6;
omega = 2*pi*f;
k = 10^(8)*omega/c;
k = 0.0001;

source_index = nearestNeighbor(data.tri,[0,0]);


[A, b] = helmholtz.stiffness2D(k, vertices, triangles, g0, source_index);
data.u = helmholtz.dirichlet2D(A, b, edgelist);

close all

figure
trimesh(triangles,vertices(:,1),vertices(:,2),data.u)
title('FEM solution')
ylabel('y')
xlabel('x')


end