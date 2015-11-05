function tests = polygon_test()
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_single_triangle(testCase)
T = [0, 0; 0, 1; 1, 0 ];
polygons = { T };
[P, C] = geometry.polygon_constraints(polygons);

verifyEqual(testCase, P, T);
verifyEqual(testCase, C, [ 1, 2; 2, 3; 3, 1 ]);
end

function test_two_triangles(testCase)
T1 = [0, 0; 0, 1; 1, 0 ];
T2 = [1, 1; 1, 2; 2, 1 ];
polygons = { T1, T2 };
[P, C] = geometry.polygon_constraints(polygons);

verifyEqual(testCase, P(1:3, :), T1);
verifyEqual(testCase, C(1:3, :), [ 1, 2; 2, 3; 3, 1 ]);
verifyEqual(testCase, P(4:6, :), T2);
verifyEqual(testCase, C(4:6, :), [ 4, 5; 5, 6; 6, 4 ]);
end
