% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
mkdir('../Data_dirich/')
Dirsave_data = '../Data/hibridKenerlgeneralLim/';
mp.Digits(100);
mkdir(Dirsave_data);
%Obteniendo la solucion exacta y las fuentes de la ecuacion
Avar_muu = [1.0];
lamdak=mp('0.1');
Apoint = [1/15];
Astencial = [15];
setenv('OMP_NUM_THREADS','15')
for lk=1:length(Avar_muu)
    for k=1:length(Apoint)
        [P_sc,P_fc] = Mesh_gen(Apoint(k),Apoint(k),1);
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            mkdir(dir_name);
            [Indices_sup,distancepp] = LHI_index(P_sc, P_fc,Astencial(j),[1 1 2],[0 0 0]);
            P_sc = lamdak*P_sc;
            P_fc = lamdak*P_fc;
            Settings = write_files(P_sc,P_fc,Indices_sup,distancepp,dir_name);
            Settings.programa = 'Cplusplus/LHI_Wegths_Save.out';
            Settings.lib = 'Cplusplus/hibridKenerlgeneralLim.so';
            Settings.presicion = 100;
            Settings.Coutpresicion = 100;
            Settings.NOperadoresX = 8;
            Settings.NOperadoresY = 6;
            Settings.dir_name = dir_name;
            %{'gammass1','gammass2','cesp','c','cpre','a','b''mus'};
            Settings.Params = [mp('0'),mp('0'),mp('0.0'),mp('0.2'),mp('0.2'),7,3,Avar_muu(lk)];

            disp('calculando pesos')
            tic;
            Compute_matrixs_general_save(Settings,[5,6,7,8],length(P_sc));
            timecomputed=toc;
            timecomputed;
            disp('fin del calculo de pesos') 
            CondMs = mp.read([dir_name,'rcond_file.txt']);
            Maxnumcond = max(1./CondMs);
            fprintf('numero de condicionamiento %5.5e \n',Maxnumcond)
            save(strcat(dir_name,'time_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat'),'timecomputed','Indices_sup','distancepp','P_sc','P_fc','Maxnumcond');
            filename = strcat(dir_name,'time_',...
                'mu_',num2str(Avar_muu(lk)),'_c.mat');
             
            Parameters = load(filename);
            [pesos,Pre] = read_weights_mp(dir_name,[5 6 7 8]);
            disp('construyendo las matrices')

            [SY,SB,SL] = FastWeight2Sparse_mp(Parameters.Indices_sup,Pre,pesos(:,1:2));
            [PY,PB,PL] = FastWeight2Sparse_mp(Parameters.Indices_sup,Pre,pesos(:,3:4));
   
            disp('calculando el error')

            var_muu= Avar_muu(lk);
            Pre.SY = SY;Pre.SB = SB;Pre.SL = SL;
            Pre.PY = PY;Pre.PB = PB;Pre.PL = PL;
            [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich_scale(Pre,var_muu,lamdak);
            
            fprintf('%d %d %5.5e %5.5e %5.5e %5.5e %5.5e %5.5e\n',...
                length(Pre.P_sc) + length(Pre.P_fc), ...
                Astencial(j), ...
                L2EvectY,LinftyEvectY,...
                L2EGradP,LinftyEGradP,max(Pre.CondMs),condest(double(SY)));
%             ML = full(speye(size(SY))-(SL)) ;
%             WY = full(SY) ;
%             e = eig(-WY,ML);
%             Idx = (real(e) >= 0);
%             length(e(Idx))
%             min(real(e(Idx)))
%             plot(e,'o')
        end
    end
end