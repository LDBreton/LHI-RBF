
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



%fbrGram{1,3} equivale a OperadoresX(3) [OperadoresY(1)(Phi)];
%fbrGram{2,4} equivale a OperadoresX(4) [OperadoresY(2)(Phi)];

%fbrAnzatz{1,:} equivale a multioperator(Phi,L1y);
%fbrAnzatz{1,1} equivale a (multioperator(Phi,L1y))(1);
%fbrAnzatz{1,2} equivale a (multioperator(Phi,L1y))(2);
function [fbrGram,fbrAnzatz] = Fbr_Sym_Anzat(sym_vars,fbr,OperadoresY,OperadoresX,varargin)
dim = 2; %por el momento solo dim=2
syms(sym_vars);
assume(sym(sym_vars(1:end)),'real')

vars_sym =  sym(sym_vars);
this = varargin;
NOperadoresY = length(OperadoresY);
NOperadoresX = length(OperadoresX);
 
 
 lapfbr = laplacian(fbr,[x1,y1]);
 %el anzath para la parte vectorial de wendland
 Phi_div  =  jacobian(gradient(fbr,[x1,y1]),[x1 , y1]) ...
           - [lapfbr, 0 ; 0 , lapfbr] ;
       
 %matriz de funcioanl de wendland
 Phi      = [  [Phi_div , zeros(length(Phi_div),1) ] ; ...
               [zeros(1,length(Phi_div)) , fbr] ];

%funcion auxiliar para el Anzats           
fbrAnzatzaux   = cell([NOperadoresY,1]);

fbrAnzatz   = cell([NOperadoresY,dim+1]); 
fbrGram = cell([NOperadoresY,NOperadoresX]);      

%%%%%%%%%%%%%%%%%%Calculos symbolicos
for j= 1:NOperadoresY
    fbrAnzatzaux(j) = {multioperator(Phi,OperadoresY{j},sym_vars)};
end


for j= 1:NOperadoresX
    for i= 1:NOperadoresY 
        fbraux = multioperator((fbrAnzatzaux{i}),OperadoresX{j},sym_vars);
            fbraux = matlabFunction(fbraux,'vars',vars_sym);
            ffaux  = @(varargin) fbraux(varargin{:},this{:});
            fbrGram(i,j) = {ffaux};       
    end
end

for i= 1:dim+1
    for j= 1:NOperadoresY
               fbraux = matlabFunction(fbrAnzatzaux{j}(i),'vars',vars_sym);
               ffaux  = @(varargin) fbraux(varargin{:},this{:});
               fbrAnzatz(j,i) = {ffaux};    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
