function tri = split_constraint( tri, edge)

i = edge(1);
j = edge(2);

index = (tri.Constraints(:, 1) == i & tri.Constraints(:, 2) == j) ...
    | (tri.Constraints(:, 1) == j & tri.Constraints(:, 2) == i);
assert(any(index));
assert(sum(index) == 1);

N = size(tri.Points, 1);
midpoint = geometry.midpoint(tri, [i, j]);

% Update constraints
tri.Constraints = tri.Constraints(~index, :);
tri.Points(N+1, :) = midpoint;
tri.Constraints(end+1:end+2, :) = [i, N + 1; N + 1, j];

end
