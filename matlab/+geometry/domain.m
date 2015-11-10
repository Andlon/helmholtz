classdef domain < handle
    properties(SetAccess = private)
        x0;
        y0;
        x1;
        y1;
        
        % Polygons is an N-length cell array, where polygons{i}
        % represents a matrix containing the points of a polygon,
        % each row representing a point that is connected with an edge
        % to the point in the previous row, and the first point has an edge
        % to the last point.
        polygons = cell(0, 1);
        
        materials;
        default_material;
    end
    
    methods
        function obj = domain(default_material, x0, y0, x1, y1)
            obj.x0 = x0;
            obj.x1 = x1;
            obj.y0 = y0;
            obj.y1 = y1;
            obj.default_material = default_material;
        end
        
        function add_rectangle(obj, material, x0, y0, x1, y1)
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
            
            obj.polygons{end+1} = points;
            
            if isempty(obj.materials)
                obj.materials = material;
            else
                obj.materials(end+1) = material;
            end
        end
        
        function [tri, M] = triangulate(obj, varargin)
            poly = obj.polygons;
            
            % Add the domain itself as a polygon constraint
            poly{end+1} = [
                obj.x0, obj.y0;
                obj.x0, obj.y1;
                obj.x1, obj.y1;
                obj.x1, obj.y0;
                ];
            
            [P, C] = geometry.polygon_constraints(poly);
            tri = delaunayTriangulation(P, C);
            
            if nargin == 2
                h = varargin{1};
                assert(h > 0);
                tri = geometry.refine_triangulation(tri, h);
            elseif nargin > 2
                error('Too many inputs');
            end
            
            M = geometry.assign_materials(tri, obj.polygons, ...
                obj.materials, obj.default_material);
        end
    end
end
