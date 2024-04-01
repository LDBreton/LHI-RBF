function [L2EvectY,L2EGradP,LinftyEvectY,LinftyEGradP] = compute_error_dirich(Pre,var_muu)

[f1m,f2m,u_exact1,u_exact2,p_x,p_y] = Exact_sol(var_muu);
P_sc = (Pre.P_sc);
P_fc = (Pre.P_fc);


Y_sol1 = u_exact1(P_sc);
Y_sol2 = u_exact2(P_sc);
B1 = u_exact1(P_fc);
B2 = u_exact2(P_fc);
F1 = f1m(P_sc);
F2 = f2m(P_sc);
Px_sol = p_x(P_sc);
Py_sol = p_y(P_sc);

RHS = [F1;F2] - Pre.SB*[B1;B2] - Pre.SL*[F1;F2];
Y_aprox = Pre.SY\RHS;
RHSP = [Y_aprox;B1;B2;F1;F2];
PGrad_aprox = [Pre.PY,Pre.PB,Pre.PL]*RHSP;

TRI = delaunayTriangulation(double(P_sc(:,1)),double(P_sc(:,2)));
Nin = length(P_sc(:,2));
ErrorY =  Y_aprox-[Y_sol1;Y_sol2];
ErrorGradP = PGrad_aprox-[Px_sol;Py_sol];
L2EvectY = sqrt(integrateTriangulation(TRI,ErrorY(1:Nin).^2 + ErrorY(Nin+1:end).^2));
L2EGradP=  sqrt(integrateTriangulation(TRI,ErrorGradP(1:Nin).^2 + ErrorGradP(Nin+1:end).^2));

LinftyEvectY = max(abs(ErrorY));
LinftyEGradP = max(abs(ErrorGradP));
end

