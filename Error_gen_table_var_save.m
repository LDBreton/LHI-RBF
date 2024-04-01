% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
mkdir('../Data_dirich/')
Dirsave_data = '../Data/hibridKenerlR73LimGood/';
mp.Digits(100);
mkdir(Dirsave_data);
%Obteniendo la solucion exacta y las fuentes de la ecuacion
Avar_muu = [1.0];
Apoint = [1/2000];
Astencial = [15];
setenv('OMP_NUM_THREADS','15')
for lk=1:length(Avar_muu)
    for k=1:length(Apoint)
        [P_sc,P_fc] = Mesh_gen(Apoint(k),Apoint(k),0.01);
        for j=1:length(Astencial)
            nn_stencil = Astencial(j);
            dir_name =  strcat(Dirsave_data,num2str(nn_stencil),'_',num2str(Apoint(k)),'_',num2str(Avar_muu(lk)),'/');
            mkdir(dir_name);
            [Indices_sup,distancepp] = LHI_index(P_sc, P_fc,Astencial(j),[1 1 2],[0 0 0]);
            Settings = write_files(P_sc,P_fc,Indices_sup,distancepp,dir_name);
            Settings.programa = 'Cplusplus/LHI_Wegths_Save.out';
            Settings.lib = 'Cplusplus/hibridKenerlR73LimGood.so';
            Settings.presicion = 100;
            Settings.Coutpresicion = 100;
            Settings.NOperadoresX = 8;
            Settings.NOperadoresY = 6;
            Settings.dir_name = dir_name;
            %{'gammass1','gammass2','cesp','c','cpre','mus'};
            Settings.Params = [mp('1e-5'),mp('1e-6'),mp('0.0'),mp('0.5'),mp('0.0005'),Avar_muu(lk)];

            disp('calculando pesos')
            tic;
            Compute_matrixs_general_save(Settings,[5,6,7,8],length(P_sc));
            timecomputed=toc;
            timecomputed
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
            [SY,SB,SL] = FastWeight2Sparse(Parameters.Indices_sup,Pre,pesos(:,1:2));
            ML = full(speye(size(SY))-(SL)) ;
            WY = full(SY) ;
            e = eig(-WY,ML);
            Idx = (real(e) > 0);
            length(e(Idx))
            min(real(e(Idx)))
            plot(e,'o')
        end
    end
end