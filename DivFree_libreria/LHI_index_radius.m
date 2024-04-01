function [Indices_sups,distancepp] = LHI_index_radius(P_sc, P_fc,radiuos,varargin)

%arreglo para los inidices de cada disco local
Indices_sups = cell([length(P_sc), 3]);


if(isempty(varargin))
[Indices_supaux,distancepp] =  LocalIndexSelectRadius(P_sc, {P_sc;P_fc},radiuos);
Indices_sups(:,1:2) = Indices_supaux;
    for i=1:length(P_sc)
    Indices_sups(i,3) = {Indices_supaux{i,1}(2:end)};
    end
else
Start = varargin{:};    
[Indices_supaux,distancepp] =  LocalIndexSelectRadius(P_sc, {P_sc;P_fc},radiuos,Start);
Indices_sups(:,1:2) = Indices_supaux;    

   if(Start(1) ~=1)
        for i=1:length(P_sc)
        Indices_sups(i,3) = {Indices_supaux{i,1}(1:end)};
        end
   else
       for i=1:length(P_sc)
        Indices_sups(i,3) = {Indices_supaux{i,1}(Start(1):end)};
        end
   end  
end
end
