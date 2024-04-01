function [P_sc,P_fc] = Mesh_gen_randon(hboundary,NN,radius)

command = char(strcat('FreeFem++ -nw -v 0 FreeFem_meshing/Mesh_gen_boundary.edp', {' '},...
                      '-hb', {' '} ,num2str(hboundary,16),{' '},...
                      '-rad', {' '} ,num2str(radius,16),{' '},...
                      '-hin', {' '} ,num2str(hboundary,16),{' '}));
                  
                  
[status,cmdout] = system(command);
Meshdata = textscan(cmdout,'%f %f %d');

idxInsidePoint= (Meshdata{3}==0);

% P_sc = [ Meshdata{1}(idxInsidePoint), Meshdata{2}(idxInsidePoint) ];
P_fc = [ Meshdata{1}(~idxInsidePoint), Meshdata{2}(~idxInsidePoint) ];

thetaaux=0:0.001:2*pi;
P_fcx = radius*((0.8 + 0.1*(sin(6.0*thetaaux) + sin(3.0*thetaaux))).*cos(thetaaux));
P_fcy = radius*((0.8 + 0.1*(sin(6.0*thetaaux) + sin(3.0*thetaaux))).*sin(thetaaux)); 

RandPx=2*rand(10*NN,1)-1;
RandPy=2*rand(10*NN,1)-1;

[in,on] = inpolygon(RandPx',RandPy',P_fcx,P_fcy);

P_sc = [RandPx(in(1:NN)),RandPy(in(1:NN))];
% hold on
% scatter(P_fc(:,1),P_fc(:,2))
% scatter(RandPx(in),RandPy(in))
% hold off
% hold on
% plot(P_sc(:,1),P_sc(:,2),'.r')
% plot(P_fc(:,1),P_fc(:,2),'.b')
% hold off