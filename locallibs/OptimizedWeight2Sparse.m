function [SY,SB,SL] = OptimizedWeight2Sparse(Indices_sup,P_sc,P_fc,pesos)
% pack;%%%free memory
N_sc  = length(P_sc);
N_fc  = length(P_fc);
N_pde = length(P_sc);

%number of non zero elements
Nz = 0;
NPesos = length(pesos(:,1));
NOperatosW = length(pesos(1,:));

%calculate non zero elements
for j=1:NPesos
    Nz =  Nz + length(pesos(j,1));
end

%Alloc space for the sparse matrix
ColsizeSw = 2*N_sc + 2*N_fc + 2*N_pde;
RowsizeSW = NPesos*NOperatosW;

SparseW = [];
for i = 1:NOperatosW
    for j = 1:NPesos
        
        scindx_aux = Indices_sup{j,1};
        fcindx_aux = Indices_sup{j,2};
        pdecindx_aux = Indices_sup{j,3};
        
        scindx   = [scindx_aux,scindx_aux+N_sc];
        fcindx   = [fcindx_aux+2*N_sc,fcindx_aux+2*N_sc+N_fc];
        pdecindx = [pdecindx_aux+2*N_sc+2*N_fc,pdecindx_aux+2*N_sc+2*N_fc+N_pde];
        
        ind = [scindx,fcindx,pdecindx];
        
        SparseW=vertcat(SparseW,sparse(1,ind,pesos{j,i},1,ColsizeSw,length(ind)));
%         if(mod(i,1000)==0)
%         pack
%         end
    end
end

SY = SparseW(:,1:2*N_sc);
SB = SparseW(:,(2*N_sc+1):(2*N_sc+2*N_fc));
SL = SparseW(:,(2*N_sc+2*N_fc+1):ColsizeSw);


