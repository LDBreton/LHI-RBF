%Funcion para obtener:
%f1,f2,dirchi1,dirchi2,p_exact_x,p_exact_y
%Usnado la solucion exacta de Wendland

function [f1m,f2m,u_exact1,u_exact2,p_x,p_y] = Exact_sol(var_muu)
syms( {'x', 'y','muu','varpi'} )

symu_exact1 = -varpi*y*sin((varpi/2)*(x.^2 + y.^2));
symu_exact2 = varpi*x*sin((varpi/2)*(x.^2 + y.^2));
p_exact = sin((x-y));

f1 = -muu*laplacian(symu_exact1,[x,y]) + diff(p_exact,x);
f2 = -muu*laplacian(symu_exact2,[x,y]) + diff(p_exact,y);

p_x_aux = matlabFunction(diff(p_exact,x),'vars',[x y]);
p_x = @(puntos) p_x_aux(puntos(:,1),puntos(:,2));

p_y_aux = matlabFunction(diff(p_exact,y),'vars',[x y]);
p_y = @(puntos) p_y_aux(puntos(:,1),puntos(:,2));




f1_aux = matlabFunction(f1,'vars',[x y muu varpi]);
f1m = @(puntos) f1_aux(puntos(:,1),puntos(:,2),var_muu,pi);

f2_aux = matlabFunction(f2,'vars',[x y muu varpi]);
f2m = @(puntos) f2_aux(puntos(:,1),puntos(:,2),var_muu,pi);

u_exact1_aux = matlabFunction(symu_exact1,'vars',[x y muu varpi]);
u_exact1 = @(puntos) u_exact1_aux(puntos(:,1),puntos(:,2),var_muu,pi);

u_exact2_aux = matlabFunction(symu_exact2,'vars',[x y muu varpi]);
u_exact2 = @(puntos) u_exact2_aux(puntos(:,1),puntos(:,2),var_muu,pi);


end
