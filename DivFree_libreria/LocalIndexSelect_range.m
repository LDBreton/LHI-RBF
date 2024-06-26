function [Indices_sup,distancepp] = LocalIndexSelect_range(P_sc, Cell_tot,radius,varargin)
% Cell_tot = {P_sc;P_fc};
% radius = Apoint(k)*3;

N_class = length(Cell_tot);
Ptot = cell2mat(Cell_tot);
[indPtot,d] = rangesearch(Ptot,P_sc,radius);
%[indPtot,d]=knnsearch(Ptot,P_sc,'K',n_stencial_sc);
Start = ones(N_class,1);
if( ~isempty(varargin))
    Start = varargin{:};
end


%%%%%%%%%%%%%Obteniendo los indices%%%%%%%%%%%%%%
nn_p_sc = length(P_sc);

%arreglo para los inidices de cada disco local
Indices_sup = cell([nn_p_sc, N_class]);

%arreglo de las distancias delta_x _max en el disco local
distancepp = zeros(nn_p_sc,1);

%comenzamos a obtener los puntos cercanos para cada punto interior
for i = 1:nn_p_sc
Size_class = zeros(N_class,1);
distancepp(i) = max(d{i});
for j =1:N_class
    a = sum(Size_class);
    Size_class(j) = length(Cell_tot{j});
    b = sum(Size_class);
    
    CurrentpointIndex = indPtot{i};
    localindex = (CurrentpointIndex <= b & CurrentpointIndex > a);
    localindex = CurrentpointIndex(localindex);   
    indx_class  = {localindex-a};
    Indices_sup(i,j) = {indx_class{1}(Start(j):end)};   

end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

end
