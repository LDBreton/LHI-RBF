#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <Eigen/Dense>
#include <dlfcn.h>

#ifndef ReadLibs_CPP
#define ReadLibs_CPP
//fbrGram{1,3} equivale a OperadoresX(3) [OperadoresY(1)(Phi)];
//fbrGram{2,4} equivale a OperadoresX(4) [OperadoresY(2)(Phi)];

template<typename TFnPtr>
TFnPtr get_FBR(const int& rowIndex,const int& colIndex,void* lib){ 
		std::string name = "fbrGram" + std::to_string(rowIndex) + std::to_string(colIndex);
		const char *NamePointer = name.c_str();
		TFnPtr Fbr_instance = (TFnPtr)dlsym( lib, NamePointer );
		return Fbr_instance;
	}

template<typename TFnPtr>
std::vector< TFnPtr > get_FBR_row(const int& rowIndex,const int& NOperadoresX,void* lib){ 
	std::vector< TFnPtr > Rowfunctions;
	for(int i=1; i <= NOperadoresX ; i++){
		std::string name = "fbrGram" + std::to_string(rowIndex) + std::to_string(i);
		const char *NamePointer = name.c_str();
		TFnPtr Fbr_instance = (TFnPtr)dlsym( lib, NamePointer );
		Rowfunctions.push_back(Fbr_instance); 
	}

return Rowfunctions; 
}

template<typename TFnPtr>
std::vector< TFnPtr > get_FBR_col(const int& colIndex,const int& NOperadoresY,void* lib){ 
	std::vector< TFnPtr > Colfunctions;
	for(int i=1; i <= NOperadoresY ; i++){
		std::string name = "fbrGram" + std::to_string(i) + std::to_string(colIndex);
		const char *NamePointer = name.c_str();
		TFnPtr Fbr_instance = (TFnPtr)dlsym( lib, NamePointer );
		Colfunctions.push_back(Fbr_instance); 
	}

return Colfunctions; 
}
//fbrGram ([NOperadoresY,NOperadoresX]);      
//fbrGram{1,3} equivale a OperadoresX(3) [OperadoresY(1)(Phi)];
//fbrGram{2,4} equivale a OperadoresX(4) [OperadoresY(2)(Phi)];
template<typename TFnPtr>
std::vector< std::vector< TFnPtr > >  FillGramFFunctioMatrix (const int& NOperadoresY,const int& NOperadoresX,void* lib){
		std::vector< std::vector< TFnPtr > > FbrGramMatrix;

		for(int i=1; i <= NOperadoresY ; i++){
			     std::vector< TFnPtr >  RowFBR = get_FBR_row<TFnPtr>(i,NOperadoresX,lib);
			     FbrGramMatrix.push_back( RowFBR ); 
		}
		

		return	FbrGramMatrix;
	}
#endif

