classdef pdedomain < handle
    properties(SetAccess = private)
        geometry = [];
        
        materials;
    end
    
    methods
        function obj = pdedomain(default_material, csg)
            gstat = csgchk(csg);
            if any(gstat)
                error('Error in CSG geometry. Consult csgchk docs.');
            end
            
            obj.materials = default_material;
            obj.geometry = csg;
        end
        
        function add_csg(obj, material, csg)
            if size(csg, 2) > 1
                error('Only single-column csg supported.');
            end
            
            gstat = csgchk(csg);
            if any(gstat)
                error('Error in CSG geometry. Consult csgchk docs.');
            end
            
            if isempty(obj.geometry)
                obj.geometry = csg;
            else
                num_csg_rows = size(csg, 1);
                obj.geometry(1:num_csg_rows, end+1) = csg;
            end
            
            obj.materials(end+1) = material;
        end
        
        function add_rectangle(obj, material, x0, y0, x1, y1)
            assert(x0 < x1, 'x0 must be smaller than x1');
            assert(y0 < y1, 'y0 must be smaller than y1');
            
            rect_csg = obj.rectcsg(x0, y0, x1, y1);            
            obj.add_csg(material, rect_csg);
        end
        
        function [tri, M] = triangulate(obj, varargin)
            h = Inf;
            if nargin == 2
                h = varargin{1};
                assert(h > 0);
            elseif nargin > 2
                error('Too many inputs');
            end
            
            [g, region_table] = decsg(obj.geometry);
            [P, ~, T] = initmesh(g, 'Hmax', h);
            num_triangles = size(T, 2);
            
            region_map = obj.map_regions_to_geometries(region_table);
            M = repmat(obj.materials(1), 1, num_triangles);
            for t = 1:num_triangles
                geometry_index = region_map(T(4, t));
                M(t) = obj.materials(geometry_index);
            end
            
            tri = triangulation(T(1:3, :)', P');
        end
    end
    
    methods(Static)
        function dom = create_rectangular(default_material, x0, y0, x1, y1)
            rect_csg = geometry.pdedomain.rectcsg(x0, y0, x1, y1);
            dom = geometry.pdedomain(default_material, rect_csg);
        end
    end
    
    methods(Static, Access = private)
        function map = map_regions_to_geometries(region_table)
            num_regions = size(region_table, 1);
            num_geometries = size(region_table, 2);
            map = zeros(num_regions, 1);
            geometries = 1:num_geometries;
            
            % Create a mapping from regions to geometries such that
            % each region maps to exactly one (unique) geometry.
            % Order the regions by how many geometries they contain
            % and starting with the "smallest regions", successively
            % map geometries that are not mapped to any region to the
            % current region.
            region_counts = sum(region_table, 2);
            [~, index_map] = sortrows(region_counts);
            for i = 1:num_regions
                region = index_map(i);
                geometries_in_region = region_table(region, :) == 1;
                mapped_geometries = ismember(geometries, map);
                region_geometry = geometries(geometries_in_region & ~mapped_geometries);
                
                assert(numel(region_geometry) == 1, ...
                    'Multiple identical geometries detected. Aborting...');
                map(region) = region_geometry;
            end
        end
        
        function csg = rectcsg(x0, y0, x1, y1)
            csg = [
                3;
                4;
                x0;
                x0;
                x1;
                x1;
                y0;
                y1;
                y1;
                y0;
                ];
        end
    end
end
