% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
Dirsave_data = '../Data/Funcionando/';
mp.Digits(100);
mkdir(Dirsave_data);
%Obteniendo la solucion exacta y las fuentes de la ecuacion
Avar_muu = [1.0];
Apoint = [1/20];
Astencial = [40];
setenv('OMP_NUM_THREADS','15')
for lk=1:length(Avar_muu)
    for k=1:length(Apoint)
        [P_sc,P_fc] = Mesh_gen(Apoint(k),Apoint(k),1.0);
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            mkdir(dir_name);
            [Indices_sup,distancepp] = LHI_index(P_sc, P_fc,Astencial(j),[1 1 2],[0 0 0]);
            Settings = write_files(P_sc,P_fc,Indices_sup,distancepp,dir_name);
            Settings.programa = 'Cplusplus/LHI_Wegths_Save_lu.out';
            Settings.lib = 'Cplusplus/LHI_Stokes_pre_divergence.so';
            Settings.presicion = 100;
            Settings.Coutpresicion = 100;
            Settings.NOperadoresY = 6;
            Settings.NOperadoresX = 10;
            Settings.dir_name = dir_name;
            ParamCdiv = 0.00099;
            %ParamCdiv = 0.0005;
            Settings.Params = [ParamCdiv,ParamCdiv,Avar_muu(lk)];
            disp('calculando pesos')
            tic;
            Compute_matrixs_general_save(Settings,[5,6,7,8],length(P_sc));
            timecomputed=toc;
            timecomputed
            disp('fin del calculo de pesos')  
             save(strcat(dir_name,'time_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'),'timecomputed','Indices_sup','distancepp');
        end
    end
end
