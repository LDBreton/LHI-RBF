function [pesosC] = Compute_matrixs_mp(Settings,Npesos,programa)

% Settings.prescion = 200;
% Settings.digit_print = 32;
% Settings.coeff_a = 2.0;
% Settings.coeff_b = 3.0;
% Settings.file_indices_1 = 'data/uniform/Indices_sup_uniform_1.txt';
% Settings.file_indices_2 = 'data/uniform/Indices_sup_uniform_2.txt';
% Settings.file_indices_3 = 'data/uniform/Indices_sup_uniform_3.txt';
% Settings.file_distance  = 'data/uniform/distance_uniform.txt';
% Settings.file_psc  = 'data/uniform/P_sc_uniform.txt';
% Settings.file_pfc  = 'data/uniform/P_fc_uniform.txt';
Digits = Settings.prescion;
Npesos = 1;
programa = 'Dirich_test';
command = char(strcat('./',programa,...
                       {' '} ,num2str(Settings.prescion),...
                       {' '} ,num2str(Settings.digit_print),...
                       {' '} ,num2str(Settings.coeff_a,Digits),...
                       {' '} ,num2str(Settings.coeff_b,Digits),...
                       {' '} ,Settings.file_indices_1,...
                       {' '} ,Settings.file_indices_2,...
                       {' '} ,Settings.file_indices_3,...
                       {' '} ,Settings.file_distance,...
                       {' '} ,Settings.file_psc,...
                       {' '} ,Settings.file_pfc,...
                       {' '} ,num2str(Settings.timestep,Digits),...
                       {' '} ,num2str(Settings.muu,Digits),...
                       {' '} ,num2str(Settings.ParamC,Digits), ...
                       {' '} ,num2str(Npesos) ...
                  ));
                   
 [status,cmdout] = system(command);
 
 Pesos_string = textscan(cmdout,'%s','Delimiter','\n');
 n_pesos = length(Pesos_string{1})/2;
 
 pesosC = cell([n_pesos, 2]);
 for i=1:n_pesos
 %aux = textscan(Pesos_string{1}{i},'%f');
 scanned = textscan(Pesos_string{1}{i},'%s');
 
 aux = scanned{1};
 mpaux = mp(zeros(length(aux),1));
 for j=1:length(aux)
    mpaux(j) = mp(aux{j});
 end
     
 pesosC(i,1) = {mpaux};
 end

 for j=1:n_pesos   
 %aux = textscan(Pesos_string{1}{j+n_pesos},'%f');
 scanned = textscan(Pesos_string{1}{j+n_pesos},'%s');
 
 aux = scanned{1};
 mpaux = mp(zeros(length(aux),1));
 for i=1:length(aux)
    mpaux(i) = mp(aux{i});
 end
     
 pesosC(j,2) = {mpaux};
 end

end