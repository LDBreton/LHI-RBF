function [BY,BB,BL] = Weight2SparseBoundary(Indices_supB,P_sc,P_fc,pesos_Boundary)





nn_p_fc = length(P_fc); % cantidad de puntos interiores



%definiendo las matrices sparse como en el articulo
BL1Y1 = (sparse(length(P_fc),length(P_sc)));%W_L1^y1
BL1Y2 = (sparse(length(P_fc),length(P_sc)));%W_L1^y2
BL2Y1 = (sparse(length(P_fc),length(P_sc)));%W_L2^y1
BL2Y2 = (sparse(length(P_fc),length(P_sc)));%W_L2^y2
                                    
BL1B1 = (sparse(length(P_fc),length(P_fc)));%W_L1^y1
BL1B2 = (sparse(length(P_fc),length(P_fc)));%W_L1^y2
BL2B1 = (sparse(length(P_fc),length(P_fc)));%W_L2^y1
BL2B2 = (sparse(length(P_fc),length(P_fc)));%W_L2^y2
                                    
BL1L1 = (sparse(length(P_fc),length(P_sc)));%W_L1^y1
BL1L2 = (sparse(length(P_fc),length(P_sc)));%W_L1^y2
BL2L1 = (sparse(length(P_fc),length(P_sc)));%W_L2^y1
BL2L2 = (sparse(length(P_fc),length(P_sc)));%W_L2^y2



for i = 1:nn_p_fc

scindx = Indices_supB{i,1};
fcindx = Indices_supB{i,2};   
pdecindx = Indices_supB{i,3}; 

pesos1 = pesos_Boundary{i,1};
pesos2 = pesos_Boundary{i,2};

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
BL1Y1(i,scindx) = pesos1(index_y1);
BL1Y2(i,scindx) = pesos1(index_y2);
BL2Y1(i,scindx) = pesos2(index_y1);
BL2Y2(i,scindx) = pesos2(index_y2);

BL1B1(i,fcindx) = pesos1(index_b1);
BL1B2(i,fcindx) = pesos1(index_b2);
BL2B1(i,fcindx) = pesos2(index_b1);
BL2B2(i,fcindx) = pesos2(index_b2);

BL1L1(i,pdecindx) = pesos1(index_L1);
BL1L2(i,pdecindx) = pesos1(index_L2);
BL2L1(i,pdecindx) = pesos2(index_L1);
BL2L2(i,pdecindx) = pesos2(index_L2);
end


%Contruyendo la matriz SY
BY = [[BL1Y1 , BL1Y2];...
      [BL2Y1 , BL2Y2];...
     ];

BB = [[BL1B1 , BL1B2];...
      [BL2B1 , BL2B2];...
     ];
     
BL = [[BL1L1 , BL1L2];...
      [BL2L1 , BL2L2];...
     ];          



