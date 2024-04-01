#include <iostream>
#include "Eigen/LU"
#include <omp.h>
#include <vector>

#ifndef distance_files_CPP
#define distance_files_CPP

template<typename TFunc,typename TMatrix,typename scalar>
TMatrix distance_matrix (const std::vector< std::vector<scalar> >& Puntos, const std::vector< std::vector<scalar> >&  Centros, const TFunc fbr,const std::vector< scalar >& paramrs)
{
  int Npuntos = Puntos.size();
  int NCentros = Centros.size();
  TMatrix fbrmat(Npuntos,NCentros);
  
  
  if(Npuntos == 0 || NCentros ==0 ){
	  return fbrmat;
	  }
  
  for(int i=0; i < Npuntos; i++){
    for(int j=0; j < NCentros; j++){
	fbrmat(i,j)=fbr(Puntos[i][0],Puntos[i][1],Centros[j][0],Centros[j][1],paramrs);		
	}
  }
  
  return fbrmat;
}

template<typename TFunc,typename TMatrix,typename scalar>
TMatrix distance_matrix (const TMatrix& Puntos,const TMatrix& Centros,const TFunc fbr,const std::vector< scalar >& paramrs)
{
  int Npuntos = Puntos.rows();
  int NCentros = Centros.rows();
  TMatrix fbrmat(Npuntos,NCentros);
  
  
  if(Npuntos == 0 || NCentros ==0 ){
	  return fbrmat;
	  }
  
  for(int i=0; i < Npuntos; i++){
    for(int j=0; j < NCentros; j++){
	fbrmat(i,j)=fbr(Puntos(i,0),Puntos(i,1),Centros(j,0),Centros(j,1),paramrs);		
	}
  }
  
  return fbrmat;
}



template<typename TFunc,typename TMatrix,typename scalar>
TMatrix distance_matrix_symetric (const std::vector< std::vector<scalar> >&  Puntos,const std::vector< std::vector < scalar > >&  Centros,const TFunc fbr,const std::vector< scalar >& paramrs)
{
  int Npuntos = Puntos.size();
  int NCentros = Centros.size();
  TMatrix fbrmat(Npuntos,NCentros);
  
  
  if(Npuntos == 0 || NCentros ==0 ){
	  return fbrmat;
	  }
  
  
  for(int i=0; i < Npuntos; i++){
    for(int j=0; j <= i; j++){
	fbrmat(i,j)=fbr(Puntos[i][0],Puntos[i][1],Centros[j][0],Centros[j][1],paramrs);
	fbrmat(j,i)=fbrmat(i,j); 		
	}
  }
  
  return fbrmat;
}


template<typename TFunc,typename TMatrix,typename scalar>
TMatrix distance_matrix_symetric (const TMatrix& Puntos,const TMatrix& Centros, const TFunc fbr,const std::vector< scalar >& paramrs)
{
  int Npuntos = Puntos.rows();
  int NCentros = Centros.rows();
  TMatrix fbrmat(Npuntos,NCentros);
  
  
  if(Npuntos == 0 || NCentros ==0 ){
	  return fbrmat;
	  }
  
  for(int i=0; i < Npuntos; i++){
    for(int j=0; j <= i ; j++){
	fbrmat(i,j)=fbr(Puntos(i,0),Puntos(i,1),Centros(j,0),Centros(j,1),paramrs);	
	fbrmat(j,i)=fbrmat(i,j); 		
	
	}
  }
  
  return fbrmat;
}
#endif
