function [pesosC,Pre] = read_weights_mp2(dir_name,Index_OperadorXPesos)
P_sc = mp.read([dir_name,'P_sc.txt']);
P_fc = mp.read([dir_name,'P_fc.txt']);
CondMs = mp.read([dir_name,'rcond_file.txt']);

Npesos = length(P_sc);
fileID = fopen([dir_name,'pesos_file.txt']);
pesosC = cell([Npesos, length(Index_OperadorXPesos)]);

     
     Pesos_string = textscan(fileID,'%s','Delimiter','\n');
     for k=1:length(Index_OperadorXPesos)
     for i=1:Npesos
         fileIDaux = fopen('tempfile2.txt','w');
         fprintf(fileIDaux,'%s',Pesos_string{1}{i+(k-1)*Npesos});
         aux = mp.read('tempfile2.txt');
         fclose(fileIDaux);     
         pesosC(i,k) = {aux};
     end
     end
fclose(fileID);

Pre.P_sc = P_sc;
Pre.P_fc = P_fc;
Pre.CondMs = CondMs;

end
 