% Librerias
addpath('../Libs/DivFree_libreria/');
addpath('../Libs/Cplus_matlab_interface/');
addpath('../Libs/AdvanpixMCT-4.5.2.12841/');
addpath('FreeFem_meshing/');
addpath('locallibs/');
mkdir('../Data_dirich/')
mp.Digits(100);
setenv('OMP_NUM_THREADS','8')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Settings.dir_name = '../Data/test/';
mkdir(Settings.dir_name);
Settings.presicion = 100;
Settings.Coutpresicion = 100;
Settings.NOperadoresX = 8;
Settings.NOperadoresY = 6;
Settings.programa = 'Cplusplus/LHI_Wegths_Save.out';
Settings.lib = 'Cplusplus/hibridKenerlgeneralLim.so';
%Obteniendo la solucion exacta y las fuentes de la ecuacion

Apoint = 1/20;
Astencial = 15;
Settings.Params = [0.0,0,mp('0.0'),mp('0.5'),mp('5e-4'),7,3,1.0];


[P_sc,P_fc] = Mesh_gen(Apoint,Apoint,1.0);
[Indices_sup,distancepp] = LHI_index(P_sc, P_fc,Astencial,[1 1 2],[0 0 0]);
Settings = write_files_mod(P_sc,P_fc,Indices_sup,distancepp,Settings);
Compute_matrixs_general_save(Settings,[5,6,7,8],length(P_sc));
[pesos,Pre] = read_weights_mp2(Settings.dir_name,[5 6]);

[SY,SB,SL] = FastWeight2Sparse(Indices_sup,Pre,pesos(:,1:2));

dt = 0.001;
ML = full(speye(size(SL))-(SL)) ;
WY = full(SY) ;
e = eig(-WY,ML);
alpha = [0 0 1];
beta = [-1/3 4/3];
puntos_f= puntos_frontera(alpha,beta,[0.7 1],0.01,0.01);

[in,on] = inpolygon(real(e),imag(e),real(puntos_f),imag(puntos_f));



condi = and(~in,~on);

h = plot(real(e),imag(e),'ko');
set(h,'MarkerSize',5);
legend(strcat('eigenvalues'))
xlabel('x-axis')
ylabel('y-axis')
title(['$(I-W_{L}^{L})^{-1}(-W_{L}^{y})$'], 'Interpreter', 'latex', 'FontSize', 30);
grid on
set(gca,'FontSize',30)