
%Load the fbrfiles given the numbers of the Anzatz operator and equation
%Operador
%LoadDir = the directory where the files are LoadDirectory
%NOperadoresY = Number of Anzatopertor
%NOperadoresX = Number of Eq operator
%varargin Extra parameter of FBR function
function [fbrGram,fbrAnzatz] = LoadFbrFiles(LoadDir,NOperadoresY,NOperadoresX,varargin)
dim = 2; %por el momento solo dim=2
addpath(LoadDir);
n = NOperadoresY;
m = NOperadoresX;
this = varargin; 

fbrAnzatz   = cell([n,dim+1]); 
fbrGram = cell([n,m]);      


for j= 1:m
    for i= 1:n     
        name = ['fbrGram',num2str(i),num2str(j)];
        fh = str2func(name);
        ffaux  = @(varargin) fh(varargin{:},this{:});
        fbrGram(i,j) = {ffaux};       
    end
end

for i= 1:dim+1
    for j= 1:n
               name = ['fbrAnzatz',num2str(i),num2str(j)];
               fh = str2func(name);
               ffaux  = @(varargin) fh(varargin{:},this{:});
               fbrAnzatz(j,i) = {ffaux};    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
