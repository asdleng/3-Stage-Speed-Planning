function [opt_s,opt_v,opt_a,opt_mot_spd,opt_T,fval,p2,v2] = optimize_trajectory(asd_s_1,ST,par,vis_flag)
% 显示通行区间
ar_time_seq_1= interp1(asd_s_1,0:length(asd_s_1)-1,ST{1});
for i=1:(length(ST{1})-1)
    for j=1:20
        g_s_time_1 = ST{2}(i)*(j-1)+ST{3}(i)-ST{4}(i);
        g_e_time_1= ST{2}(i)*j-ST{4}(i);
        if(ar_time_seq_1(i)<=g_e_time_1&ar_time_seq_1(i)>=g_s_time_1)
            g_s_time_seq_1(i) = g_s_time_1;
            g_e_time_seq_1(i) = g_e_time_1;
            break;
        end
    end
     p{1,5}= plot([g_s_time_seq_1(i),g_e_time_seq_1(i)],[ST{1}(i),ST{1}(i)],'-g','LineWidth',1.5);%显示通行区间
end
% 构造初始解
%asd_s_1 = [0;asd_s_1];
v = asd_s_1(2:end)-asd_s_1(1:end-1);
v = [0;v];
a = v(2:end)-v(1:end-1);
Ft = par.mas*a + 0.5 * par.ACd * par.rho * v(2:end).^2 + (par.Cr1+ par.Cr2*v(2:end))* par.mas * par.gav;
Ft = [0;Ft];
T = Ft*par.wlr/par.Trans_eff/par.fdg;
dT = T(2:end)-T(1:end-1);
mot_spd = v ./ par.wlr * par.fdg;

options = optimoptions('fmincon','Display', 'iter','MaxFunctionEvaluations',10000,'UseParallel',true,'PlotFcns','optimplotfval');
options.OptimalityTolerance = 1e-6;
options.ConstraintTolerance = 1e-6;

% % 信号灯约束
% A_1= zeros(2*(length(ST{1})-1),length(asd_s_1));
% b_1= zeros(2*(length(ST{1})-1),1);
% for i=1:(length(ST{1})-1)
%     A_1(i,g_s_time_seq_1(i)+1) = 1;
%     b_1(i) = ST{1}(i);
%     A_1(i+(length(ST{1})-1),g_e_time_seq_1(i)+1) = -1;
%     b_1(i+(length(ST{1})-1)) = -ST{1}(i);
% end
% % % 扭矩约束
% % Ft = par.mas*a + 0.5 * par.ACd * par.rho * v.^2 + (par.Cr1+ par.Cr2*v)* par.mas * par.gav;
% % T = Ft*par.wlr/par.Trans_eff/par.fdg;
% %%终端条件
% Aeq_1= zeros(2,length(asd_s_1));
% Aeq_1(1,1) = 1; Aeq_1(2,end) = 1;
% beq_1= zeros(2,1);
% beq_1(end) = asd_s_1(end);tic;
tic;
[opt_dT,fval]= fmincon(@(dT)costfun(dT,g_s_time_seq_1,g_e_time_seq_1,ST),dT',[],[],[],[],-1000*ones(length(dT),1),1000*ones(length(dT),1),@(dT)nonlcon(dT,g_s_time_seq_1,g_e_time_seq_1,ST),options);toc;
[opt_s,opt_v,opt_a,opt_T,opt_mot_spd] = ger_states_from_dT(opt_dT,par);

if vis_flag
    figure(1)
    p2 = plot(0:1:length(opt_s)-1,opt_s,'Color',[94,39,29]/100,'LineWidth',1.0);
    figure(4)
    v2 = plot(opt_s,opt_v,'Color',[94,39,29]/100,'LineWidth',1.5);
    figure(1)
end
end

