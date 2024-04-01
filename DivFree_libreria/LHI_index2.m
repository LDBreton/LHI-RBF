function Indices_sups = LHI_index2(P_sc,P_sc2, P_fc2,Indices_sup,n_stencial_sc)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_sc), 3]);

[indPtot_in,d]=knnsearch(P_sc2,P_sc,'K',n_stencial_sc);
[indPtot_bc,d]=knnsearch(P_fc2,P_sc,'K',n_stencial_sc);
        for i=1:length(P_sc)
        Indices_sups(i,1) = {indPtot_in(i,1:length(Indices_sup{i,1}))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,2) = {indPtot_bc(i,1:length(Indices_sup{i,2}))};
        end
        for i=1:length(P_sc)
        Indices_sups(i,3) = {indPtot_in(i,1:length(Indices_sup{i,3}))};
        end
end

