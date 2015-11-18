function u = boxed_house_simulation(tri, M, f)

%% Configuration

% Locations of N sources, given by an Nx2 matrix where each row is a point
source_locations = [ 5, 6 ];


%% Preprocessing
% Recreate triangulation as non-Delaunay so we may use nearest neighbor
tri = triangulation(tri.ConnectivityList, tri.Points);

% Compute wavenumbers for materials
M = helmholtz.computeWavenumbers(M, f);

%% Solve the equation
g0 = ones(size(source_locations, 1), 1) .* (1 + 1i);
source_indices = tri.nearestNeighbor(source_locations);

[A, b] = helmholtz.stiffness2D(tri, M, g0, source_indices);
% u = helmholtz.dirichlet2D(A, b, tri.freeBoundary());
u = helmholtz.robin2D(A, b, tri, M);

end
