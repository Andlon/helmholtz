function [] = plotErrorNorm(norm,N)
figure
hold on
plot(N,log(norm),'*')
plot(N,log(norm),'--')
title('Logarithm of Error measured in L2')
xlabel('N')
ylabel('Error')
grid on
end

