function tri = rect_triangulation( xmin, xmax, ymin, ymax, Nx, Ny)
% mesh.RECT_TRIANGULATION Generate triangulation for a rectangle.
%   tri = mesh.RECT_TRIANGULATION(xmin, xmax, ymin, ymax, Nx, Ny)
%   generates a triangulation of the box described by the given bounds
%   on x and y, using a grid of (Nx)x(Ny) linearly spaced vertices.
%
%   tri is compatible with MATLAB's triangulation structure.

assert_scalars([xmin, xmax, ymin, ymax, Nx, Ny], ...
    { 'xmin', 'xmax', 'ymin', 'ymax', 'Nx', 'Ny' });
assert(isintegral(Nx) && Nx > 0, 'Nx must be an integer larger than zero.');
assert(isintegral(Ny) && Ny > 0, 'Nx must be an integer larger than zero.');
assert(xmin < xmax, 'xmin must be smaller than xmax');
assert(ymin < ymax, 'ymin must be smaller than ymax');

x_spec = linspace(xmin, xmax, Nx);
y_spec = linspace(ymin, ymax, Ny);
[X, Y] = meshgrid(x_spec, y_spec);
x = reshape(X, Nx^2, 1);
y = reshape(Y, Ny^2, 1);
tri = delaunayTriangulation(x, y);

% Make the triangulation on-Delaunay so that nearestNeighbor can be invoked
tri = triangulation(tri.ConnectivityList, tri.Points);
end

function assert_scalars(scalars, names)
for i = 1:length(scalars)
    message = sprintf('%s must be a scalar.', names{i});
    assert(isscalar(scalars(i)), message);
end
end

function bool = isintegral(n)
bool = mod(n, 1) == 0;
end
