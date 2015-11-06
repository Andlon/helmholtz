function data = unit_box( N )

data.tri = mesh.rect_triangulation(-1, 1, -1, 1, N, N);
vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);


c = 3*10^8;
f = 2.4*10^6;
omega = 2*pi*f;
k = omega/c;

g0 = [-1,-1]';


source_index = nearestNeighbor(data.tri,[0,0]);


[A, b] = helmholtz.stiffness2D(k, vertices, triangles, g0, source_index);
data.u = helmholtz.dirichlet2D(A, b, edgelist);

close all

figure
trimesh(triangles,vertices(:,1),vertices(:,2),data.u(:,1))
title('FEM solution')
ylabel('y')
xlabel('x')


end