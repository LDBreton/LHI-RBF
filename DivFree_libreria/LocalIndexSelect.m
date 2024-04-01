function [Indices_sup,distancepp] = LocalIndexSelect(Points, Cell_tot,n_stencial_sc,varargin)

N_class = length(Cell_tot);
Ptot = cell2mat(Cell_tot);
[indPtot,d]=knnsearch(Ptot,Points,'K',n_stencial_sc);
Start = ones(N_class,1);
if( ~isempty(varargin))
    Start = varargin{:};
end


%%%%%%%%%%%%%Obteniendo los indices%%%%%%%%%%%%%%
N_points = length(Points);

%arreglo para los inidices de cada disco local
Indices_sup = cell([N_points, N_class]);

%arreglo de las distancias delta_x _max en el disco local
distancepp = zeros(N_points,1);

%comenzamos a obtener los puntos cercanos para cada punto interior
for i = 1:N_points
Size_class = zeros(N_class,1);
distancepp(i) = min(d(i,2:end));
for j =1:N_class
    a = sum(Size_class);
    Size_class(j) = length(Cell_tot{j});
    b = sum(Size_class);
    
    CurrentpointIndex = indPtot(i,:);
    localindex = (CurrentpointIndex <= b & CurrentpointIndex > a);
    localindex = CurrentpointIndex(localindex);   
    indx_class  = {localindex-a};
    Indices_sup(i,j) = {indx_class{1}(Start(j):end)};   

end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

end
