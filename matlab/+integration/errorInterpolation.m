function error = errorInterpolation(data_f,data_c)
%errorInterpolation Integrates the error between a the solution on a fine
%and a coarse mesh over the triangles in the fine triangulation 
%specified by data_f

vertices_c = data_c.tri.Points;
val_c = data_c.u;

vertices_f = data_f.tri.Points;
val_f = data_f.u;
triangles_f = data_f.tri.ConnectivityList;
triangles_c = data_c.tri.ConnectivityList;

interpolant_c = scatteredInterpolant(vertices_c,val_c,'linear');
interpolant_f = scatteredInterpolant(vertices_f,val_f,'linear');

integrand = @(x,y) abs(interpolant_f(x,y)-interpolant_c(x,y)).^2;
integrand_2 = @(X) integrand(X(:, 1), X(:, 2));

%figure
%[X,Y] = meshgrid(linspace(-0.5,0.5,sqrt(length(vertices_f))),linspace(-0.5,0.5,sqrt(length(vertices_f))));

%mesh(X,Y,integrand(X,Y))


error = integration.domainIntegration(integrand_2,triangles_c,vertices_c);

end

