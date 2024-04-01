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
#include "Scalartype_double.h"

/*
 * argv[1] = ./FBRfunctions.so 	
 * argv[2] = digits presicion 
 * argv[3] = "data/uniform/Indices_sup_uniform_1.txt" 
 * argv[4] = "data/uniform/Indices_sup_uniform_2.txt"
 * argv[5] = "data/uniform/Indices_sup_uniform_3.txt"
 * argv[6] = "data/uniform/distance_uniform.txt"
 * argv[7] = "data/uniform/P_sc_uniform.txt"
 * argv[8] = "data/uniform/P_fc_uniform.txt"
 * argv[9] =  NOperadoresX
 * argv[10] = NOperadoresY
 * argv[11] = indexOperator
 * argv[12] = Npesos_calcular
 * argv[13:end] = Param[0:end]
*/
//fbrGram ([NOperadoresY,NOperadoresX]);      

int main(int argc, char *argv[])
{
const int digits = atoi(argv[2]); 
//mpreal::set_default_prec(mpfr::digits2bits(digits));

// Arg donde comienzan los parametros	
const int Boparam = 13;	
//digitos de precision y para imprimir para imprimir
const int digits_prints = max(digits,32); 
//libreria de donde abrir argv[1] = ./FBRfunctions.so 	
void* lib = dlopen(argv[1], RTLD_LAZY);
//////////////////////////////////////////
vector< vector<int> > indices_sc = read_indexfile(string(argv[3]));	
vector< vector<int> > indices_fc = read_indexfile(string(argv[4]));	
vector< vector<int> > indices_pde = read_indexfile(string(argv[5]));
vector<Real_scalar>  vector_distancias = read_distance<Real_scalar>(string(argv[6]))	;
MatrixXmp Puntos_sc = file2puntos<MatrixXmp,Real_scalar>(string(argv[7]));
MatrixXmp Puntos_fc = file2puntos<MatrixXmp,Real_scalar>(string(argv[8]));;
const int NOperadoresX = atoi(argv[9]);
const int NOperadoresY = atoi(argv[10]);
vector< int > indexOperator = char2vector_int(argv[11]);
const int Npesos_calcular = atoi(argv[12]);
////////////////////////////////////////////////

////////////////////////////////////////////////
cout.precision(digits_prints);    // Show all the digits
vector< vector< FnPtr > > FbrGramMatrix = FillGramFFunctioMatrix<FnPtr>(NOperadoresY,NOperadoresX,lib);
////////////////////////////////////////////////


////Creating the vector of parameters
const int Nparametros = argc - Boparam;
vector< Real_scalar > paramrs;
if(Nparametros > 0){
	for(int i=0; i <Nparametros ; i++){
		paramrs.push_back(atof(argv[Boparam+i])); //c
	}
}
/////////////////////////////////

int NoperatorW2cal = indexOperator.size();
int Npuntos_sc = Puntos_sc.rows();

MatrixXmp **cell_pesos;
vector < vector< FnPtr > > FBR_RHS;
cell_pesos = new MatrixXmp*[NoperatorW2cal]; 

for (int j = 0; j < NoperatorW2cal; ++j) {
   cell_pesos[j] = new MatrixXmp[Npuntos_sc];
   vector< FnPtr > FBR_RHSAUX = get_FBR_col<FnPtr>(indexOperator[j],NOperadoresY,lib);
   FBR_RHS.push_back(FBR_RHSAUX);
}

///////////////////////////
#pragma omp parallel for 
for(int i=0; i <Npesos_calcular ; i++){


vector<int> aux;
aux.push_back(i);
MatrixXmp Punto = select_local(Puntos_sc,aux);	
MatrixXmp Puntos_sc_local = select_local(Puntos_sc,indices_sc[i]);
MatrixXmp Puntos_fc_local = select_local(Puntos_fc,indices_fc[i]);
MatrixXmp Puntos_pde_local = select_local(Puntos_sc,indices_pde[i]);

vector< MatrixXmp > Centros;

Centros.push_back(Puntos_sc_local);
Centros.push_back(Puntos_sc_local);
Centros.push_back(Puntos_fc_local);
Centros.push_back(Puntos_fc_local);
Centros.push_back(Puntos_pde_local);
Centros.push_back(Puntos_pde_local);

MatrixXmp grammatrix = BuildMGram(Centros,Centros,FbrGramMatrix,paramrs);
LDLT<Ref<MatrixXmp> > lu(grammatrix);
		for (int j = 0; j < NoperatorW2cal; ++j) {
		MatrixXmp RHSL = BuildMGram_t(Punto,Centros, FBR_RHS[j],paramrs);
		//cell_pesos[j][i] = grammatrix.lu().solve(RHSL);
		cell_pesos[j][i] = lu.solve(RHSL);
		}
}


//////////////////////Pinting the weigths/////////////
{
	for (int k = 0; k < NoperatorW2cal; ++k) {
		for(int i=0; i <Npesos_calcular ; i++){
			for(int j=0; j <cell_pesos[k][i].rows();j++ ){
				cout << cell_pesos[k][i](j,0) << " ";		
				}
				cout << '\n'; 	
		}
	}
}
//////////////////////Pinting the weigths/////////////

}
