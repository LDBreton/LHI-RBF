%addpath('libs/Freefem_to_matlab/');
function [Settings] = write_files2(P_sc,P_fc,Indices_sup,dir_name)


fileID = fopen(strcat(dir_name,'P_sc2','.txt'),'w');
for i=1:length(P_sc)
fprintf(fileID,'%10.100f %10.100f \n',P_sc(i,:));
end
fclose(fileID);

fileID = fopen(strcat(dir_name,'P_fc2','.txt'),'w');
for i=1:length(P_fc)
fprintf(fileID,'%10.100f %10.100f \n',P_fc(i,:));
end
fclose(fileID);


for i=1:3
filename = strcat(dir_name,'Indices_sup2',num2str(i),'.txt'); 
fileID = fopen(filename,'w');
for j=1:length(Indices_sup)
if(isempty(Indices_sup{j,i}))
    fprintf(fileID,'%d ',-1);
else
    fprintf(fileID,'%d ',Indices_sup{j,i}-1);
end
fprintf(fileID,'\n');
end
fclose(fileID);
end

 Settings.file_indices_1 = strcat(dir_name,'Indices_sup',num2str(1),'.txt');
 Settings.file_indices_2 = strcat(dir_name,'Indices_sup',num2str(2),'.txt');
 Settings.file_indices_3 = strcat(dir_name,'Indices_sup',num2str(3),'.txt');
 Settings.file_distance  = strcat(dir_name,'distancias','.txt');
 Settings.file_psc  = strcat(dir_name,'P_sc','.txt');
 Settings.file_pfc  = strcat(dir_name,'P_fc','.txt');

 Settings.file_indices_12 = strcat(dir_name,'Indices_sup2',num2str(1),'.txt');
 Settings.file_indices_22 = strcat(dir_name,'Indices_sup2',num2str(2),'.txt');
 Settings.file_indices_32 = strcat(dir_name,'Indices_sup2',num2str(3),'.txt');
 Settings.file_psc2  = strcat(dir_name,'P_sc2','.txt');
 Settings.file_pfc2  = strcat(dir_name,'P_fc2','.txt');


end
