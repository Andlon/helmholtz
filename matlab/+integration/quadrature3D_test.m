function tests = quadrature3D_test()
% Automated tests for integration.quadrature1D.
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_first_order_polynomial(testCase)
A = [0, 0, 2];
B = [3, 3, 1];
C = [6, 0, 3];
D = [5, 0, -5];
P = [ A; B; C; D ];
f = @(x, y, z) x + y + z;
g = @(X) f(X(:, 1), X(:, 2), X(:, 3));

I1 = integration.quadrature3D(P, 1, g);
I4 = integration.quadrature3D(P, 4, g);
I5 = integration.quadrature3D(P, 5, g);
% The polynomial is of sufficiently low order to expect exact result
verifyEqual(testCase, I1, 105.7500000, 'AbsTol', 1e-9);
verifyEqual(testCase, I4, 105.7500000, 'AbsTol', 1e-9);
verifyEqual(testCase, I5, 105.7500000, 'AbsTol', 1e-9);
end

function test_second_order_polynomial(testCase)
A = [0, 0, 2];
B = [3, 3, 1];
C = [6, 0, 3];
D = [5, 0, -5];
P = [ A; B; C; D ];
f = @(x, y, z) x .* y + y.^2 + z + 2;
g = @(X) f(X(:, 1), X(:, 2), X(:, 3));

I4 = integration.quadrature3D(P, 4, g);
I5 = integration.quadrature3D(P, 5, g);
% The polynomial is of sufficiently low order to expect exact result
verifyEqual(testCase, I4, 133.9500000, 'AbsTol', 1e-9);
verifyEqual(testCase, I5, 133.9500000, 'AbsTol', 1e-9);
end


function test_third_order_polynomial(testCase)
A = [0, 0, 2];
B = [3, 3, 1];
C = [6, 0, 3];
D = [5, 0, -5];
P = [ A; B; C; D ];
f = @(x, y, z) x .* y .* z + y.^2 + z + 2;
g = @(X) f(X(:, 1), X(:, 2), X(:, 3));

I5 = integration.quadrature3D(P, 5, g);
% The polynomial is of sufficiently low order to expect exact result
verifyEqual(testCase, I5, 93.41250000, 'AbsTol', 1e-9);
end


