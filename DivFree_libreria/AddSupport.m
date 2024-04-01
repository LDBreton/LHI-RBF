
function [fbrGram,fbrAnzatz] = AddSupport(fbrGram,fbrAnzatz,supporFunc)
dim = 2; %por el momento solo dim=2

[n,m] = size(fbrGram);


for j= 1:m
    for i= 1:n 
       ffaux  = @(varargin) supporFunc(varargin{1:4}).*fbrGram{i,j}(varargin{:});
        fbrGram(i,j) = {ffaux};       
    end
end

for i= 1:dim+1
    for j= 1:n
                ffaux  = @(varargin) supporFunc(varargin{1:4}).*fbrAnzatz{j,i}(varargin{:});
               fbrAnzatz(j,i) = {ffaux};    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
