function I = quadLine2D(a, b, Nq, g)
a = reshape(a, 1, numel(a));
b = reshape(b, 1, numel(b));
G = @(s) g(repmat(a, numel(s), 1) + s * (b - a));
I = norm(b - a) * integration.quadrature1D(0, 1, Nq, G);
end