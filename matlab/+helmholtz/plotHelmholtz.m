function [] = plotHelmholtz(data,type)
%plotHelmholtz Plots the solution
%   type = 'real' plots the real part
%   type = 'imag' plots the imaginary part
%   no input for type gives absolute value

vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;

if strcmp(type,'real')
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),real(data.u))
    title('FEM solution - real part')
    ylabel('y')
    xlabel('x')
elseif strcmp(type,'imag')
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),imag(data.u))
    title('FEM solution - imaginary part')
    ylabel('y')
    xlabel('x')
else
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),abs(data.u))
    title('FEM solution - absolute value')
    ylabel('y')
    xlabel('x')
end

end

