%Contruye la matrix de distancias y aplica el operador
% Input: Puntos  matrix Nx2
% Input: centros matrix Mx2
% output: Matrix NxM 
%  Mass_ij = operator(Puntos_i-centros_j)

function [Mass] = distancematrix(Puntos,Centros,operator,varargin)

if (isempty(Puntos) || isempty(Centros))
    Mass = [];
else

%calcula las combinaciones de las restas de las coordenanas    
[dr,cc] = ndgrid(Puntos(:,1),Centros(:,1));
[dr1,cc1] = ndgrid(Puntos(:,2),Centros(:,2));
%%%%

%dr_ij =  Puntos_i_1
%cc_ij =  centros_j_1
%dr1_ij = Puntos_i_2
%cc1_ij = centros_j_2


Mass = operator(dr,dr1,cc,cc1,varargin{:});

%En caso que usemos algo como rlog(r)
Mass(isnan(Mass))=0;

%Si el operador el la funcion cero
%para no tener porblemas de dimensiones
if(Mass == 0)
    Mass = zeros(size(dr));
end



end
