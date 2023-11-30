clc;clear;close all;
model = 'ele_modl';
load ele_para;
scenario = 1;
ST = scenario_generator(scenario);
[prb,TrLig] = ST2prb(ST);
ar_t = TrLig(end)/10;

%%
% State variables
grd.Nx{1} = 101;   % speed, m/s
grd.Xn{1}.hi = 20;         grd.Xn{1}.lo = 0;
grd.X0{1} = 1;    % initial condition
grd.XN{1}.hi = grd.Xn{1}.hi;          grd.XN{1}.lo = 0;

grd.Nx{2} = 1001;   % time, s
grd.Xn{2}.hi = ar_t+1;        grd.Xn{2}.lo = 0;
grd.X0{2} = 0;
grd.XN{2}.hi = grd.Xn{2}.hi;    % terminal condition
grd.XN{2}.lo = 0;

% Control variable
grd.Nu{1} = 401;   % pre-transmission torque, Nm, positive - engine, negative - brake
grd.Un{1}.hi = 340;       grd.Un{1}.lo = -340;

%%
options = dpm();
options.MyInf = 1e10;
options.BoundaryMethod = 'none';
tic;
[res,dyn] = dpm(model,par,grd,prb,options);
t = toc;

%%
Distn = ST{1}(end);
disp('DP total computation time is ');disp(t);
run Ecodrive_plot
res.ele_cost(isnan(res.ele_cost)) = 0;
disp("DP能耗为 "+num2str(sum(res.ele_cost)/1000)+"kJ");
%write2csv('D:\3stageworkspace\DP\DP_res.csv',scenario,sum(res.ele_cost)/1000)
write2csv('D:\3stageworkspace\3stageworkspace\DP\DP_time.csv',scenario,t)
draw_motor(par,res.mot_spd,res.mot_trq);
save_file = "DP_res_"+num2str(scenario);
save(save_file,'res');

%%
st = interp1(res.X{2},0:length(res.X{2})-1,0:res.X{2}(end));
[e,valid] = energy_eval(st',false,[]);
if(valid)
    disp("DP能耗为 "+num2str(e/1000)+"kJ")
    write2csv('D:\3stageworkspace\3stageworkspace\DP\DP_res.csv',scenario,e/1000)
else
    disp("DP违反约束")
end