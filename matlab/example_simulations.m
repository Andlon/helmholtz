clear;
close all;

%% README!
% The following code is supposed to illustrate a representative subset of
% our work. It will generate a bunch of plots in hopefully reasonable time.

% Use only 240 Mhz to relax requirement of fine grids so that the examples
% runs in a reasonable time.
frequency = 2.4 * 10^8;

%% Materials
% Retrieve materials from the material database. Will be used in later
% construction of domains.
materials_db = simulation.material_database;
air = materials_db.air;
wood = materials_db.wood;
water = materials_db.water;

% Compute wavenumbers for the materials
air = helmholtz.computeWavenumbers(air, frequency);
wood = helmholtz.computeWavenumbers(wood, frequency);
water = helmholtz.computeWavenumbers(water, frequency);

%% Domain construction
% Build a set of domains that will later be used in the solver.

% Simple unit box. N points in each direction (hence N^2). Triangulation
% is Delaunay triangulation of regular grid.
unit_box_N = 100;
unit_box_tri = mesh.rect_triangulation(-0.5, 0.5, -0.5, 0.5, unit_box_N, unit_box_N);
unit_box_M = helmholtz.generateMaterials(air.wavenumber, size(unit_box_tri, 1));
unit_box_source_location = unit_box_tri.nearestNeighbor([0, 0]);

% Simple domain with constraints and different materials. In this case
% we use our own custom mesh refinement implementation of Ruppert's
% algorithm. Creates a 1x1 box of air with two smaller rectangles of wood 
% and water. We use a very coarse triangulation because of its high
% time-complexity.
simple = geometry.domain(air, 0, 0, 1, 1);
simple.add_rectangle(wood, 0.2, 0.2, 0.4, 0.4);
simple.add_rectangle(water, 0.5, 0.5, 0.9, 0.6);
[simple_tri, simple_M] = simple.triangulate(0.1);
simple_source_location = simple_tri.nearestNeighbor([0.5, 0.5]);

% A more involved domain in the form of a non-convex union of various shapes
% made of different materials. Specifically, a non-convex polygon of air,
% a rectangle of wood and a circle of water.
% In this case our implementation uses MATLAB's PDE Toolbox under the hood.
polygon = [ 0, 0; 1, 0; 1.5, 1.5; 1, 1; 0, 1 ];
nonconvex = geometry.pdedomain;
nonconvex.add_polygon(air, polygon);
nonconvex.add_rectangle(wood, 0.3, 0.9, 0.8, 1.2);
nonconvex.add_circle(water, [ 1, 0.5 ], 0.3);
[nonconvex_tri, nonconvex_M] = nonconvex.triangulate(0.02);
nonconvex_source_location = nonconvex_tri.nearestNeighbor([0.2, 0.2]);

% Create the "house" that is illustrated in our report.
[house_tri, house_M] = simulation.create_boxed_house(0.1);
house_M = helmholtz.computeWavenumbers(house_M, frequency);
house_source_location = house_tri.nearestNeighbor([ 5, 6 ]);

%% Domain triangulation visualization
material_mapper = @(material) abs(material.wavenumber);

triplot(unit_box_tri);
title('Unit box triangulation');

geometry.material_triplot(simple_tri, simple_M, material_mapper);
title('Simple domain triangulation');

geometry.material_triplot(nonconvex_tri, nonconvex_M, material_mapper);
title('Non-convex domain triangulation');

geometry.material_triplot(house_tri, house_M, material_mapper);
title('House domain triangulation.');

%% Solution
[A, b] = helmholtz.stiffness2D(unit_box_tri, unit_box_M, 1, unit_box_source_location);
u_unit_box = helmholtz.dirichlet2D(A, b, unit_box_tri.freeBoundary());

[A, b] = helmholtz.stiffness2D(simple_tri, simple_M, 1, simple_source_location);
u_simple = helmholtz.dirichlet2D(A, b, simple_tri.freeBoundary());

[A, b] = helmholtz.stiffness2D(nonconvex_tri, nonconvex_M, 1, nonconvex_source_location);
u_nonconvex = helmholtz.robin2D(A, b, nonconvex_tri, nonconvex_M);

[A, b] = helmholtz.stiffness2D(house_tri, house_M, 1, house_source_location);
u_house = helmholtz.robin2D(A, b, house_tri, house_M);

%% Solution visualization
% We plot the absolute value (amplitude) of all solutions
visualize = @(tri, u) trimesh(tri.ConnectivityList, tri.Points(:, 1), tri.Points(:, 2), abs(u));

% Note in particular how solution behaves in the water in the non-convex
% domain. One would expect the signal to rapidly decay and not increase.
% Could this result be due to the discontinuity in k?

figure;
visualize(unit_box_tri, u_unit_box);
title(sprintf('Unit Box solution, Dirichlet, f = %2.2e', frequency));

figure;
visualize(simple_tri, u_simple);
title(sprintf('Simple domain solution, Dirichlet, f = %2.2e', frequency));

figure;
visualize(nonconvex_tri, u_nonconvex);
title(sprintf('Nonconvex domain solution, Robin, f = %2.2e', frequency));

figure;
visualize(house_tri, u_house);
title(sprintf('House domain solution, Robin, f = %2.2e', frequency));