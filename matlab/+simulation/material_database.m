classdef material_database
    properties(SetAccess = private)
        air = struct('permeability', 1, 'permittivity', 1);
        vacuum = struct('permeability',1,'permittivity',1);
        water = struct('permeability',0.999992,'permittivity', 80 + 0.157 * 80i);
        sapphire = struct('permeability',0.99999976,'permittivity', 10);
        teflon = struct('permeability',1, 'permittivity', 2.1 - 2.1i);
        
        % Source: http://www.rfcafe.com/references/electrical/dielectric-constants-strengths.htm
        wood = struct('permeability', 1, 'permittivity', 1.8 - 1.8 * 0.03i);
        
    end
end

