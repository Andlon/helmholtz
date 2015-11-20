 A = load('data_1000_real_source.mat');
 norm_1000 = integration.computeL2Norm(A.data_fine_real_source);
 save('norm_1000.mat','norm_1000');