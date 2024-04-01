function Compute_matrixs_general_save2(Settings,Index_OperadorXPesos,Npesos)

     Parametros = sprintf(' %10.50f',Settings.Params);
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
         {' '} ,num2str(Npesos), ...
         {' '} ,Settings.dir_name,...
         {' '} ,num2str(Settings.Coutpresicion),...
         {' '} ,Settings.file_indices_12,...
         {' '} ,Settings.file_indices_22,...
         {' '} ,Settings.file_indices_32,...
         {' '} ,Settings.file_psc2,...
         {' '} ,Settings.file_pfc2...
         ));
     
        system([command,Parametros],'-echo');
     
     
 end