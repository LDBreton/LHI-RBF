function [Indices_sups,distancepp] = LHI_index_allboundary(P_sc, P_fc,n_stencial_sc1,n_stencial_sc2,BStart,BEnds)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_sc), 3]);

[Indices_sc,distancepp] =  LocalIndexSelect(P_sc, {P_sc},n_stencial_sc1);
[Indices_fc,distancepp2] =  LocalIndexSelect(P_sc, {P_fc},n_stencial_sc2);

        for i=1:length(P_sc)
        Indices_sups(i,1) = {Indices_sc{i,1}(BStart(1):end-BEnds(1))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,2) = {Indices_fc{i,1}(BStart(2):end-BEnds(2))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,3) = {Indices_sc{i,1}(BStart(3):end-BEnds(3))};
        end
end

