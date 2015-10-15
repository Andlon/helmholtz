function tests = quadrature2D_test()
% Automated tests for integration.quadrature1D.
tests = functiontests(localfunctions);
end

function setup(testCase)
end

function test_log_x_y(testCase)
A = [1, 0];
B = [3, 1];
C = [3, 2];
P = [ A; B; C ];

f = @(x, y) log(x + y);
g = @(X) f(X(:, 1), X(:, 2));

I = integration.quadrature2D(P, 4, g);
% Can not expect exact integral here
verifyEqual(testCase, 1.165417026, I, 'AbsTol', 0.003);
end

function test_fourth_order_polynomial(testCase)
A = [0, 0];
B = [3, 3];
C = [6, 0];
P = [ A; B; C ];

f = @(x, y) x.^2 .* y.^2 + x + y;
g = @(X) f(X(:, 1), X(:, 2));

I = integration.quadrature2D(P, 4, g);
% The polynomial is of too high order to expect exact result
verifyEqual(testCase, 165.5999999, I, 'AbsTol', 4.0);
end

function test_third_order_polynomial(testCase)
A = [0, 0];
B = [3, 3];
C = [6, 0];
P = [ A; B; C ];

f = @(x, y) x.^2 .* y + y.^2 + 2 * x + y;
g = @(X) f(X(:, 1), X(:, 2));

I = integration.quadrature2D(P, 4, g);
% The polynomial is of sufficiently low order for us to expect an exact
% result
verifyEqual(testCase, 165.6, I, 'AbsTol', 1e-9);
end

function test_second_order_polynomial(testCase)
A = [0, 0];
B = [3, 3];
C = [6, 0];
P = [ A; B; C ];

f = @(x, y) x.^2 + y.^2 + 2 * x + y;
g = @(X) f(X(:, 1), X(:, 2));

I = integration.quadrature2D(P, 3, g);
% The polynomial is of sufficiently low order for us to expect an exact
% result
verifyEqual(testCase, 171, I, 'AbsTol', 1e-9);
end

function test_first_order_polynomial(testCase)
A = [0, 0];
B = [3, 3];
C = [6, 0];
P = [ A; B; C ];

f = @(x, y) x + y;
g = @(X) f(X(:, 1), X(:, 2));

I = integration.quadrature2D(P, 1, g);
% The polynomial is of sufficiently low order for us to expect an exact
% result
verifyEqual(testCase, 36, I, 'AbsTol', 1e-9);
end