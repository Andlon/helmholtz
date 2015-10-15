function C = basis_coefficients(nodes)
% Computes the coefficients C (NxN matrix) of the basis functions
% phi_i(x, y) = c_i1 + c_i2 * x + c_i3 * y for 2D and 
% analogously for 3D, for i = 1, 2, 3 (and 4 for 3D)
% for the triangle/tetrahedron nodes whose coordinates are represented
% as rows in nodes.

% To determine basis functions, solve for the coefficients of the
% first-order linear functions which are 1 in one vertex and 0 in the
% others vertices.
N = size(nodes, 1);
I = eye(N);
R = [ ones(N, 1), nodes ];
C = R \ I;

end