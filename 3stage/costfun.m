function res = costfun(dT,g_s_time_seq_1,g_e_time_seq_1,ST)
% 这里是整个路程的累积能耗
load('ele_para');
%load('motorfit');
[s,v,a,T,mot_spd] = ger_states_from_dT(dT,par);
B = T;
T(T<0) = 0;
B(B>0) = 0;

eff_T = interp2(par.Mot_Sindx, par.Mot_Tindx, par.Mot_map, mot_spd, T,'linear'); % 电机效率查表
eff_B = interp2(par.Mot_Sindx, par.Mot_Tindx, par.Mot_map, mot_spd, -B,'linear'); % 电机效率查表
if(sum(isnan(eff_T)>0))
    disp('Contains NaN!!!')
end
eff_T(isnan(eff_T)) = 0.00001;
eff_B(isnan(eff_B)) = 0.00001;  %% 这里插值可能确实出现一些边缘上的NaN的情况，给一个很大的惩罚
Energy_cost = mot_spd.*T./eff_T./par.Discharge_eff;
Brake_cost = mot_spd.*B.*eff_B .*par.Charge_eff;

res = sum(Energy_cost+Brake_cost);
% % 信号灯过进惩罚
% traff_coef = 10;
% for i = 1:length(g_s_time_seq_1)
%     res = res - log(-s(g_s_time_seq_1(i))+ST{1}(i))*traff_coef;
% 	res = res - log(-ST{1}(i)+s(g_e_time_seq_1(i)))*traff_coef;
% end
end

