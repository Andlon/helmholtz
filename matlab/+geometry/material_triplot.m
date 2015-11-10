function material_triplot( tri, materials, value_mapper)

values = arrayfun(value_mapper, materials);
num_distinct_values = length(unique(values));
distinct_colors = parula(num_distinct_values);
colors = distribute_colors(values, distinct_colors);

figure;
hold on;
for t = 1:size(tri, 1)
    vertices = tri.Points(tri.ConnectivityList(t, :), :);
    patch(vertices(:, 1), vertices(:, 2), colors(t, :));
end
hold off;

end

function colors = distribute_colors(values, distinct_colors)

distinct_colors = mat2cell(distinct_colors, ones(1, size(distinct_colors, 1)), 3);
color_map = containers.Map(unique(values), distinct_colors);
cell_colors = arrayfun(@(val) color_map(val), values, 'UniformOutput', false);
colors = transpose(reshape(cell2mat(cell_colors), 3, length(values)));

end

