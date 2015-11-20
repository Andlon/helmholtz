data_250_real_source = helmholtz.unit_box(250);
save('data_250_real_source.mat','data_250_real_source');
norm_250 = integration.computeL2Norm(data_250_real_source);
save('norm_250','norm_250');

data_350_real_source = helmholtz.unit_box(350);
save('data_350_real_source.mat','data_350_real_source');
norm_350 = integration.computeL2Norm(data_350_real_source);
save('norm_350','norm_350');