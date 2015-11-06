function tests = split_triangle_test()
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_single_triangle(test)
tri = triangulation(1:3, [ 0, 0; 0, 1; 1, 0 ]);
split = geometry.split_triangle(tri, 1);

center = tri.circumcenter(1);

test.assertEqual(split.Points(end, :), center);
test.assertEqual(split.Points(1:3, :), tri.Points(1:3, :));

v1 = repmat(4, 3, 1);
v2 = transpose(1:3);
test.assertTrue(all(split.isConnected(v1, v2)));

end
