% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
Dirsave_data = '../Data/Newmwthod/';
mp.Digits(100);
mkdir(Dirsave_data);
%Obteniendo la solucion exacta y las fuentes de la ecuacion
Avar_muu = [1.0];
Apoint = [1/20];
Astencial = [40];

ParamCdiv = 0.1;
Settings.programa = 'Cplusplus/LHI_Wegths_Save_Anzatpre.out';
Settings.lib = 'Cplusplus/LHI_Stokes_pre_wpresu.so';
Settings.presicion = 100;
Settings.Coutpresicion = 100;
Settings.NOperadoresY = 7;
Settings.NOperadoresX = 11;


setenv('OMP_NUM_THREADS','15')
for lk=1:length(Avar_muu)
    for k=1:length(Apoint)
        [P_sc,P_fc] = Mesh_gen(Apoint(k),Apoint(k),1.0);
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            mkdir(dir_name);
            
            
            [Indices_sup1,distancepp1] = LHI_index(P_sc, P_fc,Astencial(j),[2 1 2],[0 0 0]);
            [Indices_sup2,distancepp2] = LHI_index(P_sc, P_fc,Astencial(j),[1 1 2],[0 0 0]);

            dirname1 = [dir_name,'_stencil1/'];
            mkdir(dirname1);
            FilesDir1 = write_files(P_sc,P_fc,Indices_sup1,distancepp1,dirname1);
         
            dirname2 = [dir_name,'_stencil2/'];
            mkdir(dirname2);
            FilesDir2 = write_files(P_sc,P_fc,Indices_sup2,distancepp2,dirname2);
            
            Settings.Params = [ParamCdiv,ParamCdiv,Avar_muu(lk)];
            disp('calculando pesos')
            tic;
            
            Compute_matrixs_general_saveV2(Settings,FilesDir1,dirname1,...
                [6,8,10],length(P_sc));
            
             Settings.Params = [ParamCdiv,ParamCdiv,Avar_muu(lk)];
             Compute_matrixs_general_saveV2(Settings,FilesDir2,dirname2,...
                [7,9,11],length(P_sc));
            
            timecomputed=toc;
            disp(timecomputed);
            disp('fin del calculo de pesos')  
            
            save(strcat(dir_name,'time_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'),...
                'timecomputed','Indices_sup1','distancepp1',...
                'Indices_sup2','distancepp2');
        
        end
    end
end
