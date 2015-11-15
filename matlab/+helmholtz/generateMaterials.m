function materials = generateMaterials(k,N)
% makeMaterials: Generates a vector of structs that has the same
% wavenumber


for i = 1:N
    materials(i) = struct('wavenumber',k);
end

end

