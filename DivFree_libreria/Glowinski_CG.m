%Glowinsky Conjugate Gradienten method
%Solve the problem the linear problem
%Find u such
% <DJ(u),v > = <b,u> forall v
%Asuming <DJ(u),v > = <u,DJ(v) >
%DJ is linear
function u = Glowinski_CG(A,b,tol)
u= b;
g = A*u-b;
w = g;
gnorm0 = norm(g);

 
 Tolcondi =(norm(g)^2) / (norm(u)^2) ;  
 display(Tolcondi);

 if(Tolcondi <= tol)
	return;
 end
%
 while (Tolcondi > tol)
	gnorms = norm(g);
	pn = (gnorms^2)/((A*w)'*w);
	u = u -pn*w;
	g = g - pn*A*(w);

	Tolcondi = norm(g) / gnorm0;   
  	display(Tolcondi);

	gamman = (norm(g)/gnorms)^2 ; 
    w = g + gamman*w;
 end
