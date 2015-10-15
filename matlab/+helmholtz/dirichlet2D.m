function u = dirichlet2D( A, b, edgelist)
N = size(A, 1);
boundary_indices = unique(edgelist);
A(boundary_indices, :) = 0;
A(boundary_indices, boundary_indices) = speye(N);
b(boundary_indices) = 0;
u = A \ b;
end

