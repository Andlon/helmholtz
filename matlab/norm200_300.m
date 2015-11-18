A = load('data_200_real_source.mat');
norm_200 = integration.computeL2Norm(A.data_200_real_source);

B = load('data_300_real_source.mat');
norm_300 = integration.computeL2Norm(B.data_300_real_source);

save('norm_200','norm_200');
save('norm_300','norm_300');