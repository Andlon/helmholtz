function [A, b] = stiffness2D(k, vertices, triangles, g)
% helmholtz.STIFFNESS TODO: Add documentation

assert(size(vertices, 2) == 2, 'vertices must be an Nx2 matrix.');
assert(size(triangles, 2) == 3, 'triangles must be a Kx3 matrix.');
assert(isa(g, 'function_handle'), 'f must be a function handle.');

T = size(triangles, 1);
N = size(vertices, 1);

A = sparse(N, N);
b = zeros(N, 1);

% Compute contributions by each element
for t = 1:T
    indices = triangles(t, :);
    P = vertices(indices, :);
    area = integration.element_jacobian(P) / 2;
    
    % Gradients are conveniently given by coefficients of non-constant
    % terms, being affine functions
    basis = helmholtz.basis_coefficients(P);
    grad = basis(2:3, :);
    
    A_k = area * transpose(grad) * grad;
    for i = 1:3
        for j = 1:3
            integrand = @(X) ...
                - k^2 * ...
                (X * grad(:, i) + basis(1, i)) .* ...
                (X * grad(:, j) + basis(1, j));
            A_k(i, j) = A_k(i, j) + integration.quadrature2D(P, 4, integrand);
        end
    end
    
    % Assume g = 0 for now, which implies b = 0.
    % TODO: Take a function rhs(...) that computes the
    % local b_k for the current triangle instead of just a function g
    b_k = zeros(3, 1);
    
    A(indices, indices) = A(indices, indices) + A_k;
    b(indices) = b(indices) + b_k;
end

end
