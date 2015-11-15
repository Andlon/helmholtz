function index = nearestNeighbour(points,x)
% nearestNeighbour: finds the index of the nearestNeigbour to the point
% x = (x,y)

dist = (points(:,1) - x(1)).^2 + (points(:,2) - x(2)).^2;

index = find(dist == min(dist));

end

