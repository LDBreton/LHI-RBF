muu=1.0e-03;
Dirsave_data = '../Amazonweights/Data_dirich/Data_Dirch_var_amazon_testings/';
FileName=[Dirsave_data,'Errores_muu_',num2str(muu),'_Stokes.txt'];
Dirsave = '/home/porufes/Dropbox/version_editorial-5-mayo/version_octubre/tables';
Fileout = [Dirsave,'/Table_LHI_Dirich_muu',num2str(muu),'.tex'];
% caption = ['Navier-Slip condition with $\mu$ = ',num2str(muu)];

Data = readmatrix(FileName);
Colnames = {'Total nodes','Local nodes',...
            '$||e_{y}||_{L_{2}}$','$||e_{y}||_{\infty}$',....
            '$||e_{\nabla p}||_{L_{2}}$','$||e_{\nabla p}||_{\infty}$',...
            'local cond','Sparse cond'};

fileID = fopen(Fileout,'w');
% fprintf(fileID,'\\begin{table} \n \\begin{centering} \n ');
fprintf(fileID,'\\begin{tabular}{%s',repmat('l',1,length(Colnames)));
fprintf(fileID,'} \n');

fprintf(fileID,'%s ',Colnames{1});
for i=2:length(Colnames)
fprintf(fileID,'& %s  ',Colnames{i});
end
fprintf(fileID,'\\tabularnewline \n');

for i=1:size(Data,1)
fprintf(fileID,' %d ',Data(i,1));
fprintf(fileID,' & %d ',Data(i,2));
fprintf(fileID,' & %.2e',Data(i,3:length(Colnames)));
fprintf(fileID,' \\tabularnewline \n');
end
fprintf(fileID,'\\end{tabular} \n');
% fprintf(fileID,'\\par\\end{centering} \n');
% fprintf(fileID,'\\caption{%s} \n',caption);
% fprintf(fileID,'\\end{table}');

fclose(fileID);