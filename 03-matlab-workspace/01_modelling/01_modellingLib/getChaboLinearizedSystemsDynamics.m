function out = getChaboLinearizedSystemsDynamics()
% generate linearized systems parameter out of physical parameters
    % get Chabo parameters
	p = getChaboParameters();
        
    out.v1 = (p.IB+p.m1*p.l^2)*(p.m2+p.IT/p.r^2)-p.m1^2*p.l^2;
    out.v2 = p.IF;
    
    out.c1 = (p.m2+p.IT/p.r^2)*p.m1*p.l*p.g;
    out.c2 = p.m1^2*p.l^2;
    out.c3 = p.m1^2*p.l^2*p.g;
    out.c4 = (p.IB+p.m1*p.l^2)*p.m1*p.l;
    
    out.b1 = p.m2+p.IT/p.r^2+p.m1*p.l/p.r;
    out.b2 = p.m2+p.IT/p.r^2;
    out.b3 = p.m1*p.l+(p.IB+p.m1*p.l^2)/p.r;
    out.b4 = p.m1*p.l;
    
    out.uTmax   = p.uTmax; 
    out.uFmax   = p.uFmax;
    out.psiDmax = p.psiDmax; 
    
    out.a1 = out.c1 / out.v1;
    out.a2 = out.c3 / out.v1;
end 