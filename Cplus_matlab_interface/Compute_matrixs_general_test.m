function Compute_matrixs_general_test(Settings,Index_OperadorXPesos,Npesos)

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
     
     [status,cmdout] = system([command,Parametros],'-echo');

     
 end