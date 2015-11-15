function data = unit_box( N )

c = 3*10^8;
f = 2.4*10^9;
omega = 2*pi*f;
k = omega/c;


data.tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, N, N);
vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);


g0 = [-1,-1]';


source_index = nearestNeighbor(data.tri,[0,0]);

N_triangles = length(triangles);

M = geometry.generateMaterials(k,N_triangles);



[A_real,A_im, b] = helmholtz.stiffness2D(data.tri,M, g0, source_index);
data.u = helmholtz.dirichlet2D(A_real,A_im, b, edgelist);


close all

figure
trimesh(triangles,vertices(:,1),vertices(:,2),data.u(:,1))
title('FEM solution')
ylabel('y')
xlabel('x')


end