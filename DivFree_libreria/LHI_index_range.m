function [Indices_sups,distancepp] = LHI_index_range(P_sc, P_fc,radius,BStart,BEnds)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_sc), 3]);

[Indices_supaux,distancepp] =  LocalIndexSelect_range(P_sc, {P_sc;P_fc},radius);
        for i=1:length(P_sc)
        Indices_sups(i,1) = {Indices_supaux{i,1}(BStart(1):end-BEnds(1))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,2) = {Indices_supaux{i,2}(BStart(2):end-BEnds(2))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,3) = {Indices_supaux{i,1}(BStart(3):end-BEnds(3))};
        end
end

