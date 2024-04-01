% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('locallibs/');

Dirsave_data = 'Data/Data_Dirch_var/';

Avar_muu = [1.0];
Apoint = [1/20,1/30,1/50,1/80,1/100];
Astencial = [15,20,30,40];


for lk=1:length(Avar_muu)
    fileID = fopen([Dirsave_data,'Errores_muu_',num2str(Avar_muu(lk)),'_Stokes.txt'],'a');
    for k=1:length(Apoint)
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            Pre=load(strcat(dir_name,'precomputed_Stokes_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'));
          var_muu= Avar_muu(lk);
         Pre.P_fc = mp(Pre.P_fc);
         Pre.P_sc = mp(Pre.P_sc);
        [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich(Pre,var_muu);
        
        fprintf(fileID,'%d %d %5.5e %5.5e %5.5e %5.5e \n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP);
            
              fprintf('%d %d %5.5e %5.5e %5.5e %5.5e \n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP)
            
        end
    end
    fclose(fileID);
end
