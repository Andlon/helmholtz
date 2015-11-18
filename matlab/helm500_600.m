A = load('data_500_real_source.mat');
norm_500 = integration.computeL2Norm(A.data_500_real_source);
save('norm_500','norm_500');

data_600_real_source = helmholtz.unit_box(600);
save('data_600_real_source.mat','data_600_real_source');
norm_600 = integration.computeL2Norm(data_600_real_source);
save('norm_600','norm_600');