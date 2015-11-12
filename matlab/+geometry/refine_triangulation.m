function tri = refine_triangulation( tri, h )

% Use Ruppert's algorithm
Q = geometry.find_poor_triangles(tri, h);
S = geometry.find_encroached(tri);

while ~isempty(Q) || ~isempty(S)
    prev_connectivity = tri.ConnectivityList;
    while ~isempty(S)
        constraint = S(1, :);
        % Add midpoint of encroached constraint to triangulation
        tri = geometry.split_constraint(tri, constraint);
        S = geometry.find_encroached(tri);
    end
    
    if ~isempty(Q)
        % Find index q of triangle Q(end, :). Note that calculating the
        % circumcenter directly through a formula is probably much faster.
        % Fix this later. For now, we just want this to work.
        [triangle_is_valid, q] = ismember(Q(end, :), tri.ConnectivityList, 'rows');
        Q(end, :) = [];
        
        if triangle_is_valid    
            center = tri.circumcenter(transpose(q));
            
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
    end
    
    searchspace = changed_triangles(tri, prev_connectivity);
    Q = union(Q, geometry.find_poor_triangles(tri, h, searchspace), 'rows');
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

function [ indices ] = changed_triangles(tri, prev_connectivity)
[~, indices] = setdiff(tri.ConnectivityList, prev_connectivity, 'rows');
end

