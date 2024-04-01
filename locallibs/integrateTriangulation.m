function int = integrateTriangulation(trep, z)
P = trep.Points; T = trep.ConnectivityList;
d21 = P(T(:,2),:)-P(T(:,1),:);
d31 = P(T(:,3),:)-P(T(:,1),:);
areas = abs(1/2*(d21(:,1).*d31(:,2)-d21(:,2).*d31(:,1)));
int = areas'*mean(z(T),2);

end