function [c,ceq] = nonlcon(dT,g_s_time_seq_1,g_e_time_seq_1,ST)
load('ele_para');
[s,v,a,T,mot_spd] = ger_states_from_dT(dT,par);
B = -T;
c = [];
ceq = [];       
    % 终点约束
    ceq = [ceq;s(end)-ST{1}(end)];
    % 信号灯约束
    for i = 1:length(g_s_time_seq_1)
        c = [c;s(g_s_time_seq_1(i)) - ST{1}(i)+5];
        c = [c;ST{1}(i) - s(g_e_time_seq_1(i))+5];
    end
    % 动力系统约束
    for i = 1:length(T)
        c = [c;mot_spd(i) - par.Mot_Sindx(end)];    % 电机转速约束
        c = [c;-mot_spd(i)];    % 电机转速约束
        c = [c;T(i)-interp1(par.Mot_Sindx,par.Mot_maxtq,max(min(mot_spd(i),par.Mot_Sindx(end)), 0))];% 扭矩约束
    end

end
