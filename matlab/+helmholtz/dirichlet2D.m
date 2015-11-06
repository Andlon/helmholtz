function u = dirichlet2D( A, b, edgelist)
boundary_indices = unique(edgelist);
N = length(boundary_indices);
A(boundary_indices, :) = 0;
A(boundary_indices, boundary_indices) = speye(N);
b(boundary_indices) = 0;
u(:,1) = A \ b(:,1);
u(:,2) = A \ b(:,2);
end

