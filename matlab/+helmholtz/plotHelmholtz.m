function [] = plotHelmholtz(data,type,dim)
%plotHelmholtz Plots the solution
%   type = 'real' plots the real part
%   type = 'imag' plots the imaginary part
%   no input for type gives absolute value
%   dim = 2,3 sets the viewpoint (3D or 2D plot)

vertices = data.tri.Points;
triangles = data.tri.ConnectivityList;



if strcmp(type,'real')
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),real(data.u))
    title('FEM solution - real part')
    ylabel('y')
    xlabel('x')
    view(dim)
    if dim == 2
        colorbar
    end
elseif strcmp(type,'imag')
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),imag(data.u))
    title('FEM solution - imaginary part')
    ylabel('y')
    xlabel('x')
    view(dim)
    if dim == 2
        colorbar
    end
else
    figure
    trimesh(triangles,vertices(:,1),vertices(:,2),abs(data.u))
    title('FEM solution - absolute value')
    ylabel('y')
    xlabel('x')
    view(dim)
    if dim == 2
        colorbar
    end
end

end

