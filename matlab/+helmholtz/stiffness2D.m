function [A, b] = stiffness2D(tri,M, g0, source_index)
% helmholtz.STIFFNESS TODO: Add documentation

vertices = tri.Points;
triangles = tri.ConnectivityList;

assert(size(vertices, 2) == 2, 'vertices must be an Nx2 matrix.');
assert(size(triangles, 2) == 3, 'triangles must be a Kx3 matrix.');

T = size(triangles, 1);
N = size(vertices, 1);

A = sparse(N, N);

% b(:,1) is real part, b(:,2) is complex part
b = zeros(N, length(g0));


sum_of_integrals = zeros(length(g0),1);

% Compute contributions by each element
for t = 1:T
    k = M(t).wavenumber;
    indices = triangles(t, :);
    P = vertices(indices, :);
    area = integration.element_jacobian(P) / 2;
    
    % Gradients are conveniently given by coefficients of non-constant
    % terms, being affine functions
    basis = helmholtz.basis_coefficients(P);
    grad = basis(2:3, :);
    
    
    % TODO: Make basis functions for real and imaginary part using real and
    % imaginary part of k^2
    A_k = area * transpose(grad) * grad;
    for i = 1:3
        for j = 1:3
            integrand = @(X) ...
                - k^2 * ...
                (X * basis(2:3, i) + basis(1, i)) .* ...
                (X * basis(2:3, j) + basis(1, j));
            A_k(i, j) = A_k(i, j) + integration.quadrature2D(P, 4, integrand);
        end
    end
    
    % TODO: Take a function rhs(...) that computes the
    % local b_k for the current triangle instead of just a function g
    b_k = zeros(3, length(g0));
    
    
    A(indices, indices) = A(indices, indices) + A_k;
    
    % Dirac Mass Source
    
    % Finds the index of the source_index in indices
    for s = 1:length(g0)
           s_i = find(indices == source_index(s));

        % Calculates the preliminary load vector
        if s_i
            % Defining the basis of the source node
            source_basis = basis(:,s_i);

            % Adding to the sum of integrals term
            source_integrand = @(X) X*source_basis(2:3) + source_basis(1);
            sum_of_integrals(s) = sum_of_integrals(s) + integration.quadrature2D(P,4,source_integrand );

            for i = 1:3
                integrand = @(X) -(X*source_basis(2:3) + source_basis(1)).*(X * basis(2:3, i) + basis(1, i));
                b_k(i,s) = integration.quadrature2D(P,4,integrand);
            end
        end
        b(indices,s) = b(indices,s) + b_k(:,s);
    end
end

% Calculates the gh elements from the integral requirement
for s = 1:length(g0)
    gh(s) = g0(s)/sum_of_integrals(s);
    % Calulate load vector
    b(:,s) = gh(s)*b(:,s);
end

% Add sources
b = sum(b,2);

end
