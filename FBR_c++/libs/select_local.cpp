#include <fstream>
#include <vector>
#include <cstdlib>
#include <iostream>
#include <string>

#ifndef select_local_CPP
#define select_local_CPP


//por optimizar quizas clase?
template<typename TMatrix>
TMatrix select_local (const TMatrix& Puntos,const std::vector<int>& indexs)
{
  
  if(indexs[0] == -1){
	  TMatrix nulll(0,0);
	  return nulll;
	  }
  
  int Nsubpuntos = indexs.size(); 
  TMatrix subPuntos(Nsubpuntos,2);
    
  for(int i=0; i < Nsubpuntos; i++){
	  subPuntos(i,0) = Puntos(indexs[i],0);
	  subPuntos(i,1) = Puntos(indexs[i],1);
   }
  
  
  return subPuntos;
}
#endif
