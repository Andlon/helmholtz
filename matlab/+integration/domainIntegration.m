function val = domainIntegration(F,triangles,vertices)
%domainIntegration Integrates the function F over the domain specified by
%the elements in triangles and the points in vertices

T = size(triangles, 1);
val = 0;

for t = 1:T;
    indices = triangles(t, :);
    P = vertices(indices, :);
    val = val + integration.quadrature2D(P, 4, F);
end

end

