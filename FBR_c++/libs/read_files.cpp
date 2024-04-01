#include <fstream>
#include <vector>
#include <cstdlib>
#include <iostream>
#include <string>

#ifndef read_files_CPP
#define read_files_CPP

std::vector< int > char2vector_int(char *Intarray){
	std::stringstream linestream(Intarray);
	int num;
    std::vector< int > indexOperator;
	while (linestream >> num) {
				indexOperator.push_back(num);
			}
	return indexOperator;		
	}

//para leer los indices generados por matlab
std::vector< std::vector<int> > read_indexfile(std::string filename){
	    std::ifstream ifile(filename, std::ios::in);
	    int num;
	    std::string   line;
        std::vector< std::vector<int> > index;
		   while (getline(ifile, line)) {
		   std::vector<int> subindex;
           std::stringstream linestream(line);
           while (linestream >> num) {
				subindex.push_back(num);
			}
			index.push_back(subindex);
    }

	return index;
	
	}
//para leer archivo de puntos a mppreal
template<typename scalar>
std::vector< std::vector<scalar> > read_realfile(std::string filename){
	    std::ifstream ifile(filename, std::ios::in);
	    scalar num;
	    std::string   line;
        std::vector< std::vector<scalar> > real_array;
		   while (getline(ifile, line)) {
		   std::vector<scalar> subindex;
           std::stringstream linestream(line);
           while (linestream >> num) {
				subindex.push_back(num);
			}
			real_array.push_back(subindex);
    }
	return real_array;
	}
//para leer el archivo de puntos a matrices
template<typename TMatrix,typename scalar>
TMatrix file2puntos(std::string filename){
	    std::vector< std::vector<scalar> > aux = read_realfile<scalar>(filename);
	    int Npuntos = aux.size();
		TMatrix Puntos(Npuntos,2);
		
		for(int i=0; i < Npuntos; i++ ){
			for(int j=0; j < 2; j++ ){
				Puntos(i,j) = aux[i][j];
				}
			}
		return Puntos;

	}	


//para leer archivo de puntos a mppreal
template<typename scalar>
std::vector<scalar>  read_distance(std::string filename){
	    std::ifstream ifile(filename, std::ios::in);
	    scalar num;
        std::vector<scalar> real_distance;
           while (ifile >> num) {
				real_distance.push_back(num);
			}
    
	return real_distance;
	}	
#endif
