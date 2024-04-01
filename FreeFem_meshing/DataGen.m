 addpath('../Libs/AdvanpixMCT-4.5.2.12841') %% libreria de multipresicion
 addpath('../Libs/DivFree_libreria/') %% libreria de las funciones
 addpath('../Libs/Freefem_to_matlab/') %% libreria de para leer las mallas de matlab
 SaveDire = 'FBRsaveFiles/';
 

 
   dt=[0.1,0.01,0.001];
   n_stencial_sc = [10,30,40,60];
   ParamC = [1.0,0.1,0.01];
   muu = [1.0,0.1,0.001];
   
   Inside = 1/120;
   [P_sc,P_fc] = Mesh_gen(1/120,1/120,0.5);
   save(strcat('SaveData/','Puntos_120','.mat'),'P_sc','P_fc');     
