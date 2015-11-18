function norm = computeL2Norm(data)
%computeL2Norm Computes the L2 norm of the absolue value of the solution 

vertices = data.tri.Points;
val = data.u;
triangles = data.tri.ConnectivityList;

interpolant = scatteredInterpolant(vertices,val,'linear');
integrand = @(x,y) abs(interpolant(x,y).^2);
integrand_2 = @(X) integrand(X(:, 1), X(:, 2));

%figure
%[X,Y] = meshgrid(linspace(-0.5,0.5,sqrt(length(vertices))),linspace(-0.5,0.5,sqrt(length(vertices))));

%mesh(X,Y,integrand(X,Y))


norm = integration.domainIntegration(integrand_2,triangles,vertices);

end

