function [s,v,a,T,mot_spd] = ger_states_from_dT(dT,par)
a = [];
v = 0;
s = 0;
T = 0;
for i = 1:length(dT)
    new_T = T(end)+dT(i);
    T = [T,new_T];
end

Ft = T*par.fdg*par.Trans_eff/par.wlr;
for i = 1:length(Ft)-1
    new_a = (Ft(i+1) - 0.5 * par.ACd * par.rho * v(i)^2*(v(i)>0) - (par.Cr1+ par.Cr2*v(i))* par.mas * par.gav*(v(i)>0))/par.mas;
    new_v = max(v(i)+new_a,0);
    new_s = s(i)+new_v;
    a = [a,new_a];
    v = [v,new_v];
    s = [s,new_s];
end
a = a(1:end);
v = v(2:end);
s = s(2:end);
T = T(2:end);
mot_spd = v ./ par.wlr * par.fdg;
end

