function [pesosC] = read_weights(dir_name,Index_OperadorXPesos)
mp.read
P_sc = readmatrix([dir_name,'P_sc.txt']);
P_fc = readmatrix([dir_name,'P_fc.txt']);
CondMs = readmatrix([dir_name,'rcond_file.txt']);
Npesos = length(P_sc);

fileID = fopen([dir_name,'pesos_file.txt']);
pesosC = cell([Npesos, length(Index_OperadorXPesos)]);

     
     Pesos_string = textscan(fileID,'%s','Delimiter','\n');
     for k=1:length(Index_OperadorXPesos)
     for i=1:Npesos
         aux = textscan(Pesos_string{1}{i+(k-1)*Npesos},'%f');
         pesosC(i,k) = aux;
     end
     end
fclose(fileID);     
end
 