function S = find_encroached( tri )

S = zeros(0, 1);
edges = tri.edges();

for k = size(edges, 1)
    % Denote a and b as the indices of the vertices in this edge
    i = edges(k, 1);
    j = edges(k, 2);
    a = tri.Points(i, :);
    b = tri.Points(j, :);
    length = sqrt(sum(a.^2 + b.^2));
    
    % Diametral circle
    radius = length / 2;
    center = a + (b - a) / 2;
    
    % Determine triangles that contain these two vertices, and
    % then find all unique vertices that are contained in any neighbouring
    % triangles to either a or b.
    attachments = tri.vertexAttachments([ i; j ]);
    triangles = unique([ attachments{1}, attachments{2} ]);
    vertex_indices = setdiff(tri.ConnectivityList(triangles, :), [i, j]);
    vertices = tri.Points(vertex_indices, :);
    
    % Compute distance from center to each vertex
    D = bsxfun(@minus, vertices, center);
    distances = sum(D.^2, 2);
    
    % If any point is within the diametral circle of the edge,
    % it is considered encroached
    if (min(distances) < radius)
       S(end+1) = k;
    end
    
end

end

