clear all
close all

% Unit box with dirac mass source in the origin and Dirichlet boundary
data_dir = helmholtz.unit_box(200,'Dirichlet',[0,0]);
helmholtz.plotHelmholtz(data_dir,'abs',2);
helmholtz.plotHelmholtz(data_dir,'abs',3);

% Unit box with dirac mass source in the origin and Robin boundary
data_dir = helmholtz.unit_box(200,'Robin',[0,0]);
helmholtz.plotHelmholtz(data_dir,'abs',2);
helmholtz.plotHelmholtz(data_dir,'abs',3);



%Simulate boxed house
[tri,M] = simulation.create_boxed_house(0.1);
u_house = simulation.boxed_house_simulation(tri,M,2.4*10^8);
figure
trimesh(tri.ConnectivityList,tri.Points(:,1),tri,Points(:,2),abs(u_house))
title('FEM solution - absolute value')
ylabel('y')
xlabel('x')