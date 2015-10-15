function tests = quadrature1D_test()
% Automated tests for integration.quadrature1D.
tests = functiontests(localfunctions);
end

function setup(testCase)
% Use the fact that Gauss integration.quadratures are exact for polynomials
% of degree 2n - 1 or less to test approximately exact values
% for polynomials of various orders.
testCase.TestData.functions = {
    @(x) 9 * ones(size(x)), ...
    @(x) 2 * x + 3, ...
    @(x) 3 * x.^3 - x.^2 + 9 * x - 8, ...
    @(x) 8 * x.^5 - x.^3 + x.^2, ...
    @(x) 6 * x.^7 + 3 * x.^5 - x
    };
end

function verifyAlmostEqual(testCase, X, Y)
verifyEqual(testCase, X, Y, 'RelTol', 1e-6);
end

function verifyFunction(testCase, a, b, n, index)
f = testCase.TestData.functions{index};
verifyAlmostEqual(testCase, integration.quadrature1D(a, b, n, f), integral(f, a, b));
end

function test_constant(testCase)
for n = 1:4
    verifyFunction(testCase, -5, 5, n, 1);
end
end

function test_linear(testCase)
for n = 1:4
    verifyFunction(testCase, -5, 5, n, 2);
end
end

function test_cubic(testCase)
for n = 2:4
    verifyFunction(testCase, -5, 5, n, 3);
end
end

function test_order5(testCase)
for n = 3:4
    verifyFunction(testCase, -5, 5, n, 4);
end
end

function test_order7(testCase)
for n = 4:4
    verifyFunction(testCase, -1, 5, n, 5);
end
end