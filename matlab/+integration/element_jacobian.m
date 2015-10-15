function [ J ] = element_jacobian( P )
N = size(P, 1);
J = abs(det([ P ones(N, 1) ]));
end

