function materials = computeWavenumbers(materials,f)
% computeWavenumbers: Computes the wavenumbers of the different materials
% in the vector of structs materials. Adds the field "wavenumber" to each
% struct.

permittivity0 = 8.8541878176 *10^(-12);
permeability0 = 1.2566370614*10^(-6);

N = length(materials);

for i = 1:N
    c = 1 / sqrt(materials(i).permeability * materials(i).permittivity*permittivity0*permeability0);
    k = 2*pi*f/c;
    materials(i).wavenumber = k;
end


end

