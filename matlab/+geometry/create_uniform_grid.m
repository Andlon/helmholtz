function [ points ] = create_uniform_grid(step, x0, y0, x1, y1 )
Nx = ceil((x1 - x0) / step) + 1;
Ny = ceil((y1 - y0) / step) + 1;
x_spec = linspace(x0, x1, Nx);
y_spec = linspace(y0, y1, Ny);
[X, Y] = meshgrid(x_spec, y_spec);
x = reshape(X, Nx^2, 1);
y = reshape(Y, Ny^2, 1);
points = [ x, y ];
end

