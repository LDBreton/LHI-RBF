function [SYP,SB,SL] = FastWeight2Sparse_mp_new(Indices_sup,Pre,pesosW,varargin)
N_sc  = length(Pre.P_sc);
N_fc  = length(Pre.P_fc);
N_pde = length(Pre.P_sc);



%number of non zero elements
NPesos = length(pesosW(:,1));
NOperatosW =length(pesosW(1,:));

%calculate non zero elements


%Alloc space for the sparse matrix
ColsizeSw = 3*N_sc + 2*N_fc + 2*N_pde;
RowsizeSW = NPesos*NOperatosW;

Nz =0; 
for i = 1:NOperatosW
    for j = 1:NPesos
        scindx_aux = Indices_sup{j,1};
        fcindx_aux = Indices_sup{j,2};
        pdecindx_aux = Indices_sup{j,3};
        
        scindx   = [scindx_aux,scindx_aux+N_sc,scindx_aux+2*N_sc];
        fcindx   = [fcindx_aux+3*N_sc,fcindx_aux+3*N_sc+N_fc];
        pdecindx = [pdecindx_aux+3*N_sc+2*N_fc,pdecindx_aux+3*N_sc+2*N_fc+N_pde];
        
        ind = [scindx,fcindx,pdecindx]';
        Nz = Nz + length(ind);
    end
end


PesosSparse = mp([]);
for i = 1:NOperatosW
    PesosSparseaux = cell2mat(pesosW(:,i)')';
    PesosSparse = [PesosSparse;PesosSparseaux];
end

SparseIdx = (zeros(Nz,2));
Nzaux = 0;
for i = 1:NOperatosW
    for j = 1:NPesos
        scindx_aux = Indices_sup{j,1};
        fcindx_aux = Indices_sup{j,2};
        pdecindx_aux = Indices_sup{j,3};
        
        scindx   = [scindx_aux,scindx_aux+N_sc,scindx_aux+2*N_sc];
        fcindx   = [fcindx_aux+3*N_sc,fcindx_aux+3*N_sc+N_fc];
        pdecindx = [pdecindx_aux+3*N_sc+2*N_fc,pdecindx_aux+3*N_sc+2*N_fc+N_pde];;
        
        ind = [scindx,fcindx,pdecindx]';
        SparseIdx(Nzaux+1:Nzaux+length(ind),1) = repmat(j+(i-1)*NPesos,length(ind),1);
        SparseIdx(Nzaux+1:Nzaux+length(ind),2) = ind;
%       C{j+(i-1)*NPesos} = mp(sparse(1,ind,pesosW{j,i}',1,ColsizeSw,length(ind)));
        Nzaux = Nzaux + length(ind);
    end
end
SparseW = sparse(SparseIdx(:,1),SparseIdx(:,2),PesosSparse,RowsizeSW,ColsizeSw);
SYP = SparseW(:,1:3*N_sc);
SB = SparseW(:,(3*N_sc+1):(3*N_sc+2*N_fc));
SL = SparseW(:,(3*N_sc+2*N_fc+1):ColsizeSw);


