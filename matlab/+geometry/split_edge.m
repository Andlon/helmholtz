function tri = split_edge( tri, edge )
connectivity = tri.ConnectivityList;
midpoint = geometry.midpoint(tri, edge);
points = [ tri.Points; midpoint ];
N = size(points, 1);

attachments = tri.edgeAttachments(edge(1), edge(2));
triangles = attachments{1};
t1 = triangles(1);
T1 = connectivity(t1, :);
T3 = T1;
T1(T1 == edge(1)) = N;
T3(T3 == edge(2)) = N;
connectivity(t1, :) = T1;
connectivity(end+1, :) = T3;

% If the triangle is on the boundary of the triangulated domain,
% it will only have a single edge attachment, otherwise it will have two.
if length(triangles) == 2
    t2 = triangles(2);
    T2 = connectivity(t2, :);
    T4 = T2;
    T2(T2 == edge(1)) = N;
    T4(T4 == edge(2)) = N;
    connectivity(t2, :) = T2;
    connectivity(end+1, :) = T4;
end

tri = triangulation(connectivity, points);

end

