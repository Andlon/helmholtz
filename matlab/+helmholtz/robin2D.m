function u = robin2D( A, b, tri, M )
    % robin2D   Yields a solution with the robin type boundary condition
    %
    % robin2D takes as input the stiffness matrix A, the load vector b, the
    % a triangulation tri and the materials struct setting the material for
    % each element. The function will alter the A-matrix as a consequence
    % of the robin boundary by evaluating integrals at the boundary
    % elements. The output of the function is the new u vector after the 
    % boundary conditions has been enforced.

triangles = tri.ConnectivityList;
edgelist = freeBoundary(tri);
vertices = tri.Points;

N = length(edgelist);

for j = 1:N
    p1_index = edgelist(j, 1);
    p2_index = edgelist(j, 2);
    p1 = vertices(p1_index, :)';
    p2 = vertices(p2_index, :)';
    
    % Find the index of the triangle the edge belongs to to determine the
    % k-value.
    triangle_index = find(sum((triangles == p1_index) + (triangles == p2_index),2) == 2);
    if length(triangle_index) > 1
        error('Tried to set the wave number for several triangles instead of one.');
    end
    k = M(triangle_index).wavenumber;
    
    P = [p1' 1; p2' 1];
    V = eye(2);
    C = P \ V;
    
    assert(sum(edgelist(:, 1) == p1_index) == 1);
    assert(sum(edgelist(:, 2) == p2_index) == 1);
    
    phi_1 = @(x) C(1, 1) * x(:, 1) + C(2, 1) * x(:, 2) + C(3, 1);
    phi_2 = @(x) C(1, 2) * x(:, 1) + C(2, 2) * x(:, 2) + C(3, 2);
    f = @(x) 1i * k * phi_1(x) .* phi_2(x);
    g = @(x) 1i * k * phi_1(x) .* phi_1(x);
    h = @(x) 1i * k * phi_2(x) .* phi_2(x);
   
    A(p1_index, p2_index) = A(p1_index, p2_index) - integration.quadLine2D(p1, p2, 2, f);
    A(p2_index, p1_index) = A(p2_index, p1_index) - integration.quadLine2D(p1, p2, 2, f);
    A(p1_index, p1_index) = A(p1_index, p1_index) - integration.quadLine2D(p1, p2, 2, g);
    A(p2_index, p2_index) = A(p2_index, p2_index) - integration.quadLine2D(p1, p2, 2, h);
    
end

u = A \ b;

end