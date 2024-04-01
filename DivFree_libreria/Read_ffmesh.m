%Funcion que regresa puntos interiores y de Frontera en [0,1]
% h = 1/N

function [ p_in, p_f ] = Read_ffmesh(archivo)

%'circle_control.msh'
[points seg tri]=importfilemesh(archivo);
p = points';
indexx = (p(:,1).^2 + p(:,2).^2 ) < (1-0.0000001) ;
p_f = p(~indexx,:);
p_in = p(indexx,:);


hold on
plot(p_f(:,1),p_f(:,2),'o')
plot(p_in(:,1),p_in(:,2),'o')
hold off
end
