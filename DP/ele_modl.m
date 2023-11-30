%% 路程主导电车离散模型 x(1)-速度 x(2)-时间  u（1）-电机力矩
function [X,C,I,out] = ele_modl(inp,par)
% Vehicle dynamics
% load('motorfit.mat');
% mf = motorfit;
C_roll = (par.Cr1 + par.Cr2 .* inp.X{1}) .* (inp.X{1}>1);                         % 滚动阻力
veh_acc1 =  0.5 .* par.rho .* par.ACd .* (inp.X{1}).^2.* (inp.X{1}>1);           % 空气阻力
veh_acc2 =  par.mas .* par.gav .* (C_roll);  % 滚动和坡度阻力
veh_trans = par.fdg;
tran_eff = 0.95;               % 传动系效率

T_wheel = (inp.U{1}>0).*inp.U{1} .* veh_trans .* tran_eff;         % 驱动力矩
T_brake = (inp.U{1}<0).*inp.U{1} .* veh_trans .* tran_eff;         % 再生制动力矩
veh_acc = (((T_wheel+T_brake) ./ par.wlr) - veh_acc1 - veh_acc2) ./ par.mas;   %车辆加速度

% Cycle dynamics

% X{1} = inp.X{1} + 1/(inp.X{1}+1e-12) .*veh_acc;    % current velocity, m/s
% X{2} = inp.X{2} + 1/(inp.X{1}+1e-12);          % current time, s
v_last_square = inp.X{1}.^2 + 2.*veh_acc;
inf_spd = v_last_square<=0;

X{1} = (abs(v_last_square)).^0.5;    % current velocity, m/s
X{2} = inp.X{2} + 2 / (X{1}+inp.X{1});                   % current time, s

inf_spd(X{1}<=0)=1;    % 非法速度
inf_spd(inp.X{1}<=0)=1;    % 非法速度
inf_spd(isnan(X{1}))=1;    % 非法速度

traf_t = 0;
inf_traff = zeros(size(X{1}));
if inp.W{1} == 0
    inf_traff = (X{1} > inp.W{2}); % 非法速度
elseif inp.W{1} == 1
    traf_t = (X{2} + inp.W{4} - floor((X{2}+inp.W{4})/inp.W{2})*inp.W{2}) .* inp.W{1};% 信号灯约束
    inf_traff = (traf_t <= inp.W{3}); 
elseif inp.W{1} == 2
    inf_traff = X{1} > 2;
end


% Energy dynamics, electricity cost & infeasible, W
mot_spd = inp.X{1} ./ par.wlr .* veh_trans;       % 电机转速rad/s
mot_trq = inp.U{1};                               % 电机转矩（含再生制动）N/m
mot_tqm = interp1(par.Mot_Sindx,par.Mot_maxtq,abs(mot_spd),'linear','extrap');  % 电机在某转速下的最大转矩
T = mot_trq;
B = T;
T(T<0) = 0;
B(B>0) = 0;
%mot_eff = interp2(par.Mot_Sindx, par.Mot_Tindx, par.Mot_map, mot_spd, abs(mot_trq)); % 电机效率查表
%mot_eff = (mf.p00 + mf.p10*abs(mot_spd) + mf.p01*inp.U{1} + mf.p20*abs(mot_spd).^2 + mf.p11*abs(mot_spd).*inp.U{1} + mf.p02*inp.U{1}.^2 + mf.p30*abs(mot_spd).^3 + mf.p21*abs(mot_spd).^2.*inp.U{1} + mf.p12*abs(mot_spd).*inp.U{1}.^2 + mf.p03*inp.U{1}.^3);

eff_T = interp2(par.Mot_Sindx, par.Mot_Tindx, par.Mot_map, mot_spd, T); % 电机效率查表
eff_B = interp2(par.Mot_Sindx, par.Mot_Tindx, par.Mot_map, mot_spd, -B); % 电机效率查表


%mot_eff(isnan(mot_eff)) = 0;
inf_mot = (abs(mot_trq)>mot_tqm)+(eff_T==0)+(eff_B==0);             % 非法转矩
inf_mot_spd = (abs(mot_spd)>par.Mot_Sindx(end));    % 非法转速
mot_pow = mot_spd.*mot_trq;              % 电机需求功率w

% Cost

Energy_cost =  (mot_pow>0).*mot_pow.*(2 / (X{1}+inp.X{1}))./(eff_T)./par.Discharge_eff;
Brake_ger =  (mot_pow<0).*mot_pow.*(2 / (X{1}+inp.X{1})).*(eff_B).*par.Charge_eff;

ele_cost = Energy_cost + Brake_ger;
C{1} = ele_cost;

% Feasibility
I =  inf_traff + inf_spd + inf_mot + inf_mot_spd ;

%output
out.veh_trans = veh_trans;
out.mot_trq = mot_trq;
out.mot_spd = mot_spd;
out.mot_pow = mot_pow;
out.veh_acc = veh_acc;
out.traf_t = traf_t;
out.Energy_cost = Energy_cost;
out.Brake_ger = Brake_ger;
out.ele_cost = ele_cost;
out.inf_spd = inf_spd;
out.inf_mot = inf_mot;
out.inf_mot_spd = inf_mot_spd;
out.inf_traf_lght = inf_traff;
out.T_brake = T_brake;
out.T_wheel = T_wheel;