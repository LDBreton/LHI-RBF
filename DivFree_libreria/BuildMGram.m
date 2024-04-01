function MGram = BuildMGram(fbrGram,Puntos,Centros,Tipo,varargin)

[M N] = size(fbrGram);
CellMgram = cell([N,M]);
 for i=1:length(Puntos)
        for j= 1:length(Centros)
            CellMgram(i,j) = {Tipo(distancematrix(Puntos{i},Centros{j},fbrGram{j,i},varargin{:}))};
        end
 end

MGram = cell2mat(CellMgram);

end
