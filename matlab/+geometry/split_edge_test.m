function tests = split_edge_test()
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_split_single_triangle_side(test)
tri = triangulation(1:3, [ 0, 0; 0, 1; 1, 0 ]);
split = geometry.split_edge(tri, 1:2);

test.assertEqual(size(split, 1), 2);

% split_edge should have the property that the list of points is only
% added to, not changed
test.assertEqual(split.Points(1:3, :), tri.Points(1:3, :));
test.assertEqual(split.Points(4, :), [ 0, 0.5 ]);

v1 = repmat(4, 3, 1);
v2 = transpose(1:3);
test.assertTrue(all(split.isConnected(v1, v2)));

end

function test_split_square(test)
P = [ 0, 0; 0, 1; 1, 0; 1, 1 ];
T = [ 1:3; 2:4 ];
tri = triangulation(T, P);
split = geometry.split_edge(tri, 2:3);

test.assertEqual(size(split, 1), 4);
test.assertEqual(split.Points(1:4, :), P);
test.assertEqual(split.Points(5, :), [ 0.5, 0.5 ]);

v1 = repmat(5, 4, 1);
v2 = transpose(1:4);
test.assertTrue(all(split.isConnected(v1, v2)));

end
