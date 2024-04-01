% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('locallibs/');
Dirsave_data = '../Data/LHI_Stokes_pre_hibridKenerlR9/';

mp.Digits(100);

Avar_muu = [1.0];
Apoint = [1/20];
Astencial = [15];
for lk=1:length(Avar_muu)
    fileID = fopen([Dirsave_data,'Errores_muu_',num2str(Avar_muu(lk)),'_Stokes.txt'],'a');
    for k=1:length(Apoint)
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            disp('leyuendo archivo')
            [pesos,Pre] = read_weights_mp(dir_name,[5 6 7 8]);
            %[Indices_sup,distancepp] = LHI_index(double(Pre.P_sc),double(Pre.P_fc),Astencial(j),[1 1 2],[0 0 0]);
             filename = strcat(dir_name,'time_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat');
            Parameters = load(filename);
            disp('construyendo las matrices')

            [SY,SB,SL] = FastWeight2Sparse_mp(Parameters.Indices_sup,Pre,pesos(:,1:2));
            [PY,PB,PL] = FastWeight2Sparse_mp(Parameters.Indices_sup,Pre,pesos(:,3:4));
   
            disp('calculando el error')

            var_muu= mp('1.0');
            Pre.SY = SY;Pre.SB = SB;Pre.SL = SL;
            Pre.PY = PY;Pre.PB = PB;Pre.PL = PL;
            [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich(Pre,var_muu);
            
            fprintf(fileID,'%d %d %5.5e %5.5e %5.5e %5.5e %5.5e %5.5e\n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP,max(Pre.CondMs),condest(double(SY)));
            
            fprintf('%d %d %5.5e %5.5e %5.5e %5.5e %5.5e %5.5e\n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP,max(Pre.CondMs),condest(double(SY)));
%             
        end
    end
    fclose(fileID);
end
