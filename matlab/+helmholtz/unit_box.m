function data = unit_box( N )

data.tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, N, N);
triangles = data.tri.ConnectivityList;
edgelist = freeBoundary(data.tri);


c = 3*10^8;
f = 2.4*10^9;
omega = 2*pi*f;
k = omega/c;

M = helmholtz.generateMaterials(k,length(triangles));

g0 = -1;


source_index = nearestNeighbor(data.tri,[0,0]);

[A, b] = helmholtz.stiffness2D(data.tri,M, g0, source_index);
data.u = helmholtz.dirichlet2D(A, b, edgelist);
%data.u = helmholtz.robin2D(A,b,data.tri,M);
end