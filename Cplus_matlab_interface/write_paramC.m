function write_paramC(dir_name,distancepp)
fileID = fopen(strcat(dir_name,'distancias','.txt'),'w');
distancepp = distancepp / 2;
for i=1:length(distancepp)
fprintf(fileID,'%f \n',distancepp(i));
end
fclose(fileID);

end