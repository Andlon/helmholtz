function tri = refine_triangulation( tri, h )

% Use Ruppert's algorithm
Q = geometry.find_poor_triangles(tri, h);
S = geometry.find_encroached(tri);

while ~isempty(Q) || ~isempty(S)
    prev_connectivity = tri.ConnectivityList;
    while ~isempty(S)
        for s = 1:size(S, 1)
            constraint = S(s, :);
            % Add midpoint of encroached constraint to triangulation
            tri = geometry.split_constraint(tri, constraint);
        end
        
        S = geometry.find_encroached(tri);
    end
    
    if ~isempty(Q)
        [triangle_is_valid, q] = ismember(Q(end, :), tri.ConnectivityList, 'rows');
        Q(end, :) = [];
        
        if triangle_is_valid
            center = tri.circumcenter(transpose(q));
            is_encroached = encroaches(tri, center, tri.Constraints);
            S = [ S; tri.Constraints(is_encroached, :) ];
            
            if isempty(S)
                % Add circumcenter to triangulation
                tri.Points(end+1, :) = center;
            end
        end
    end
    
    searchspace = changed_triangles(tri, prev_connectivity);
    Q = union(Q, geometry.find_poor_triangles(tri, h, searchspace), 'rows');
end

end

function result = encroaches(tri, vertex, constraints)
a = tri.Points(constraints(:, 1), :);
b = tri.Points(constraints(:, 2), :);
center = a + (b - a) / 2;
radius_squared = sum((b - center).^2, 2);

d = bsxfun(@minus, vertex, center);
result = radius_squared > sum(d.^2, 2);
end

function [ indices ] = changed_triangles(tri, prev_connectivity)
[~, indices] = setdiff(tri.ConnectivityList, prev_connectivity, 'rows');
end

