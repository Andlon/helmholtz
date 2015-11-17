function u = robin2D( A, b, tri, M )

triangles = tri.ConnectivityList;
edgelist = freeBoundary(tri);
vertices = tri.Points;

N = length(edgelist);

for k = 1:N
    p1_index = edgelist(k, 1);
    p2_index = edgelist(k, 2);
    p1 = vertices(p1_index, :)';
    p2 = vertices(p2_index, :)';
    
    % Find the index of the triangle the edge belongs to to determine the
    % k-value.
    triangle_index = find(sum((triangles == p1_index) + (triangles == p2_index),2) == 2);
    
    % If the edge is on the boundary we should only get the index of one
    % triangle. Give error if not.
    if length(triangle_index) > 1
        error('Tried to set the wave number for several triangles instead of one.');
    end
    k = M(triangle_index).wavenumber;
    
    P = [p1' 1; p2' 1];
    V = eye(2);
    C = P \ V;
    
    assert(sum(edgelist(:, 1) == p1_index) == 1);
    assert(sum(edgelist(:, 2) == p2_index) == 1);
    
    phi_1 = @(x) C(1, 1) * x(1) + C(2, 1) * x(2) + C(3, 1);
    phi_2 = @(x) C(1, 2) * x(1) + C(2, 2) * x(2) + C(3, 2);
    f = @(x) 1i * k * phi_1(x) * phi_2(x);
    g = @(x) 1i * k * phi_1(x) * phi_1(x);
    h = @(x) 1i * k * phi_2(x) * phi_2(x);
   
    A(p1_index, p2_index) = A(p1_index, p2_index) - integration.quadLine2D(p1, p2, 1, f);
    A(p2_index, p1_index) = A(p2_index, p1_index) - integration.quadLine2D(p1, p2, 1, f);
    A(p1_index, p1_index) = A(p1_index, p1_index) - integration.quadLine2D(p1, p2, 1, g);
    A(p2_index, p2_index) = A(p2_index, p2_index) - integration.quadLine2D(p1, p2, 1, h);
    
end

u = A \ b;

end