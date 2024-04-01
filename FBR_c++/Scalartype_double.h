#include <fstream>
#include <vector>
#include <cstdlib>
#include <iostream>
#include <string>
#ifndef Scalartype_HH
#define Scalartype_HH
using namespace Eigen;
using namespace std;  
typedef double Real_scalar;
typedef Matrix<Real_scalar,Dynamic,Dynamic>  MatrixXmp;
extern "C" typedef Real_scalar (*FnPtr)(const Real_scalar&,const Real_scalar&,const Real_scalar&,const Real_scalar&, const vector< Real_scalar >& );

#endif

