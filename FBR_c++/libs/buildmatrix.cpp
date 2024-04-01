#include <iostream>
#include "Eigen/LU"
#include <functional>   // std::bind
#include <map>
#include <omp.h>
#include <boost/typeof/typeof.hpp>
#include "distance_matrix.cpp"


#ifndef buildmatrix_CPP
#define buildmatrix_CPP
 

template<typename TMatrix>
void insert_block(TMatrix &Mbig,TMatrix &Mblock,const int& p, const int& q){
	 int Nblock_cols = Mblock.cols();
     int Nblock_rows = Mblock.rows();
     
	if(Nblock_cols != 0 || Nblock_rows !=0 ){
     Mbig.block(p,q,Nblock_rows,Nblock_cols) = Mblock;
	  }
	}
	
	

template<typename TvectorFunc,typename TMatrix,typename scalar>
TMatrix BuildMGram(const std::vector< TMatrix >& Puntos,const std::vector< TMatrix >& Centros, const TvectorFunc Afbr_func,const std::vector< scalar >& paramrs){

int Nrows =0;
int Ncols =0;

	for(unsigned int i=0; i < Puntos.size() ; i++) {
	Nrows += Puntos[i].rows();
	}	
	for(unsigned int i=0; i < Centros.size() ; i++) {
	Ncols += Centros[i].rows();
	}
	TMatrix fbrgram_M(Nrows,Ncols);
	
	int p = 0;
	for(unsigned int i=0; i < Puntos.size() ; i++) {
		int q = 0;
        for(unsigned int j=0; j < Centros.size(); j++) {
            TMatrix fbrgramXX_M = distance_matrix(Puntos[i],Centros[j],Afbr_func[j][i],paramrs);
			insert_block(fbrgram_M,fbrgramXX_M,p,q);
		    q += Centros[j].rows();		     
        }
    p += Puntos[i].rows();    
	}
	
	return fbrgram_M;
}

template<typename TvectorFunc,typename TMatrix,typename scalar>
TMatrix BuildMGram_t(const TMatrix& Punto,const std::vector< TMatrix >& Centros, const TvectorFunc Afbr_func,const std::vector< scalar >& paramrs){

int Nrows =0;

	for(unsigned int i=0; i < Centros.size() ; i++) {
	Nrows += Centros[i].rows();
	}
	
	TMatrix fbrgram_M(Nrows,1);
	int q = 0;
    
    for(unsigned int j=0; j < Centros.size(); j++) {
            TMatrix fbrgramXX_M = distance_matrix(Punto,Centros[j],Afbr_func[j],paramrs).transpose();
			insert_block(fbrgram_M,fbrgramXX_M,q,0);
		    q += Centros[j].rows();		     
        }
	
	return fbrgram_M;
}
#endif
