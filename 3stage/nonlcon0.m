function [c,ceq] = nonlcon(x)
load('ele_para');
v = x(2:end)-x(1:end-1);
v = [0;v];
a = v(2:end)-v(1:end-1);
a = [0;a];
Ft = par.mas*a + 0.5 * par.ACd * par.rho * v.^2 + (par.Cr1+ par.Cr2*v)* par.mas * par.gav;
T = Ft*par.wlr/par.Trans_eff/par.fdg;
mot_spd = v ./ par.wlr * par.fdg;
B = -T;
c = [];
ceq = [];
    % Define your nonlinear inequality constraints here
    for i = 1:length(T)
        c = [c;T(i)-interp1(par.Mot_Sindx,par.Mot_maxtq,mot_spd(i))];% 扭矩约束
        c = [c;mot_spd(i) - par.Mot_Sindx(end)];    % 电机转速约束
    end
end
