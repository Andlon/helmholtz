function data = unit_box( N )

data.tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, N, N);
vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;
edgelist = edges(data.tri);

[A, b] = helmholtz.stiffness2D(1, vertices, triangles, @(x) 0);
data.u = helmholtz.dirichlet2D(A, b, edgelist);

end

