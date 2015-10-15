function I = quadrature3D(P, Nq, g)
% QUADRATURE3D Numerically compute 3-dimensional integral on a tetrahedron.
%   I = QUADRATURE3D(P, Nq, g) computes the integral of g(X)
%   (where X is a matrix of size (Nq)x3 )
%   on the tetrahedron determined by the 3-dimensional vertices
%   P = [p1; p2; p3; p4 ],
%   where p1, p2, p3 are row vectors such that P is of size 4x3
%   using Gaussian quadrature with Nq = 1, 4, 5 points of integration.

[zeta_q, w_q] = reference_integration_points(Nq);
J = integration.element_jacobian(P);
I = J * w_q * g(zeta_q * P);

end

function [zeta_q, w_q] = reference_integration_points(Nq)
switch Nq
    case 1
        zeta_q = [ 1/4, 1/4, 1/4, 1/4 ];
        w_q = 1/6;
    case 4
        a = 1 / 4 + (3 / 20) * sqrt(5);
        b = 1 / 4 - sqrt(5) / 20;
        zeta_q = [ ...
            a, b, b, b;
            b, a, b, b;
            b, b, a, b;
            b, b, b, a ];
        w_q = [ 1/24, 1/24, 1/24, 1/24 ];
    case 5
        zeta_q = [ ...
            1/4, 1/4, 1/4, 1/4;
            1/2, 1/6, 1/6, 1/6;
            1/6, 1/2, 1/6, 1/6;
            1/6, 1/6, 1/2, 1/6;
            1/6, 1/6, 1/6, 1/2 ];
        w_q = [ -2/15, 3/40, 3/40, 3/40, 3/40 ];
    otherwise
        error('Nq must be 1, 4 or 5.');
end
end
