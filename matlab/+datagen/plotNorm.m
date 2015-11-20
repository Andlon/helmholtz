function [] = plotNorm(norm,N)
figure
hold on
plot(N,norm,'*')
plot(N,norm,'--')
title('L2-norm of solutions')
xlabel('N')
ylabel('Norm')
grid on
end

