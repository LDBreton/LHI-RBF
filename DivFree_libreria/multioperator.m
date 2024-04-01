%Funcion para aplicar operadores a una matrix symbolica
%| A11 A12 | * L = ( L( A11 A21 ) ; 
%| A21 A22 |         L( A21 A22 ))

%input = Amatrix una matriz symbolica de funciones
%input = Loperator un operador differencial

%output = fvector el vector de funciones
function fvector = multioperator(Amatrix, Loperator,sym_vars,varargin)
%son las variables simbolicas
syms(sym_vars);
assume(sym(sym_vars(1:end)),'real')

[N , M] = size(Amatrix);
fvector = sym(zeros(1,N));

for i=1:N
    fvector(i) = Loperator(Amatrix(i,:));
end

if(isempty(varargin))
fvector = simplify(fvector,'steps',3);
return;
elseif((varargin{1}) == 0)
 return;
else
    fvector = simplify(fvector,'steps',varargin{1});
end
end
