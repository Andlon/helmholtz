function Q = find_poor_triangles( tri, h )

T = size(tri, 1);
Q = zeros(0, 1);

[~, rin] = tri.incenter();
d_inscribed = rin * 2;

for t = 1:T
    vertex_indices = tri.ConnectivityList(t, :);
    vertices = tri.Points(vertex_indices, :);
    sides = vertices - circshift(vertices, 1);
    diameter = max(sum(sides.^2, 2));
    
    % Is this the correct computation of the ratio we're looking for?
    % TODO: Find out
    ratio = diameter / d_inscribed(t);
    
    if ratio > 3 || diameter > h
       Q(end+1) = t;
    end
end

end

