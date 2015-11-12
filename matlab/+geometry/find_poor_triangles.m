function Q = find_poor_triangles( tri, h, varargin )

T = size(tri, 1);
Q = zeros(0, 3);
searchspace = 1:T;

if nargin == 3
    searchspace = varargin{1};
    searchspace = reshape(searchspace, 1, numel(searchspace));
end

[~, rin] = tri.incenter();
d_inscribed = rin * 2;

for t = searchspace
    vertex_indices = tri.ConnectivityList(t, :);
    vertices = tri.Points(vertex_indices, :);
    sides = vertices - circshift(vertices, 1);
    diameter = max(sqrt(sum(sides.^2, 2)));
    
    % Is this the correct computation of the ratio we're looking for?
    % TODO: Find out
    ratio = diameter / d_inscribed(t);
    
    % What's an appropriate threshold for ratio?
    if ratio > 8 || diameter > h
       Q(end+1, :) = vertex_indices;
    end
end

end

