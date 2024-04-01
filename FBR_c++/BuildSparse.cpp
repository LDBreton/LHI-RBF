#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include "libs/buildmatrix.cpp"
#include "libs/read_files.cpp"
#include "libs/select_local.cpp"
#include <Eigen/Dense>
#include <dlfcn.h>
#include "libs/ReadLibs.cpp"
#include "Scalartype_mpreal.h"
#include <Eigen/Sparse>
#include <vector>
#include <iterator>
typedef SparseMatrix< Real_scalar ,RowMajor > Real_Msparse;
typedef vector< vector<int> > Indexvect;

//Nrows = N_sc
//pesosId indenx of weight in cell_pesos
//ColidxVec col index of the sparse matrix
//Bopidv the begin of the weigths
Real_Msparse BuildSparse(int Nrows,int Ncols,
						vector<int> pesosId,
						const vector< Indexvect >& GlobalIdex, 
						MatrixXmp **cell_pesos,
						const int SparseIdx){
							
int dimL = pesosId.size();
Indexvect ColidxVec = GlobalIdex[SparseIdx];
Real_Msparse SparseW(dimL*Nrows,2*Ncols);

/////////////local reservation of nonzero elements/////
vector< int > nn_zero(dimL*Nrows);
for(int j=0; j < dimL ; j++){
	for(int i=0; i < Nrows ; i++){
	int nnzeros_local = ColidxVec[i].size();	
	nn_zero[i+j*Nrows] = (2*nnzeros_local);
	}
}
SparseW.reserve(nn_zero);
////////////////////////////////////////////////////////

/////////////local start for weights////
vector< int > Start_local(dimL*Nrows); //local start of weigths
for(int i=0; i < Nrows ; i++){
	for(int j=0; j < dimL ; j++){
		    Start_local[i+j*Nrows] = 0.0;
			for(int k=0; k < SparseIdx ; k++){
				if(GlobalIdex[k][i][0] != -1){
				Start_local[i+j*Nrows] += 2*GlobalIdex[k][i].size();	
				}
			}
	}
}
////////////////////////////////////////////////////////


for(int j=0; j < dimL ; j++){
	for(int i=0; i < Nrows ; i++){
		int nnzeros_local = ColidxVec[i].size();	
		for(int k=0; k < nnzeros_local ; k++){
			int local_vec_idx = 0;
			if(ColidxVec[i][k] != -1){
			
			local_vec_idx = k + Start_local[i+j*Nrows];
			SparseW.insert(i+j*Nrows,ColidxVec[i][k]) = cell_pesos[pesosId[j]][i](local_vec_idx,0);
			
			local_vec_idx = nnzeros_local + k + Start_local[i+j*Nrows];
			SparseW.insert(i+j*Nrows,Ncols + ColidxVec[i][k]) = cell_pesos[pesosId[j]][i](local_vec_idx,0);
			
			}
		}
	}
}

return SparseW;

}


