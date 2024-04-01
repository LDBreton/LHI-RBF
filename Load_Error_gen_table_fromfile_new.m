% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('locallibs/');
Dirsave_data = '../Data/Newmwthod/';

mp.Digits(100);

Avar_muu = [1.0];
Apoint = [1/20];
Astencial = [40];
for lk=1:length(Avar_muu)
    fileID = fopen([Dirsave_data,'Errores_muu_',num2str(Avar_muu(lk)),'_Stokes.txt'],'a');
    for k=1:length(Apoint)
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            disp('leyuendo archivo')
            
            [pesos1,Pre] = read_weights_mp([dir_name,'_stencil1/'],[6,8,10]);
            [pesos2,Pre] = read_weights_mp([dir_name,'_stencil2/'],[7,9,11]);
            
            filename = strcat(dir_name,'time_mu_',num2str(Avar_muu(lk)),'_c.mat');
            
            Parameters = load(filename);
            disp('construyendo las matrices')

            
            [SY1,SB1,SL1] = FastWeight2Sparse_mp_new(Parameters.Indices_sup1,Pre,pesos1(:,1));
            [PY1,PB1,PL1] = FastWeight2Sparse_mp_new(Parameters.Indices_sup1,Pre,pesos1(:,2));
            [DXY,DXB,DXL] = FastWeight2Sparse_mp_new(Parameters.Indices_sup1,Pre,pesos1(:,3));
            
            [SY2,SB2,SL2] = FastWeight2Sparse_mp_new(Parameters.Indices_sup2,Pre,pesos2(:,1));
            [PY2,PB2,PL2] = FastWeight2Sparse_mp_new(Parameters.Indices_sup2,Pre,pesos2(:,2));
            [DYY,DYB,DYL] = FastWeight2Sparse_mp_new(Parameters.Indices_sup2,Pre,pesos2(:,3));
            
            Pre.Myp = [SY1;SY2;DXY+DYY];
            Pre.Mbf = [SL1,SB1;SL2,SB2;DXL+DYL,DXB+DYB];
            Pre.MgradP = [PY1,PB1,PL1;PY2,PB2,PL2];
            
            
            disp('calculando el error') 
            var_muu= mp('1.0');
           [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich_new(Pre,var_muu);
            
            fprintf(fileID,'%d %d %5.5e %5.5e %5.5e %5.5e %5.5e %5.5e\n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP,max(Pre.CondMs),condest(double(Pre.Myp)));
            
            fprintf('%d %d %5.5e %5.5e %5.5e %5.5e %5.5e %5.5e\n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP,max(Pre.CondMs),condest(double(Pre.Myp)));
            
        end
    end
    fclose(fileID);
end
