function v = midpoint(tri, edge)
i = edge(1);
j = edge(2);
a = tri.Points(i, :);
b = tri.Points(j, :);
v = a + (b - a) / 2;
end