data_800_real_source = helmholtz.unit_box(800);
save('data_800_real_source.mat','data_800_real_source');
norm_800 = integration.computeL2Norm(data_800_real_source);
save('norm_800','norm_800');