%Funcion para selection puntos cercanos

%Input:  Punto --centro del circulo
%Input:  P_sc  --Puntos interiores
%Input:  P_fc  --Puntos de frontera
%Inputo: N_sup --numero de puntos cercanos que se quieren seleccionar

%Output: P_sclocal --puntos interiores selecionados
%Output: P_sclocal --puntos de fonrtera selecionados
%Output: scindx    -- indices de puntos interiores selecionados
%Output: fcindx    -- indices de puntos de fonrtera selecionados

function [point_class,indx_class,indx,d] =localselection( Punto,Cell_tot, N_sup)

N_class = length(Cell_tot);
Size_class = zeros(N_class,1);

indx_class   = cell([1,N_class]); 
point_class = cell([1,N_class]); 

Ptot = cell2mat(Cell_tot);

%funcion de matlab  
[indx,d]=knnsearch(Ptot,Punto,'k',N_sup);

for i =1:N_class
    a = sum(Size_class);
    Size_class(i) = length(Cell_tot{i});
    b = sum(Size_class);
    
    localindex = (indx <= b & indx > a);
    localindex = indx(localindex);
     
    point_class(i) = {Ptot(localindex,:)};
    
    indx_class(i)  = {localindex-a};

    
end




end
