function M = assign_materials( tri, polygons, materials, default_material )

% Assigns materials to polygons in a very naive fashion. Simply
% loop through all triangles, check if it is contained in any of the
% polygons, in which case assign that material to the triangle. If it is
% not contained in any polygon, assign the default material to the
% triangle. Note that it is assumed that the polygons do not intersect.

P = length(polygons);
T = size(tri, 1);
M = repmat(default_material, 1, T);

% Inspect each triangle
for t = 1:T
    indices = tri.ConnectivityList(t, :);
    vertices = tri.Points(indices, :);
    
    for p = 1:P
        polypoints = polygons{p};
        vertices_in_poly = inpolygon(vertices(:, 1), vertices(:, 2), ...
            polypoints(:, 1), polypoints(:, 2));
        
        if all(vertices_in_poly)
            M(t) = materials(p);
        end
    end
end

end

