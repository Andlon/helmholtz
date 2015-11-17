classdef pdedomain < handle
    % pdedomain     An incremental representation of a 2D domain.
    %
    %   pdedomain facilitates easy construction of complex 2D domain 
    %   triangulations built from basic shapes. 
    %   Moreover, pdedomain abstracts the management of local element
    %   properties by introducing the concept of "materials", which are
    %   merely user-defined structs that contain arbitrary information
    %   about each element. The type of the material struct is determined
    %   from the material of the first geometry added. Subsequent
    %   insertions must conform to the same type of struct (i.e., the
    %   material structs must have the same fields).
    %
    %   Adding multiple shapes will automatically
    %   generate intersections. When adding shapes that intersect, 
    %   the intersection inherits the material of the shape that was added 
    %   last.
    %
    %   Under the hood, pdedomain uses MATLAB's PDE toolbox for geometry
    %   management and mesh generation/refinement.
    %
    %   Examples:
    %       % Define the materials to be used in the domain.
    %       % The materials can consist of fields of any names. Let's use
    %       % density here for intuition.
    %       wood.density = 0.6;
    %       marble.density = 2.71;
    %   
    %       % Set up our domain and add some geometries
    %       dom = geometry.pdedomain;
    %       dom.add_circle(wood, [0, 0], 1);
    %       dom.add_rectangle(marble, 0, 0, 1, 1);
    %
    %       % Generate triangulation and material map with maximum edge
    %       % length requirement.
    %       h_max = 0.1;
    %       [tri, materials] = dom.triangulate(h_max);
    %
    %       % Plot map of triangulation with materials. Note that 
    %       % we need to provide a function that maps materials to values
    %       % that can be used to distinguish between different materials,
    %       % since material_triplot does not know the fields of our
    %       % material structs.
    %       geometry.material_triplot(tri, materials, @(mat) mat.density);
    %
    %       See also GEOMETRY.MATERIAL_TRIPLOT.
    
    properties(SetAccess = private)
        geometry;
        materials;
    end
    
    methods
        function add_csg(obj, material, csg)
            % ADD_CSG Add geometry specified by CSG to domain.
            %   ADD_CSG(dom, material, csg) adds the geometry specified by
            %   by csg in a Geometry Description matrix (refer to the
            %   PDE toolbox documentation) with the given material to the
            %   current domain.
            %
            %   NOTE: This is a low-level function. Use the convenience
            %   functions ADD_RECTANGLE, ADD_POLYGON or ADD_CIRCLE
            %   if you can.
            %
            %   See also ADD_RECTANGLE, ADD_POLYGON, ADD_CIRCLE.
            
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
            
            if isempty(obj.materials)
                obj.materials = material;
            else
                obj.materials(end+1) = material;
            end
        end
        
        function add_rectangle(obj, material, x0, y0, x1, y1)
            % ADD_RECTANGLE Add rectangle to domain.
            %   ADD_RECTANGLE(dom, material, x0, y0, x1, y1) adds the
            %   rectangle with lower-left corner (x0, y0) and top-right
            %   corner (x1, y1) with the given material to the current
            %   domain.
            %
            %   See also ADD_POLYGON, ADD_CIRCLE, ADD_CSG.
            
            assert(x0 < x1, 'x0 must be smaller than x1');
            assert(y0 < y1, 'y0 must be smaller than y1');
            
            rect_csg = obj.rectcsg(x0, y0, x1, y1);
            obj.add_csg(material, rect_csg);
        end
        
        function add_polygon(obj, material, P)
            % ADD_POLYGON Add polygon to domain.
            %   ADD_POLYGON(dom, material, P) adds the polygon specified by
            %   the Nx2 matrix P, where each row represents a point of the
            %   polygon such that the points represented by rows i and
            %   (i -1) are connected by an edge. The polygon will
            %   be composed of the given material.
            %
            %   See also ADD_RECTANGLE, ADD_CIRCLE, ADD_CSG.
            
            poly_csg = obj.polycsg(P);
            obj.add_csg(material, poly_csg);
        end
        
        function add_circle(obj, material, center, radius)
            % ADD_CIRCLE Add circle to domain.
            %   ADD_CIRCLE(dom, material, center, radius) adds the circle
            %   with the given center (must be a 2-element vector) and
            %   radius (must be positive scalar) to the domain.
            %
            %   See also ADD_RECTANGLE, ADD_POLYGON, ADD_CSG.
            
            circle_csg = obj.circlecsg(center, radius);
            obj.add_csg(material, circle_csg);
        end
        
        function [tri, M] = triangulate(obj, varargin)
            % TRIANGULATE Generate mesh triangulation for the domain.
            %   [tri, M] = TRIANGULATE(dom) returns the coarsest possible
            %   triangulation tri of the domain dom. M is a T-element
            %   struct array representing the materials of each triangle,
            %   where T = size(tri, 1).
            %
            %   [tri, M] = TRIANGULATE(dom, h) returns a triangulation
            %   whose maximum edge size is bounded by h, which must be a
            %   positive scalar.
            
            h = Inf;
            if nargin == 2
                h = varargin{1};
                assert(isscalar(h) && h > 0, 'h must be positive');
            elseif nargin > 2
                error('Too many inputs');
            end
            
            % Generate geometry and mesh
            [g, region_table] = decsg(obj.geometry);
            [P, ~, T] = initmesh(g, 'Hmax', h);
            num_triangles = size(T, 2);
            
            % Assign materials to individual triangles
            region_map = obj.map_regions_to_geometries(region_table);
            M = repmat(obj.materials(1), 1, num_triangles);
            for t = 1:num_triangles
                geometry_index = region_map(T(4, t));
                M(t) = obj.materials(geometry_index);
            end
            
            tri = triangulation(T(1:3, :)', P');
        end
    end
    
    methods(Static, Access = private)
        function map = map_regions_to_geometries(region_table)
            num_regions = size(region_table, 1);
            map = zeros(num_regions, 1);
            
            % Each region gets mapped to the last geometry that was added
            % that is part of the region
            for i = 1:num_regions
                map(i) = find(region_table(i, :) == 1, 1, 'last');
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
        
        function csg = polycsg(P)
            assert(size(P, 2) == 2, 'P must be an Nx2 matrix of polygon points.');
            N = size(P, 1);
            csg = [
                2;
                N;
                P(:, 1);
                P(:, 2);
                ];
        end
        
        function csg = circlecsg(center, radius)
            assert(numel(center) == 2, 'center must be a 2-element vector.');
            assert(isscalar(radius) && radius > 0, 'radius must be a postive scalar.');
            center = reshape(center, 2, 1);
            
            csg = [
                1;
                center;
                radius
                ];
        end
    end
end
