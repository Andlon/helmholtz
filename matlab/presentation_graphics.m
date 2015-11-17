%% Simple grid triangulation
tri = mesh.rect_triangulation(0, 1, 0, 1, 10, 10);
newplot;
triplot(tri);

%% Add polygon constraints to demonstrate problems
unit_star = [ 0, -1; -0.1, -0.1; -1, 0; -0.1, 0.1; 0, 1; 0.1, 0.1; 1, 0; 0.1, -0.1 ];
center = [ 0.5, 0.5 ];
P = bsxfun(@plus, 0.5 * unit_star, center);
newplot;
line(P(:, 1), P(:, 2), 'Color', 'Red', 'LineWidth', 2);

%% Perform basic triangulation with polygon constraints
dom = geometry.pdedomain;
dom.add_rectangle(0, 0, 0, 1, 1);
dom.add_polygon(1, P);
triplot(dom.triangulate());