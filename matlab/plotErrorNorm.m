function [] = plotErrorNorm(norm,N)
figure
hold on
plot(N,norm,'*')
plot(N,norm,'--')
title('Error measured in L2')
xlabel('N')
ylabel('Error')
grid on
end

