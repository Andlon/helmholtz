function material_triplot( tri, materials, value_mapper)

values = arrayfun(value_mapper, materials);
num_distinct_values = length(unique(values));
distinct_colors = parula(num_distinct_values);
colors = distribute_colors(values, distinct_colors);

figure;
T = size(tri, 1);
vertex_indices = reshape(tri.ConnectivityList', numel(tri.ConnectivityList), 1);
vertices = tri.Points(vertex_indices, :);
X = reshape(vertices(:, 1), 3, T);
Y = reshape(vertices(:, 2), 3, T);

face_colors = reshape(colors, 1, size(colors, 1), 3);
patch(X, Y, face_colors);

end

function colors = distribute_colors(values, distinct_colors)

distinct_colors = mat2cell(distinct_colors, ones(1, size(distinct_colors, 1)), 3);
color_map = containers.Map(unique(values), distinct_colors);
cell_colors = arrayfun(@(val) color_map(val), values, 'UniformOutput', false);
colors = transpose(reshape(cell2mat(cell_colors), 3, length(values)));

end

