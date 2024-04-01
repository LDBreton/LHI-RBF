function [pesosC] = Compute_matrixs_general(Settings,Index_OperadorXPesos,Npesos)

 pesosC = cell([Npesos, length(Index_OperadorXPesos)]);
     Parametros = sprintf(' %f',Settings.Params);
     OperadoresIndex = ['"',sprintf('%d ',Index_OperadorXPesos),'"'];

     command = char(strcat('./',Settings.programa,...
         {' '} ,'./',num2str(Settings.lib),...
         {' '} ,num2str(Settings.presicion),...
         {' '} ,Settings.file_indices_1,...
         {' '} ,Settings.file_indices_2,...
         {' '} ,Settings.file_indices_3,...
         {' '} ,Settings.file_distance,...
         {' '} ,Settings.file_psc,...
         {' '} ,Settings.file_pfc,...
         {' '} ,num2str(Settings.NOperadoresX),...
         {' '} ,num2str(Settings.NOperadoresY),...
         {' '} ,OperadoresIndex,...
         {' '} ,num2str(Npesos) ...
         ));
     
     [status,cmdout] = system([command,Parametros]);
     
     Pesos_string = textscan(cmdout,'%s','Delimiter','\n');
     for k=1:length(Index_OperadorXPesos)
     for i=1:Npesos
         aux = textscan(Pesos_string{1}{i+(k-1)*Npesos},'%f');
         pesosC(i,k) = aux;
     end
     end
     
 end