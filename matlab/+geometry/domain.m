classdef domain < handle
    properties(SetAccess = private)
        x0;
        y0;
        x1;
        y1;
        vertices = zeros(0, 2);
        constraints = zeros(0, 2);
    end
    
    methods
        function obj = domain(x0, y0, x1, y1)
            obj.x0 = x0;
            obj.x1 = x1;
            obj.y0 = y0;
            obj.y1 = y1;
            
            obj.vertices = [ obj.vertices;
                x0, y0;
                x0, y1;
                x1, y0;
                x1, y1;
                ];
        end
        
        function add_rectangle(obj, x0, y0, x1, y1)
            assert(obj.x0 <= x0 && obj.y0 <= y0 && ...
                obj.x1 >= x1 && obj.y1 >= y1, ...
                'rectangle must be within bounds of domain');
            assert(x0 < x1, 'x0 must be smaller than x1');
            assert(y0 < y1, 'y0 must be smaller than y1');
            
            N = size(obj.vertices, 1);
            indices = transpose(N+1:N+4);
            obj.vertices(indices, :) = [
                x0, y0;
                x0, y1;
                x1, y1;
                x1, y0;
                ];
            
            obj.constraints = [ obj.constraints;
                indices, circshift(indices, -1) ];
        end
        
        function tri = triangulate(obj, h)
            density = h / sqrt(2);
            grid = geometry.create_uniform_grid(density, ... 
                obj.x0, obj.y0, obj.x1, obj.y1);
            
            points = [ obj.vertices; setdiff(grid, obj.vertices, 'rows') ];
            
%             new_constraints = zeros(0, 2);
%             E = size(obj.constraints, 1);
%             for e = 1:E
%                 constraint = obj.constraints(e, :);
%                 i = constraint(1);
%                 j = constraint(2);
%                 
%                 a = obj.vertices(i, :);
%                 b = obj.vertices(j, :);
%                 
%                 n = ceil(norm(a - b) / density);
%                 
%                 p = [];
%                 
%                 if norm(a(1) - b(1)) > norm(a(2) - b(2))
%                     % Horizontal line
%                     px = linspace(a(1), b(1), n);
%                     p = [ px', repmat(a(2), n, 1) ];
%                 else
%                     % Vertical line
%                     py = linspace(a(2), b(2), n);
%                     p = [ repmat(a(1), n, 1), py' ];
%                 end
%                 
%                 points = [ points; p(2:end-1, :) ];
%                 num_additional_constraints = size(p, 1) - 2;
%                 indices = transpose(N+1:N+num_additional_constraints);
%                 c = [ i, indices(1);
%                 
% %                 N = size(points, 1);
% %                 indices = transpose(N+1:N+n-2);
% %                 points(indices, :) = p;
% %                 new_constraints = [ new_constraints;
% %                     indices, circshift(indices, -1) ];
%             end
            
            tri = delaunayTriangulation(points, obj.constraints);
        end
    end
end
