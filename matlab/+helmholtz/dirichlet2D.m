function u = dirichlet2D( A_real,A_im ,b, edgelist)
boundary_indices = unique(edgelist);
N = length(boundary_indices);
A_real(boundary_indices, :) = 0;
A_real(boundary_indices, boundary_indices) = speye(N);
b(boundary_indices) = 0;
A_im(boundary_indices, :) = 0;
A_im(boundary_indices, boundary_indices) = speye(N);
b(boundary_indices) = 0;
u(:,1) = A_real \ b(:,1);
u(:,2) = A_im \ b(:,2);
end

