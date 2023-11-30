function [s,T,a,mot_spd] = ger_states_from_v(v,par)
mot_spd = v ./ par.wlr * par.fdg;
a = [];
s = 0;
T = [];
for i = 1:length(v)-1
    new_a = v(i+1)-v(i);
    new_Ft = new_a*par.mas+(par.Cr1+ par.Cr2*v(i))* par.mas * par.gav+0.5 * par.ACd * par.rho * v(i)^2;
    new_T = new_Ft*par.wlr/par.fdg/par.Trans_eff;
    new_s = s(i)+v(i);
    a = [a,new_a];
    T = [T,new_T];
    s = [s,new_s];
end
a = [a,0];
s = s(1:end-1);
T = [T,0];
end

