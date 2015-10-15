function I = quadrature2D(P, Nq, g)
% QUADRATURE2D Numerically compute 2-dimensional integral on a triangle.
%   I = QUADRATURE2D(P, Nq, g) computes the integral of g(X)
%   (where X is a matrix of size (Nq)x2 )
%   on the triangle determined by the 2-dimensional vertices 
%   P = [p1'; p2', p3' ],
%   where p1, p2, p3 are column vectors such that P is 3x2
%   using Gaussian quadrature with Nq = 1, 3, 4 points of integration.

[zeta_q, w_q] = reference_integration_points(Nq);
J = integration.element_jacobian(P);
I = J * w_q * g(zeta_q * P);

end

function [zeta_q, w_q] = reference_integration_points(Nq)

switch Nq
    case 1
        zeta_q = [ 1/6, 1/6, 1/6 ];
        w_q = 1;
    case 3
        zeta_q = [ ...
            1/2, 1/2,   0;
            1/2,   0, 1/2;
            0  , 1/2, 1/2             ];
        w_q = [ 1/6, 1/6, 1/6 ];
    case 4
        zeta_q = [ ...
            1/3, 1/3, 1/3;
            3/5, 1/5, 1/5;
            1/5, 3/5, 1/5;
            1/5, 1/5, 3/5 ];
        w_q = [ -9/32, 25/96, 25/96, 25/96 ];
    otherwise
        error('Nq must be 1, 3 or 4.');
end
end
