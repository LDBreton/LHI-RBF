function [Indices_sup,distancepp] = LHI_index_old(P_sc, P_fc,n_stencial_sc)
 
%%%%%%%%%%%%%Obteniendo los indices%%%%%%%%%%%%%%
nn_p_sc = length(P_sc);
 
%arreglo para los inidices de cada disco local
Indices_sup = cell([nn_p_sc, 3]);
 
%arreglo de las distancias delta_x _max en el disco local
distancepp = zeros(nn_p_sc,1);
 
%comenzamos a obtener los puntos cercanos para cada punto interior
for i = 1:nn_p_sc
%centro del disco    
Punto = P_sc(i,:);
%encnotrando los puntos cercanos
[point_class,indx_class,indx,d] =localselection( Punto,{P_sc;P_fc}, n_stencial_sc);
 
%point_class{1} son los puntos cercanos P_sc a Punto 
%point_class{2} son los puntos cercanos P_fc a Punto (si no hay puntos cerca de la frontera es vacio)
 
%indx_class{1} son indices de los puntos cercanos P_sc a Punto 
%indx_class{2} son indices de los puntos cercanos P_fc a Punto (si no hay puntos cerca de la frontera es vacio)
 
%los indices de P_sc
Indices_sup(i,1) = {indx_class{1}(2:end)};
 
%los indices de P_fc
Indices_sup(i,2) = {indx_class{2}(1:end)};
 
%los indices de P_pdec, en este caso son los mismo que los de P_sc sin el primer indice que corresponde a Punto
Indices_sup(i,3) = {indx_class{1}(2:end)};
 
%maximo de las distancias de los puntos
distancepp(i) = max(d);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 