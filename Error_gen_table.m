% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
Dirsave_data = 'Data/Data_Dirch_variable/';
mkdir(Dirsave_data);
%Obteniendo la solucion exacta y las fuentes de la ecuacion
Avar_muu = [1.0];
Apoint = [1/20,1/30,1/50,1/80,1/100];
Astencial = [15,20,30,40];
setenv('OMP_NUM_THREADS','16')
for lk=1:length(Avar_muu)
    for k=1:length(Apoint)
        coeffBoundary = max(1.5,min(0.75*(1/Apoint(k))/10,4));
        [P_sc,P_fc] = Mesh_gen(Apoint(k),Apoint(k),1.0);
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            mkdir(dir_name);
            [Indices_sup,distancepp] = LHI_index(P_sc, P_fc,Astencial(j),[1 1 2],[0 0 0]);
            Settings = write_files(P_sc,P_fc,Indices_sup,distancepp,dir_name);
            Settings.programa = 'Cplusplus/LHI_Wegths.out';
            Settings.lib = 'Cplusplus/LHI_Stokes_pre.so';
            Settings.presicion = 100;
            Settings.NOperadoresX = 8;
            Settings.NOperadoresY = 6;
            ParamCdiv = 0.1;%0.05/(max(distancepp));
            Settings.Params = [ParamCdiv*10,ParamCdiv,Avar_muu(lk)];
            
            disp('calculando pesos')
            tic;
            [pesos] = Compute_matrixs_general(Settings,[5,6,7,8],length(P_sc));
            timecomputed=toc;
            disp('fin del calculo de pesos')
            
            disp('construyendo matrices')
            [SY,SB,SL] = Weight2Sparse(Indices_sup,P_sc,P_fc,pesos(:,1:2));
            [PY,PB,PL] = Weight2Sparse(Indices_sup,P_sc,P_fc,pesos(:,3:4));
            disp('fin de la construccion de matrices')
            max(max(abs(SY)))
            max(max(abs(SB)))
            max(max(abs(SL)))

            save(strcat(dir_name,'precomputed_Stokes_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'),...
                'P_sc','P_fc','Indices_sup',...
                'SY','SB','SL',...
                'PY','PB','PL','timecomputed');
            
            Pre=load(strcat(dir_name,'precomputed_Stokes_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'));
        var_muu= Avar_muu(lk);
        [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich(Pre,var_muu);
        
             
              fprintf('%d %d %5.5e %5.5e %5.5e %5.5e \n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP)
            
        end
    end
end
