function [SY,SB,SL] = FastWeight2Sparse(Indices_sup,Pre,pesosW)
N_sc  = length(Pre.P_sc);
N_fc  = length(Pre.P_fc);
N_pde = length(Pre.P_sc);

%number of non zero elements
NPesos = length(pesosW(:,1));
NOperatosW = length(pesosW(1,:));

%calculate non zero elements


%Alloc space for the sparse matrix
ColsizeSw = 2*N_sc + 2*N_fc + 2*N_pde;
RowsizeSW = NPesos*NOperatosW;

Nz =0; 
for i = 1:NOperatosW
    for j = 1:NPesos
        scindx_aux = Indices_sup{j,1};
        fcindx_aux = Indices_sup{j,2};
        pdecindx_aux = Indices_sup{j,3};
        
        scindx   = [scindx_aux,scindx_aux+N_sc];
        fcindx   = [fcindx_aux+2*N_sc,fcindx_aux+2*N_sc+N_fc];
        pdecindx = [pdecindx_aux+2*N_sc+2*N_fc,pdecindx_aux+2*N_sc+2*N_fc+N_pde];
        
        ind = [scindx,fcindx,pdecindx]';
        Nz = Nz + length(ind);
    end
end


PesosSparse = [];
for i = 1:NOperatosW
    PesosSparseaux = double(cell2mat(pesosW(:,i)')');
    PesosSparse = [PesosSparse;PesosSparseaux];
end

SparseIdx = (zeros(Nz,2));
Nzaux = 0;
for i = 1:NOperatosW
    for j = 1:NPesos
        scindx_aux = Indices_sup{j,1};
        fcindx_aux = Indices_sup{j,2};
        pdecindx_aux = Indices_sup{j,3};
        
        scindx   = [scindx_aux,scindx_aux+N_sc];
        fcindx   = [fcindx_aux+2*N_sc,fcindx_aux+2*N_sc+N_fc];
        pdecindx = [pdecindx_aux+2*N_sc+2*N_fc,pdecindx_aux+2*N_sc+2*N_fc+N_pde];
        
        ind = [scindx,fcindx,pdecindx]';
        SparseIdx(Nzaux+1:Nzaux+length(ind),1) = repmat(j+(i-1)*NPesos,length(ind),1);
        SparseIdx(Nzaux+1:Nzaux+length(ind),2) = ind;
%       C{j+(i-1)*NPesos} = mp(sparse(1,ind,pesosW{j,i}',1,ColsizeSw,length(ind)));
        Nzaux = Nzaux + length(ind);
    end
end
SparseW = sparse(SparseIdx(:,1),SparseIdx(:,2),PesosSparse,RowsizeSW,ColsizeSw);
SY = SparseW(:,1:2*N_sc);
SB = SparseW(:,(2*N_sc+1):(2*N_sc+2*N_fc));
SL = SparseW(:,(2*N_sc+2*N_fc+1):ColsizeSw);


