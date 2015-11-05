function [ P, C ] = polygon_constraints( polygons )
point_count = sum(cellfun(@(p) size(p, 1), polygons));
P = zeros(point_count, 2);
C = zeros(point_count, 2);

global_index = 1;
for p = 1:length(polygons)
    points = polygons{p};
    n = size(points, 1);
    global_end = global_index + n - 1;
    
    constraints_from = transpose(global_index:global_end);
    constraints_to = circshift(constraints_from, -1);
    constraints = [ constraints_from, constraints_to ];
    
    P(global_index:global_end, :) = points;
    C(global_index:global_end, :) = constraints;
    global_index = global_index + n;
end

end

