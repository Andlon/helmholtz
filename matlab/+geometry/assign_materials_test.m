function tests = assign_materials_test()
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_single_triangle(test)
P = [ 0, 0; 0, 1; 1, 0 ];
tri = triangulation(1:3, P);
materials = struct('name', 'wood');
default = struct('name', 'water');
M = geometry.assign_materials(tri, { P }, materials, default);

test.assertEqual(M, materials);
end

function test_two_triangles(test)
P = [ 0, 0; 0, 1; 1, 0; 1, 1 ];
T = [ 1:3; 2:4 ];
tri = triangulation(T, P);
materials = [ struct('name', 'wood'), struct('name', 'steel') ];
default = struct('name', 'water');
polygons = { P(1:3, :), P(2:4, :) };
M = geometry.assign_materials(tri, polygons, materials, default);

test.assertEqual(M, materials);
end

function test_default_material(test)
P = [ 0, 0; 0, 1; 1, 0; 1, 1 ];
T = [ 1:3; 2:4 ];
tri = triangulation(T, P);
material = struct('name', 'wood');
default = struct('name', 'water');
polygons = { P(1:3, :) };
M = geometry.assign_materials(tri, polygons, material, default);

test.assertEqual(M, [ material, default ]);
end