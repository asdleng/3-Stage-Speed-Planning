function [s,v,a,mot_spd] = ger_states_from_T(T,par)
a = 0;
v = 0;
s = 0;
Ft = T*par.fdg*par.Trans_eff/par.wlr;
for i = 1:length(Ft)
    new_a = (Ft(i) - 0.5 * par.ACd * par.rho * v(i)^2 - (par.Cr1+ par.Cr2*v(i))* par.mas * par.gav)/par.mas;
    new_v = max(v(i)+new_a,0);
    new_s = s(i)+new_v;
    a = [a,new_a];
    v = [v,new_v];
    s = [s,new_s];
end
a = a(2:end);
v = v(2:end);
s = s(2:end);
mot_spd = v ./ par.wlr * par.fdg;
end

