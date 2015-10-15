function I = quadrature1D(a, b, Nq, g)
%QUADRATURE1D(a, b, Nq, g)	Numerically compute integral.
%   I = QUADRATURE1D(a, b, Nq, g) computes the integral of g: (a, b) -> R
%   on the finite interval (a, b) using Gauss quadrature  with 
%   Nq integration points.

assert(isscalar(a) && isscalar(b), 'a, b must be scalar values.');
assert(isfinite(a) && isfinite(b), 'a and b must be finite.');
assert(a < b, 'a must be smaller than b.');
assert(isa(g, 'function_handle'), 'g must refer to a function handle.');

% Introduce the bijection xi(x) := (x - a) / (b - a), such that
% x = (b - a) * xi + a 
% Then compute the integral on the interval (0, 1) for the function G(xi)
% and exploit the fact that
% integral(g) on (a, b) == (b - a) * integral(G) on (0, 1).
G = @(xi) g( (b - a) * xi + a );
I = (b - a) * quad1d_reference(Nq, G);
end

function I = quad1d_reference(n, f)
% I = QUAD1D(n, f) computes the integral of the function f over
% over the interval (0, 1) using Gauss quadrature of order n
% (1-4 supported).

[x_q, w_q] = reference_integration_points(n);
I = dot(w_q, f(x_q));
end

function [x_q, w_q] = reference_integration_points(Nq)
% Note that for the purposes of quadrature, x_q does not need
% to be ordered in non-decreasing order, which we exploit for simplicity
switch Nq
    case 1
        x_q = 0.5;
        w_q = 1;
    case 2
        x_q = 0.5 + plusminus(sqrt(3) / 6);
        w_q = [ 0.5, 0.5 ];
    case 3
        x_q = [ 0.5, plusminus(sqrt(15) / 10) + 0.5 ];
        w_q = [ 4 / 9, 5 / 18, 5 / 18 ];
    case 4
        C1 = 0.5 + plusminus(sqrt(525 - 70 * sqrt(30)) / 70);
        C2 = 0.5 + plusminus(sqrt(525 + 70 * sqrt(30)) / 70);
        W1 = (18 + sqrt(30)) / 72;
        W2 = (18 - sqrt(30)) / 72;
        x_q = [ C1, C2 ];
        w_q = [ W1, W1, W2, W2 ];
    otherwise
        error('Nq must be an integer in the interval [1, 4].');
end
end

function [ Y ] = plusminus(X)
Y = [ -X X ];
end
