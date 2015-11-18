function [tri, M] = create_boxed_house( h )
%% Domain construction
materials = simulation.material_database;
dom = geometry.pdedomain;

% Add "bounding box" of air
dom.add_rectangle(materials.air, 0, 0, 10, 8);

% Build walls. This is a single long polygon.
walls = [ ...
    1, 3;
    1.5, 3;
    1.5, 2.25;
    2.25, 1.5;
    7.75, 1.5;
    8.5, 2.25;
    8.5, 6.5;
    2.25, 6.5;
    1.5, 5.75;
    1.5, 5;
    1, 5;
    1, 6;
    2, 7;
    9, 7;
    9, 2;
    8, 1;
    2, 1;
    1, 2;
    ];
dom.add_polygon(materials.wood, walls);

% Add a fountain in the middle of the construction
fountain_center = [ 5, 4 ];
fountain_radius = 1;
dom.add_circle(materials.water, fountain_center, fountain_radius);

% Add a metal-based hollow box in the top-right corner of the building
dom.add_rectangle(materials.teflon, 6.5, 5, 8.5, 6.5);
dom.add_rectangle(materials.air, 7, 5.5, 8, 6);

%% Domain triangulation and visualization
% Plot triangulation with materials
[tri, M] = dom.triangulate(h);

end

