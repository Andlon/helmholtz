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

        function tri = triangulate(obj)
            tri = delaunayTriangulation(obj.vertices, obj.constraints);
        end
    end
end
