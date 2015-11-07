function S = find_encroached( tri )

S = zeros(0, 2);
segments = tri.Constraints;

for k = 1:size(segments, 1)
    % Denote a and b as the indices of the vertices in this edge
    i = segments(k, 1);
    j = segments(k, 2);
    a = tri.Points(i, :);
    b = tri.Points(j, :);
    length = sqrt(sum((b - a).^2, 2));
    
    % Diametral circle
    radius = length / 2;
    center = a + (b - a) / 2;

    % For now, check all vertices to ensure correctness of algorithm.
    % TODO: Optimize this to only check points that are necessary? (How?)
    n = size(tri.Points, 1);
    vertices = tri.Points(1:n ~= i & 1:n ~= j, :);
    
    % Compute distance from center to each vertex
    D = bsxfun(@minus, vertices, center);
    distances = sqrt(sum(D.^2, 2));
    
    % If any point is within the diametral circle of the edge,
    % it is considered encroached
    if (min(distances) < radius)
       S(end+1, :) = [ i, j ];
    end
    
end

end

