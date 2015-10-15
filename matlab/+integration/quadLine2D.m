function I = quadLine2D(a, b, Nq, g)
G = @(s) g(a + s * (b - a));
I = norm(b - a) * integration.quadrature1D(0, 1, Nq, G);
end