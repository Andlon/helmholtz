function tri = split_triangle( tri, triangle )
connectivity = tri.ConnectivityList;
center = tri.circumcenter(triangle);
points = [ tri.Points; center ];
N = size(points, 1);

T1 = connectivity(triangle, :);
T2 = [ T1(1:2), N ];
T3 = [ T1([1, 3]), N ];
T1 = [ T1(2:3), N ];
connectivity(triangle, :) = T1;
connectivity(end+1:end+2, :) = [ T2; T3 ];

tri = triangulation(connectivity, points);

end

