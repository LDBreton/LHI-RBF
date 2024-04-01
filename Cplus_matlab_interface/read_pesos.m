 

 fid = fopen('postproces_data/uniform/bdf2_pesos1_uniform.txt');
 test = textscan(fid,'%s','Delimiter','\n');

 n_pesos = length(test{1});
 pesos = cell([n_pesos, 2]);
 for i=1:n_pesos
 aux = textscan(test{1}{i},'%f');
 pesos(i,1) = aux;
 end
 fclose(fid);

 
 fid = fopen('postproces_data/uniform/bdf2_pesos2_uniform.txt');
 test = textscan(fid,'%s','Delimiter','\n');
 n_pesos = length(test{1});
 for i=1:n_pesos
 aux = textscan(test{1}{i},'%f');
 pesos(i,2) = aux;
 end
 fclose(fid);
 
 save('postproces_data/uniform/pesos_bdf2_uniform.mat','pesos');
