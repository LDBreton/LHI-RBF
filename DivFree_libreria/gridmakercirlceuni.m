%Funcion que regresa puntos interiores y de Frontera en [0,1]
% h = 1/N

function [ p_in, p_f ] = gridmakercirlceuni(N)
fd=@(p) dcircle(p,0,0,1);
[p,t]=distmesh2d(fd,@huniform,1/N,[-1,-1;1,1],[]);
%[p,t]=distmesh2d(fd,fh,1/N,[-1,-1;1,1],[]);


indexx = abs(p(:,1).^2 + p(:,2).^2 - 1) < 0.0000001 ;
p_f = p(indexx,:);
p_in = p(~indexx,:);


plot(p_f(:,1),p_f(:,2),'o')
hold on
plot(p_in(:,1),p_in(:,2),'o')
end

