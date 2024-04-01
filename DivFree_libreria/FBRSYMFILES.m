
%Contruye el Anzath de Collocacion fbrAnzatz
%Contruye las funciones para la matrix de Gram fbrGram

%input: Fbr  la funcion de base radial
%input: OperadoresY Operadores para el anzath
%input: OperadoresX Operadores para la matriz de Gram
%input: varargin si el fbr tiene el parametro de forma como variable

%output: fbrAnzatz el Anzath de Collocacion
%output: fbrGram funciones para la matrix de Gram

%Ejemplo
%OperadoresY = {L1y,L2y,B1,B2};
%OperadoresX = {L1,L2,B1,B2};

%output
%fbrGram{1,3} equivale a B1(multioperator(Phi,L1y));
%fbrGram{2,4} equivale a B2(multioperator(Phi,L2y));

%fbrAnzatz{1,:} equivale a multioperator(Phi,L1y);
%fbrAnzatz{1,1} equivale a (multioperator(Phi,L1y))(1);
%fbrAnzatz{1,2} equivale a (multioperator(Phi,L1y))(2);
function FBRSYMFILES(SaveDire,sym_vars,fbr,OperadoresY,OperadoresX,varargin)
dim = 2; %por el momento solo dim=2
syms(sym_vars);
assume(sym(sym_vars(1:end)),'real')
syms rsq(x1,y1,x2,y2)

vars_sym =  sym(sym_vars);
n = length(OperadoresY);
m = length(OperadoresX);

fbr = subs(fbr,(x1-x2)^2 + (y1-y2)^2,rsq);

lapfbr = laplacian(fbr,[x1,y1]);
%el anzath para la parte vectorial de wendland
Phi_div  =  jacobian(gradient(fbr,[x1,y1]),[x1 , y1]) ...
    - [lapfbr, 0 ; 0 , lapfbr] ;

%matriz de funcioanl de wendland
Phi      = [  [Phi_div , zeros(length(Phi_div),1) ] ; ...
    [zeros(1,length(Phi_div)) , fbr] ];

%funcion auxiliar para el Anzats
fbrAnzatzaux   = cell([n,1]);


%%%%%%%%%%%%%%%%%Calculos symbolicos
for j= 1:n
    fbrAnzatzaux(j) = {multioperator(Phi,OperadoresY{j},sym_vars)};
end


for j= 1:m
    for i= 1:n
        fbraux = multioperator((fbrAnzatzaux{i}),OperadoresX{j},sym_vars,1);
        fbraux = subs(fbraux,rsq,(x1-x2)^2 + (y1-y2)^2);
        name = ['fbrGram',num2str(i),num2str(j)];
        matlabFunction(fbraux,'File',[SaveDire,name],'vars',vars_sym);
    end
end

for i= 1:dim+1
    for j= 1:n
        fbraux = fbrAnzatzaux{j}(i);
        fbraux = subs(fbraux,rsq,(x1-x2)^2 + (y1-y2)^2);
        name = ['fbrAnzatz',num2str(i),num2str(j)];
        matlabFunction(fbraux,'File',[SaveDire,name],'vars',vars_sym);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
