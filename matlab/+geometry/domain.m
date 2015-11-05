classdef domain < handle
    properties(SetAccess = private)
        x0;
        y0;
        x1;
        y1;
        
        % Polygons is an Nx2 cell matrix, where polygons(i, 1)
        % represents a matrix containing the points of a polygon,
        % each row representing a point that is connected with an edge
        % to the point in the previous row, and the first point has an edge
        % to the last point. polygons(i, 2) represents a user-supplied
        % structure that contains properties of polygon i.
        polygons = cell(0, 2);
    end
    
    methods
        function obj = domain(x0, y0, x1, y1)
            obj.x0 = x0;
            obj.x1 = x1;
            obj.y0 = y0;
            obj.y1 = y1;
        end
        
        function add_rectangle(obj, x0, y0, x1, y1)
            assert(obj.x0 <= x0 && obj.y0 <= y0 && ...
                obj.x1 >= x1 && obj.y1 >= y1, ...
                'rectangle must be within bounds of domain');
            assert(x0 < x1, 'x0 must be smaller than x1');
            assert(y0 < y1, 'y0 must be smaller than y1');
            
            points = [
                x0, y0;
                x0, y1;
                x1, y1;
                x1, y0;
                ];
            
            data = struct;
            obj.polygons(end+1, :) = { points, data };
        end
        
        function tri = triangulate(obj)
            poly = obj.polygons(:, 1);
            
            % Add the domain itself as a polygon constraint
            poly{end+1} = [ 
                obj.x0, obj.y0;
                obj.x0, obj.y1;
                obj.x1, obj.y1;
                obj.x1, obj.y0;
                ];
            
            [P, C] = geometry.polygon_constraints(poly);
            tri = delaunayTriangulation(P, C);
        end
    end
end
