function [Indices_sups,distancepp] = LHI_index_boundary(P_sc, P_fc,n_stencial_sc,BStart,BEnds)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_fc), 3]);

[Indices_supaux,distancepp] =  LocalIndexSelect(P_fc, {P_sc;P_fc},n_stencial_sc);
        for i=1:length(P_fc)
        Indices_sups(i,1) = {Indices_supaux{i,1}(BStart(1):end-BEnds(1))};
        end
        for i=1:length(P_fc)
        Indices_sups(i,2) = {Indices_supaux{i,2}(BStart(2):end-BEnds(2))};
        end
        for i=1:length(P_fc)
        Indices_sups(i,3) = {Indices_supaux{i,1}(BStart(3):end-BEnds(3))};
        end
end

