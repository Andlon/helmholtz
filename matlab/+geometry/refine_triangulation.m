function tri = refine_triangulation( tri, h )

% Use Ruppert's algorithm
Q = geometry.find_poor_triangles(tri, h);
S = geometry.find_encroached(tri);

while ~isempty(Q) || ~isempty(S)
    while ~isempty(S)
        constraint = S(1, :);
        % Add midpoint of encroached constraint to triangulation
        tri = geometry.split_constraint(tri, constraint);
        S = geometry.find_encroached(tri);
    end
    
    if ~isempty(Q)
        q = Q(1);
        center = tri.circumcenter(q);
        
        % Determine if the circumcenter encroaches any of the constraints
        for e = 1:size(tri.Constraints, 1)
            constraint = tri.Constraints(e, :);
            if encroaches(tri, center, constraint)
                S(end+1, :) = constraint;
            end
        end
        
        if isempty(S)
            % Add circumcenter to triangulation
            tri.Points(end+1, :) = center;
        end
    end
    
    % Global update here.
    % TODO: Can accelerate substantially by only considering
    % changed triangles/segments
    Q = geometry.find_poor_triangles(tri, h);
end

end

function result = encroaches(tri, vertex, edge)
a = tri.Points(edge(1), :);
b = tri.Points(edge(2), :);
center = a + (b - a) / 2;
radius = norm(b - center);

d = vertex - center;
result = radius > norm(d);
end

