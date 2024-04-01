function [Indices_sups,distancepp] = LHI_index_good(P_sc, P_fc,n_stencial_sc,varargin)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_sc), 3]);


if(isempty(varargin))
[Indices_supaux,distancepp] =  LocalIndexSelect(P_sc, {P_sc;P_fc},n_stencial_sc);
Indices_sups(:,1:2) = Indices_supaux;
    for i=1:length(P_sc)
    Indices_sups(i,3) = {Indices_supaux{i,1}(2:end)};
    end
else
Start = varargin{:};    
[Indices_supaux,distancepp] =  LocalIndexSelect(P_sc, {P_sc;P_fc},n_stencial_sc);
Indices_sups(:,1:2) = Indices_supaux;    
        for i=1:length(P_sc)
        Indices_sups(i,1) = {Indices_supaux{i,1}(Start(1):end)};
        Indices_sups(i,2) = {Indices_supaux{i,2}(Start(2):end)};
        Indices_sups(i,3) = {Indices_supaux{i,1}(Start(3):end)};
        end 
end
end
