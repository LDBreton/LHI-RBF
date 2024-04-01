function [SY,SB,SL] = Weight2Sparse(Indices_sup,P_sc,P_fc,pesos_rhs)





nn_p_sc = length(P_sc); % cantidad de puntos interiores



%definiendo las matrices sparse como en el articulo
WL1Y1 = (sparse(length(P_sc),length(P_sc)));%W_L1^y1
WL1Y2 = (sparse(length(P_sc),length(P_sc)));%W_L1^y2
WL2Y1 = (sparse(length(P_sc),length(P_sc)));%W_L2^y1
WL2Y2 = (sparse(length(P_sc),length(P_sc)));%W_L2^y2

WL1B1 = (sparse(length(P_fc),length(P_fc)));%W_L1^y1
WL1B2 = (sparse(length(P_fc),length(P_fc)));%W_L1^y2
WL2B1 = (sparse(length(P_fc),length(P_fc)));%W_L2^y1
WL2B2 = (sparse(length(P_fc),length(P_fc)));%W_L2^y2

WL1L1 = (sparse(length(P_sc),length(P_sc)));%W_L1^y1
WL1L2 = (sparse(length(P_sc),length(P_sc)));%W_L1^y2
WL2L1 = (sparse(length(P_sc),length(P_sc)));%W_L2^y1
WL2L2 = (sparse(length(P_sc),length(P_sc)));%W_L2^y2



for i = 1:nn_p_sc

scindx = Indices_sup{i,1};
fcindx = Indices_sup{i,2};   
pdecindx = Indices_sup{i,3}; 

pesos1 = pesos_rhs{i,1};
pesos2 = pesos_rhs{i,2};

%Rellenado la matriz S sparse
n_sclocal = length(scindx);
n_fclocal = length(fcindx);
n_pdelocal = length(pdecindx);

%particiones de los indices de los pesos
index_y1 = 1:n_sclocal;
index_y2 = n_sclocal+1:2*n_sclocal;

index_b1 = 2*n_sclocal+1:2*n_sclocal+n_fclocal;
index_b2 = 2*n_sclocal+n_fclocal+1:2*n_sclocal+2*n_fclocal;

index_L1 = 2*n_sclocal+2*n_fclocal+1:2*n_sclocal+2*n_fclocal+n_pdelocal;
index_L2 = 2*n_sclocal+2*n_fclocal+n_pdelocal+1:2*n_sclocal+2*n_fclocal+2*n_pdelocal;

%rellando las submatrices sparse
WL1Y1(i,scindx) = pesos1(index_y1);
WL1Y2(i,scindx) = pesos1(index_y2);
WL2Y1(i,scindx) = pesos2(index_y1);
WL2Y2(i,scindx) = pesos2(index_y2);

WL1B1(i,fcindx) = pesos1(index_b1);
WL1B2(i,fcindx) = pesos1(index_b2);
WL2B1(i,fcindx) = pesos2(index_b1);
WL2B2(i,fcindx) = pesos2(index_b2);

WL1L1(i,pdecindx) = pesos1(index_L1);
WL1L2(i,pdecindx) = pesos1(index_L2);
WL2L1(i,pdecindx) = pesos2(index_L1);
WL2L2(i,pdecindx) = pesos2(index_L2);
end


%Contruyendo la matriz SY
SY = [[WL1Y1 , WL1Y2];...
      [WL2Y1 , WL2Y2];...
     ];

SB = [[WL1B1 , WL1B2];...
      [WL2B1 , WL2B2];...
     ];
     
SL = [[WL1L1 , WL1L2];...
      [WL2L1 , WL2L2];...
     ];          



