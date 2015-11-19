data_700_real_source = helmholtz.unit_box(700);
save('data_700_real_source.mat','data_700_real_source');
norm_700 = integration.computeL2Norm(data_700_real_source);
save('norm_700','norm_700');