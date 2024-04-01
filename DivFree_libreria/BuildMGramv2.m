function MGram = BuildMGram(fbrGram,Puntos,Centros,Tipo,varargin)

[M N] = size(fbrGram);
CellMgram = cell([N,M]);
 for i=1:length(Centros)
        for j= 1:length(Puntos)
            CellMgram(i,j) = {Tipo(distancematrix(Puntos{j},Centros{i},fbrGram{j},varargin{:}))};
        end
 end

MGram = cell2mat(CellMgram);

end
